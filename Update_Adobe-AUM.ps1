<#
.Description

Takes Tenable CSV export and sends updates using the Adobe Update Manager (if installed).

.Notes
This enters a PS Session, admin credentials may be required. The PSSession is closed upon exit.

.Link
https://helpx.adobe.com/enterprise/using/using-remote-update-manager.html
#>

$Date = Get-Date -UFormat "%Y%m%d"
Start-Transcript -Path logs\$Date-Adobe_Update.txt -Append
# Pull list of names from a docuemnt
$Collection = Import-Csv .\Tenable.csv | Select-Object -ExpandProperty NetBios

# Option to use an admin account
$sesh = Get-Credential

Foreach ($item in $Collection) {

    # test to see if computer in list is online
    $online = Test-Connection $item -quiet -count 1
    if ($online) {
        # Open a remote session on the named computer and run the update.
        Invoke-Command -ComputerName $item -Credential $sesh -scriptblock {
        Set-Location 'C:\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager\';
        & .\RemoteUpdateManager.exe --action=install
        }
        Write-Information "$item is done."
    } else {
            Write-Warning "$item is not reachable."
    }
}
Stop-Transcript