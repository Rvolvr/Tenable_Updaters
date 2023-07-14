# Tenable_Updaters

Remote into other machines for updating. The base script will reach out to the NetBios name in a Tenable export CSV, then see if it can be reached (ping). If successful, it will navigate and kick-off the update.

*Future Update* will provide a list of IP addresses for remediation scans.

## [Update_Adobe-RUM.ps1](https://raw.githubusercontent.com/Rvolvr/Tenable_Updaters/main/Update_Adobe-RUM.ps1)

Run Remove Update Manager from CSV list exported from Tenable. Will detect Remote Update Manager executable, or copy the files to the proper destination if not found. Will output a log, IP addresses for Tenable remediation scan, and list of computers which were not able to be reached.

## [Update_Office.ps1](https://raw.githubusercontent.com/Rvolvr/Tenable_Updaters/main/Update_Office.ps1)

Uses Click-to-Run to update. This process does have user interaction, which they can cancel the update after the download is complete. The updater will ask again often.

## [CSV_Path_processing.ps1](https://raw.githubusercontent.com/Rvolvr/Tenable_Updaters/main/CSV_Path_processing.ps1)

A template for converting multiple vulnerability output "Paths" in each computer to usable variables. 
