#SQL Development installation
cls 

Set-Location -Path $PSScriptRoot
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
# Now running elevated so launch the script:

$cleanupDrop = $true 
$workingDirectory = 'C:\drop\VisualStudioInstall'


#TODO Check if VS 2019 has already been installed

$files = @(
    @{
        Uri = "https://aka.ms/vs/16/release/vs_professional.exe"
        Name = 'Visual Studio Professional 2019'
        Mirror1 = ''
        Check = '((Get-CimInstance MSFT_VSInstance -Namespace root/cimv2/vs).name -like "*Visual Studio Professional 2019*")'
        Args = '--quiet'
    },
    @{
        Uri = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/SSIS/vsextensions/SqlServerIntegrationServicesProjects/4.5/vspackage"
        Name = 'Visual Studio SSIS'
        Mirror1 = ''
        Check = 'Get-WmiObject -Class Win32_Product | sort-object Name | select Name | where { $_.Name -like "*SQL Server Integration Services*"}'
        Args = '--quiet'
    },
    @{
        Uri = "https://download.microsoft.com/download/1/a/a/1aaa9177-3578-4931-b8f3-373b24f63342/SQLServerReportingServices.exe"
        Name = 'Visual Studio SSRS'
        Mirror1 = ''
        Check = 'Get-WmiObject -Class Win32_Product | sort-object Name | select Name | where { $_.Name -like "*SQL Server Reporting Services*"}'
        Args = '/quiet /norestart /IAcceptLicenseTerms /Edition=Dev'
    },
    @{
        Uri = "https://www.kingswaysoft.com/downloads/releases/ssis/productivity-pack/IntegrationToolkit-ProductivityPack(v20.2.1)-x64.zip"
        Name = 'Kingswaysoft SSIS Productivity Pack'
        Mirror1 = ''
        Check = 'Get-WmiObject -Class Win32_Product | sort-object Name | select Name | where { $_.Name -like "*Productivity Pack*"}'
        Args = "Msiexec /i $workingDirectory\IntegrationToolkit-ProductivityPack-x64.msi /qn /l*v install.log"
    },
    @{
        Uri = "https://www.kingswaysoft.com/downloads/releases/ssis/dynamics-sl/IntegrationToolkit-DynamicsSL(v20.2)-x64.zip"
        Name = 'Kingswaysoft SSIS Integration Toolkit'
        Mirror1 = ''
        Check = 'Get-WmiObject -Class Win32_Product | sort-object Name | select Name | where { $_.Name -like "*Toolkit*"}'
        Args = "Msiexec /i $workingDirectory\IntegrationToolkit-DynamicsSL-x64.msi /qn /l*v install.log"
    }
)


####### NO CHANGES BELOW THIS LINE ###########
New-Item -ItemType Directory -Force -Path $workingDirectory

#Check url for redirection 
Function Get-RedirectedUrl{    
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )

    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()

    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }

}

Function Download-FromURL{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL,
        [String]$File
    )
    
    Try{
        $HTML = Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing -PassThru #| Write-Progress -Activity "Downloading file" -Status "Progress"
    }
    catch{
        Write-Host 'Microsoft is blocking the download, trying again in 30 seconds...'
    }
}

Function Get-Webfile ($url)
{
    $dest=(Join-Path $workingDirectory $url.SubString($url.LastIndexOf('/')))
    if(!(($dest -like '*.zip') -or ($dest -like '*.exe'))){
        $dest = $dest + '.exe'
    }
    Write-Host "Downloading $url`n" -ForegroundColor DarkGreen;
    $uri=New-Object "System.Uri" "$url"
    $request=[System.Net.HttpWebRequest]::Create($uri)
    $request.set_Timeout(5000)
    $response=$request.GetResponse()
    $totalLength=[System.Math]::Floor($response.get_ContentLength()/1024)
    $length=$response.get_ContentLength()
    $responseStream=$response.GetResponseStream()
    $destStream=New-Object -TypeName System.IO.FileStream -ArgumentList $dest, Create
    $buffer=New-Object byte[] 10KB
    $count=$responseStream.Read($buffer,0,$buffer.length)
    $downloadedBytes=$count
    while ($count -gt 0)
        {
        #[System.Console]::CursorLeft=0
        [System.Console]::Write("Downloaded {0}K of {1}K ({2}%)", [System.Math]::Floor($downloadedBytes/1024), $totalLength, [System.Math]::Round(($downloadedBytes / $length) * 100,0));''
        $destStream.Write($buffer, 0, $count)
        $count=$responseStream.Read($buffer,0,$buffer.length)
        $downloadedBytes+=$count
        
        }
    Write-Host ""
    Write-Host "`nDownload of `"$dest`" finished." -ForegroundColor DarkGreen;
    $destStream.Flush()
    $destStream.Close()
    $destStream.Dispose()
    $responseStream.Dispose()
}

function Clean-Dir{
    Remove-Item -LiteralPath $workingDirectory -Force -Recurse
}

#SCRIPT ENTRY

#Download all required Files
foreach($file in $files){
    $fileName = $file.name
    $URL = $file.Uri
    $mirror = $file.mirror1
    $checkCommand = $file.Check
    $installArgs = $file.args

    $redirectedURL = Get-RedirectedUrl $URL
    if($redirectedURL -ne $null){$URL = $redirectedURL}

    
    $destination =(Join-Path $workingDirectory $url.SubString($url.LastIndexOf('/')))
    if(!(($dest -like '*.zip') -or ($dest -like '*.exe'))){
        $dest = $dest + '.exe'
    }

    if(Invoke-Expression $checkCommand){Write-Host "$fileName is already Installed";continue}
    else{
        if(Test-Path $destination){Write-Host "$fileName is already Downloaded"}
        else{
            Write-Host "Downloading $fileName"
            Get-Webfile $URL
            Write-Host "Download complete"
        }

        if($destination -like "*.exe"){
            Write-Host "Installing $fileName"
            Start-Process -FilePath $destination -ArgumentList $installArgs -NoNewWindow -Wait
            Write-Host "Install complete"

        }
        else{
            Try{Expand-Archive -LiteralPath $destination -DestinationPath $workingDirectory -force}
            catch{}
            cmd /c $installArgs
        }
    }
}

if($cleanupDrop){Clean-Dir}
