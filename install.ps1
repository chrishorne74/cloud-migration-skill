# Install the cloud-migration Claude skill
$CommandsDir = Join-Path $env:USERPROFILE ".claude\commands"
$SkillUrl = "https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main/cloud-migration.md"
$Destination = Join-Path $CommandsDir "cloud-migration.md"

Write-Host "Installing cloud-migration skill..."
New-Item -ItemType Directory -Force -Path $CommandsDir | Out-Null
Invoke-WebRequest -Uri $SkillUrl -OutFile $Destination
Write-Host "Installed to $Destination"
Write-Host "Restart Claude Code and invoke with: /cloud-migration"
