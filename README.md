# Tenable_Updaters

Remote into other machines for updating. The base script will reach out to the NetBios name in a Tenable export CSV, then see if it can be reached (ping). If successful, it will navigate and kick-off the update.

*Future Update* will provide a list of IP addresses for remediation scans.

## Update_Adobe-AUM.ps1

Assumes that Adobe Update Manager is installed on the machine.

## Update_Office.ps1

Uses Click-to-Run to update. This process does have user interaction, which they can cancel the update after the download is complete. The updater will ask again often.
