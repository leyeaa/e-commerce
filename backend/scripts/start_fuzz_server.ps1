param(
    [switch]$SkipReset
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$Python = Join-Path $RepoRoot '.venv\Scripts\python.exe'

if (-not (Test-Path -LiteralPath $Python)) {
    throw 'Project virtual environment was not found.'
}

$env:DJANGO_SETTINGS_MODULE = 'backend.settings_fuzz'

Push-Location $BackendRoot
try {
    & $Python manage.py migrate --settings backend.settings_fuzz
    if ($LASTEXITCODE -ne 0) {
        throw 'Fuzz database migration failed.'
    }

    $seedArguments = @(
        'manage.py',
        'seed_experiment',
        '--settings',
        'backend.settings_fuzz'
    )
    if (-not $SkipReset) {
        $seedArguments += '--reset'
    }
    & $Python @seedArguments
    if ($LASTEXITCODE -ne 0) {
        throw 'Experiment seed failed.'
    }

    Write-Host 'Fuzz server: http://127.0.0.1:8000'
    Write-Host 'Schema:      http://127.0.0.1:8000/api/schema/'
    & $Python manage.py runserver 127.0.0.1:8000 --noreload --settings backend.settings_fuzz
}
finally {
    Pop-Location
}
