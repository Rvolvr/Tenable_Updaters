<#
.Description

Using a Tenable CSV export, update remote machines using the "Click to Run" version of Office.

.Notes
This enters a PS Session, admin credentials may be required.
#>

$Date = Get-Date -UFormat "%Y%m%d"
Start-Transcript -Path logs\$Date-Office_Update.txt -Append
# Pull list of names from a docuemnt
$Collection = Import-Csv .\Tenable.csv | Select-Object -ExpandProperty NetBios

# Option to use an admin account
$sesh = Get-Credential

Foreach ($item in $Collection) {

    # test to see if computer in list is online
    $online = Test-Connection $item -quiet -count 2
    if ($online) {

        # Open a remote session on the named computer and run the update.
        Invoke-Command -ComputerName $item -Credential $sesh -scriptblock {
        & 'C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe' /changesetting Channel=Current;
        & 'C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe' /update user
        }
        Resolve-DnsName $item | Select-Object -ExpandProperty IPaddress | Out-File -FilePath .\$date_Office_rescan.txt -Append
    } else {
            Write-Warning "$item is not reachable."
    }
}
Stop-Transcript