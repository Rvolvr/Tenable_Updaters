<#
.Description
Run Remove Update Manager from CSV list exported from Tenable. Will detect Remote Update Manager executable, or copy the files to the proper destination if not found. Will output a log, IP addresses for Tenable remediation scan, and list of computers which were not able to be reached.

.Notes
This enters a PS Session, administrator rights for the remote computer will be required. The PSSession is closed upon exit. Default config has the CSV, logs directory, and RemoteUpdateManager with files in the Documents folder.

.Link
https://helpx.adobe.com/enterprise/using/using-remote-update-manager.html
#>

$path = 'C:\Users\ADMIN\Documents'
$Date = Get-Date -UFormat "%Y%m%d"
Start-Transcript -Path $path\logs\$Date-Adobe_Update.txt -Append
# Pull list of names from a docuemnt
$Collection = Import-CSV "$path\Tenable.csv"

# Option to use an admin account
#$sesh = Get-Credential

Foreach ($item in $Collection.'asset.name') {

    # test to see if computer in list is online
    $online = Test-Path "\\$item\c$\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager\"
    $NeedRUM = Test-Path "\\$item\c$\"
    if ($online) {
        # Open a remote session on the named computer and run the update.
        Invoke-Command -ComputerName $item -scriptblock {
        & 'C:\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager\RemoteUpdateManager.exe' --action=install
        }
        Resolve-DnsName $item | Select-Object -ExpandProperty IPaddress | Out-File -FilePath "$path\$date-Adobe_rescan.txt" -Append
    } elseif ($NeedRUM) {
        Robocopy.exe "$path\RemoteUpdateManager" "\\$item\c$\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager" /MT /NP
        Invoke-Command -ComputerName $item -scriptblock {
            & 'C:\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager\RemoteUpdateManager.exe' --action=install
        }
        Resolve-DnsName $item | Select-Object -ExpandProperty IPaddress | Out-File -FilePath "$path\$date-Adobe_rescan.txt" -Append
    } Else {
            Write-Warning "$item is not reachable."
    }
}
Stop-Transcript
