<#
.Description

Takes Tenable CSV export and sends updates using the Dell Command Update (if installed).

.Notes
This enters a PS Session, admin credentials may be required. The PSSession is closed upon exit.

.Link
https://www.dell.com/support/manuals/en-us/command-update/dellcommandupdate_rg/dell-command-%7C-update-cli-commands?guid=guid-92619086-5f7c-4a05-bce2-0d560c15e8ed&lang=en-us
#>

$Date = Get-Date -UFormat "%Y%m%d"
Start-Transcript -Path logs\$Date-Dell_Update.txt -Append
# Pull list of names from a docuemnt
$Collection = Get-Content .\Tenable.csv # | Select-Object -ExpandProperty NetBios

# Option to use an admin account
#$sesh = Get-Credential

Foreach ($item in $Collection) {

    # test to see if computer in list is online
    $online = Test-Path "\\$item\c$\Program Files\Dell\CommandUpdate\"
    if ($online) {
        # Open a remote session on the named computer and run the update.
        Invoke-Command -ComputerName $item -scriptblock {
        Set-Location 'C:\Program Files\Dell\CommandUpdate';
        & .\dcu-cli.exe /scan -silent;
        & .\dcu-cli.exe /driverinstall
        }
        Resolve-DnsName $item | Select-Object -ExpandProperty IPaddress | Out-File -FilePath .\$date_Adobe_rescan.txt -Append
    } else {
            Write-Warning "$item is not reachable."
    }
}
Stop-Transcript