Function Start-Install{
Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
)

$workingDirectory = 'c:\drop'


$asset = (Get-RedirectedUrl $URL).split('/')[-1]

$installFolder = $asset.split('.')[0]

$installer = "$workingDirectory\$installFolder\$asset"


Try{mkdir "$workingDirectory\$installFolder"
    Write-Host 'Creating working directory'
}
catch{
    Write-Host 'Working directory exists'
}

if(!(Test-Path $installer)){
# download installer

Invoke-WebRequest -Uri $URL -OutFile $installer
}

return $installer


}


