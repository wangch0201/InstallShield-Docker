$SABRoot = "C:\Program Files (x86)\InstallShield\2019 SAB\"
$SABSystem = $SABRoot + "\System"
$SABLicense = $SABSystem + "\License.lic"

$license = (get-item env:InstallShieldLicense).Value
$license | Out-File -FilePath $SABLicense -Encoding ASCII

cd $SABSystem

$installFilesDir = "C:\InstallerBuildFiles"
$prerequisitesDir = $installFilesDir + "\SetupPrerequisites"

$ismFilePath = Get-ChildItem -Path $installFilesDir -Filter *.ism | Select -First 1 | % { $_.FullName }

if ((Test-Path env:IsInstallerUpdatable) -and ((get-item env:IsInstallerUpdatable).Value.ToLower() -eq "true")) { 

	$productCode = "{" + (New-Guid).Guid.ToUpper() + "}"
	$packageCode = "{" + (New-Guid).Guid.ToUpper() + "}"
	
	if (Test-Path env:InstallerFileVersion){
		$installerFileVersion = (Get-Item env:InstallerFileVersion).Value
		.\IsCmdBld.exe -l VSSolutionFolder="$installFilesDir" -prqpath $prerequisitesDir -p $ismFilePath -y "$installerFileVersion" -z "ProductCode=$productCode" -z "PackageCode=$packageCode" -x
	} else {
		.\IsCmdBld.exe -l VSSolutionFolder="$installFilesDir" -prqpath $prerequisitesDir -p $ismFilePath -z "ProductCode=$productCode" -z "PackageCode=$packageCode" -x
	}
	
} else {

	if (Test-Path env:InstallerFileVersion){
		$installerFileVersion = (Get-Item env:InstallerFileVersion).Value
		.\IsCmdBld.exe -l VSSolutionFolder="$installFilesDir" -prqpath $prerequisitesDir -p $ismFilePath -y "$installerFileVersion" -x
	} else {
		.\IsCmdBld.exe -l VSSolutionFolder="$installFilesDir" -prqpath $prerequisitesDir -p $ismFilePath -x
	}
}