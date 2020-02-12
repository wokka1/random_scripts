# written by wokka, use at your own risk :)

# these should be obvious to any SE/Torch admin, but here is a simple explanation / example:
# C:\torch\instance\saves\World1\backup  < the actual game directory / location of the backups
# $gameDir\instance\saves\$saveName\backup  < substituted with variables to make it easy on you, less typoes

# scheduler can be done from cmd prompt using this: 
# schtasks /CREATE /SC DAILY /TN "backups" /TR "c:\Users\Administrator\backup.ps1" /ST 07:00
# for help : https://www.windowscentral.com/how-create-task-using-task-scheduler-command-prompt

# make sure you don't input any extra \ or anything  
# make sure you have a manual backup before running this, just in case you goof it :)

$gameDir = "c:\torch"
$saveName = "world1"
$backupDir = "c:\tmp"
$remoteDir = "/remote_dir"
$remoteHost = "192.168.0.20"
$password = ConvertTo-SecureString "myL33tpw" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("oberon", $password)

#  don't modify anything below this line

$timeStamp = $(Get-Date -Format "yyyy-MM-dd-HHmmss")

# zip up files in backup directory
Compress-Archive -Path $gameDir\instance\saves\$saveName\backup\ -DestinationPath $backupDir\$saveName-backup-$timeStamp

# remove backups to keep things clean
Remove-Item -Path $gameDir\instance\saves\$saveName\backup\* -Recurse

# scp the file over to the remote host
Set-SCPFile -ComputerName $remoteHost -Credential $Cred -Remotepath $remoteDir -LocalFile $backupDir\$saveName-backup-$timeStamp.zip

# copy the backup on network
# Copy-Item $backupDir\$saveName-backup-$timeStamp.zip $remoteDir
