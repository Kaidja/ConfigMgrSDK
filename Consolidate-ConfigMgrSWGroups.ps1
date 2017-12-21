Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")
$CMSite = Get-PSProvider -PSProvider CMSITE
Set-Location -Path "$($CMSite.Drives.Name):\"

# 2017 Software Update Groups
    #Create new Software Update Group for 2017 Updates
    New-CMSoftwareUpdateGroup -Name 'SUM WRK 2017 Compliance'

    #Get 2017 Software Updates Groups
    $SWGroups = Get-CMSoftwareUpdateGroup -Name 'SUM WRK 2017*' -ForceWildcardHandling |
        ForEach-Object {
        
            foreach($Update in $PsItem.Updates){
                Add-CMSoftwareUpdateToGroup -SoftwareUpdateId $Update `
                    -SoftwareUpdateGroupName 'SUM WRK 2017 Compliance'
            }
        
        }     
