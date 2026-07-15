param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('READINESS', 'E-01', 'E-02')]
    [string]$SessionId,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9-]+$')]
    [string]$Label
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$Python = Join-Path $RepoRoot '.venv\Scripts\python.exe'
$EvidenceRoot = Join-Path $RepoRoot 'docs\project\results\exploratory'
$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$Output = Join-Path $EvidenceRoot ($SessionId + '-' + $Label + '-' + $Timestamp + '.json')

New-Item -ItemType Directory -Force -Path $EvidenceRoot | Out-Null
Push-Location $BackendRoot
try {
    & $Python manage.py snapshot_experiment --settings backend.settings_fuzz |
        Out-File -LiteralPath $Output -Encoding utf8
    if ($LASTEXITCODE -ne 0) {
        throw 'Experiment snapshot failed.'
    }
    Write-Host ('Snapshot: ' + $Output)
}
finally {
    Pop-Location
}
