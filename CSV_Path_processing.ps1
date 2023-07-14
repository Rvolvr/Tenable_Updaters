<#
.Description
This is designed to take CSV export using NETBIOS Name and Output from Tenable to then put into a workable format where each computer may have multiple issues.

.NOTES
This template was designed for finding "user" based findings, for example Teams instances. Change the "write-host/write-warning" lines with actions as needed.

.Link 
https://github.com/Rvolvr/Tenable_Updaters

#>

# Import CSV from Tenable
$Import = Import-Csv C:\temp\Import.csv

# Breaking up the entries for reconstruction, then added into the final variable.
[Array]$Results = ForEach ($entry in $Import){
    # Trimming the "output" informaiton into usable strings using split
    $path = -split $entry.output | select-string -Pattern user

    # create the backbone of the new information and import.
    [PSCustomObject]@{
        'computer' = $entry.'asset.netbios_name'
        'path' = $path
    }
}
Foreach ($vuln in $Results) {
    $vuln.computer
    Foreach ($folder in $vuln.path){
        $set = $folder -replace 'C:',"\\$($vuln.computer)\C$"
        If ($(test-path -Path "\\$($vuln.computer)\C$") -eq $false){
            Write-warning 'Offline!'
        } elseif (Test-Path -Path $set) {
           Write-host "Do Action"
        } Else {
            Write-host "File already processed"
        }
    }
}
