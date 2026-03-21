# Install the cloud-migration Claude skill
$BaseUrl    = "https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main"
$CommandsDir = Join-Path $env:USERPROFILE ".claude\commands"
$DataDir     = Join-Path $CommandsDir "cloud-migration"

Write-Host "Installing cloud-migration skill..."

# Create directories
New-Item -ItemType Directory -Force -Path $CommandsDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $DataDir "guardrails") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $DataDir "criteria")   | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $DataDir "red-flags")  | Out-Null

# Install main skill file
Invoke-WebRequest -Uri "$BaseUrl/SKILL.md" -OutFile (Join-Path $DataDir "SKILL.md")

# Install reference data files
Invoke-WebRequest -Uri "$BaseUrl/guardrails/migration-guardrails.md" -OutFile (Join-Path $DataDir "guardrails\migration-guardrails.md")
Invoke-WebRequest -Uri "$BaseUrl/criteria/migration-criteria.json"   -OutFile (Join-Path $DataDir "criteria\migration-criteria.json")
Invoke-WebRequest -Uri "$BaseUrl/red-flags/migration-red-flags.json" -OutFile (Join-Path $DataDir "red-flags\migration-red-flags.json")

Write-Host "Installed to $DataDir\SKILL.md"
Write-Host "Reference data installed to $DataDir\"
Write-Host "Restart Claude Code and invoke with: /cloud-migration"
