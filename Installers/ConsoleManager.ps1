#########################
## Console Manager     ##
## NIck Nieto 3/22/24  ##
#########################
cls

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$nameAllConsoles = @(
[pscustomobject]@{AppName='Bonjour';CommonName='Bonjour';SilentInstall='';WSL=''}
[pscustomobject]@{AppName='';CommonName='Geek';SilentInstall='';WSL=''}
[pscustomobject]@{AppName='';CommonName='';SilentInstall='';WSL=''}
)

$locationFileServer = 'C:\Users\Nick\OneDrive\Code\Dependencies\ConsoleManager'
$locationWebServer = 'https:\\'
$logfile = '$env:TEMP'

### No changes below this line ###

function Get-FileAccess{
    $accessFileServer = Test-Path $locationFileServer
    $accessWebServer = Test-Path $locationWebServer

    if($accessFileServer){$accessFileServer = "File server is accessable"}
    else{$accessFileServer = "File server not found"}

    if($accessWebServer){$accessWebServer = "Web server is accessable"}
    else{$accessWebServer = "Web server not found"}

    return "$accessFileServer
$accessWebServer"
}

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

Function UninstallWithCreds{
    $creds = Get-Credential
    $apps = Get-WmiObject -Class Win32_Product -ComputerName $computer.Name  -Credential $creds | Where-Object { $_.Name -like "*office*" }

    ForEach($app in $apps)
	{
		$app.Uninstall()
	}
}

Function NewDrive{
    New-PSDrive -Name Q -PSProvider FileSystem -Root \\my_server\my_root\my_dir -Credential my_domain\my_user -Persist
}
Function MapDrive{
    $net = New-Object -comobject Wscript.Network
    $net.MapNetworkDrive("Q:","\\my_server\my_root\my_dir",0,"my_domain\my_user","my_password")
}

Function FileServerInstall{
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param ($CommonName)

    Write-Host "$locationFileServer\$CommonName"
}

#### Script Start ###


Get-FileAccess




$count = 0
$currentConsole = $nameAllConsoles[0]
while($currentConsole -ne $null){
    $appName = $currentConsole.AppName
    $CommonName = $currentConsole.CommonName



    
    
    try{FileServerInstall $CommonName}
    catch{"Fileserver install failed";$FSIStatus = $false}
    
    <#
    if($FSIStatus = $false){
        try{WebServerInstall}
        catch{"Webserver install failed";$WSIStatus = $false}
    }
    
    if($WSIStatus = $false){
    
        $command = Read-Host 'Prompt for user Inpt'
    
    }
    
    
    
    
    pause
    
    
    
    $app = Get-WmiObject -Class Win32_Product | Where-Object { 
        $_.Name -match "$appName" 
    } 
    
    
    #>
    

    if($app -like $null){
        Write-Host "$CommonName not found"
    }
    else{
        Write-Host "$CommonName not found"
    }
    $count += 1
    $currentConsole = $nameAllConsoles[$count]
}








break

foreach($Console in $nameAllConsoles){
    $Console

    $ConsoleFSL = $Console.name
    $ConsoleWSL = $Console.value

    $ConsoleFSL
    #LogWrite $Console.InstallStatus

}






## UNCOMENT IN PROD
#LogWrite 'All done'
