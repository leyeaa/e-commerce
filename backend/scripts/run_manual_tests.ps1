param(
    [string]$ResultPrefix = 'manual-formal'
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$Python = Join-Path $RepoRoot '.venv\Scripts\python.exe'
$Results = Join-Path $RepoRoot 'docs\project\results'

if (-not (Test-Path -LiteralPath $Python)) {
    throw 'Project Python executable was not found.'
}

New-Item -ItemType Directory -Force -Path $Results | Out-Null
$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$Log = Join-Path $Results ($ResultPrefix + '-' + $Timestamp + '.log')
$Junit = Join-Path $Results ($ResultPrefix + '-' + $Timestamp + '.xml')
$CoverageXml = Join-Path $Results ($ResultPrefix + '-coverage-' + $Timestamp + '.xml')

Push-Location $BackendRoot
try {
    & $Python -m coverage erase
    $Started = Get-Date
    $ErrorActionPreference = 'Continue'
    & $Python -m coverage run -m pytest tests\manual --junitxml $Junit 2>&1 |
        Tee-Object -FilePath $Log
    $RunExitCode = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    & $Python -m coverage report 2>&1 | Tee-Object -FilePath $Log -Append
    & $Python -m coverage xml -o $CoverageXml
    & $Python -m coverage html
    $Duration = (Get-Date) - $Started
    Add-Content -LiteralPath $Log -Value ('Wall-clock seconds: ' + [math]::Round($Duration.TotalSeconds, 3))
    Write-Host ('Manual log: ' + $Log)
    Write-Host ('JUnit XML: ' + $Junit)
    Write-Host ('Coverage XML: ' + $CoverageXml)
    exit $RunExitCode
}
finally {
    Pop-Location
}
