#Command to kick off the setup script. Run in a 
#(mkdir c:\drop & cd c:\drop && curl -o Get-WindowsServer2022.ps1 https://raw.githubusercontent.com/IGL-Nick/Powershell-Tools/main/Installers/Get-WindowsServer2022.ps1 && powershell.exe -executionpolicy bypass -noprofile -file .\Get-WindowsServer2022.ps1)

#check for elevated permissions
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe -WindowStyle Hidden "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

