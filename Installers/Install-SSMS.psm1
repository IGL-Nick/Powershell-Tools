Function Install-SSMS{

$URL = 'https://go.microsoft.com/fwlink/?linkid=2199013&clcid=0x409'

$installer = Start-Install $URL


$install_path = "$env:SystemDrive\SSMSto"
$params = "/Install /Quiet SSMSInstallRoot=`"$install_path`""
Start-Process -FilePath $installer -ArgumentList $params -Wait


}
