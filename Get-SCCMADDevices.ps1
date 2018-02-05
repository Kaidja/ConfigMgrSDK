Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")
$CMSite = Get-PSProvider -PSProvider CMSITE
Set-Location -Path "$($CMSite.Drives.Name):\"

#Currently quering All Systems Collection.
$InActiveClients = Get-CMCollectionMember -CollectionName 'All Systems'

$ProcessedObjects = @()
foreach($Client in $InActiveClients){

    $Client.Name
    Try{
        $ADComputerInfo = Get-ADComputer -Identity $Client.Name -Properties LastLogonDate,OperatingSystem -ErrorAction STOP

            $Properties = { 
             [Ordered]@{ 
                Name = $Client.Name
                OS = $ADComputerInfo.OperatingSystem
                Enabled = $ADComputerInfo.Enabled
                LastLogonDate = $ADComputerInfo.LastLogonDate
                LastLogonDateInDays = if(!([System.string]::IsNullOrEmpty($ADComputerInfo.LastLogonDate))){(New-TimeSpan -Start $ADComputerInfo.LastLogonDate -End (Get-Date)).days}Else{"N/A"}
                LastPolicyRequest = $Client.LastPolicyRequest
        }}

    }
    Catch{
            $Properties = { 
             [Ordered]@{ 
                Name = $Client.Name
                OS = 'N/A'
                Enabled = 'N/A'
                LastLogonDate = 'N/A'
                LastLogonDateInDays = 'N/A'
                LastPolicyRequest = 'N/A'
            } }

    
    }
    $ProcessedObjects += New-Object -TypeName PSObject -Property (&$Properties)
}

$ProcessedObjects | Export-Csv -Path E:\Scripts\LOGS\CMInActiveClients.csv -NoTypeInformation -Delimiter ';'
