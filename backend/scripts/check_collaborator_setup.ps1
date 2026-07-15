param(
    [switch]$SkipDatabase
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$FrontendRoot = Join-Path $RepoRoot 'frontend'
$Python = Join-Path $RepoRoot '.venv\Scripts\python.exe'
$BackendEnv = Join-Path $BackendRoot '.env'
$FrontendEnv = Join-Path $FrontendRoot '.env'
$Issues = [System.Collections.Generic.List[string]]::new()

function Read-EnvFile([string]$Path) {
    $Values = @{}
    if (-not (Test-Path -LiteralPath $Path)) {
        return $Values
    }
    foreach ($Line in Get-Content -LiteralPath $Path) {
        if ($Line -match '^\s*([^#=\s]+)\s*=\s*(.*)\s*$') {
            $Values[$Matches[1]] = $Matches[2]
        }
    }
    return $Values
}

if (-not (Test-Path -LiteralPath $Python)) {
    $Issues.Add('Missing .venv Python. Create the virtual environment and install backend/requirements-dev.txt.')
}
if (-not (Get-Command npm.cmd -ErrorAction SilentlyContinue)) {
    $Issues.Add('npm.cmd is unavailable. Install a supported Node.js release.')
}
if (-not (Test-Path -LiteralPath (Join-Path $FrontendRoot 'node_modules'))) {
    $Issues.Add('frontend/node_modules is missing. Run npm ci in frontend.')
}
if (-not (Test-Path -LiteralPath $BackendEnv)) {
    $Issues.Add('backend/.env is missing. Copy backend/.env.example and set local PostgreSQL values.')
}
if (-not (Test-Path -LiteralPath $FrontendEnv)) {
    $Issues.Add('frontend/.env is missing. Copy frontend/.env.example.')
}

$Environment = Read-EnvFile $BackendEnv
foreach ($Key in @('DB_USER', 'DB_PASSWORD', 'DB_HOST', 'DB_PORT')) {
    if (-not $Environment.ContainsKey($Key) -or [string]::IsNullOrWhiteSpace($Environment[$Key])) {
        $Issues.Add(('backend/.env requires a non-empty ' + $Key + ' value.'))
    }
}
if (
    -not $Environment.ContainsKey('FUZZ_DB_NAME') -or
    [string]::IsNullOrWhiteSpace($Environment['FUZZ_DB_NAME'])
) {
    $Environment['FUZZ_DB_NAME'] = 'ecommerce_course_project_fuzz'
    Write-Warning 'FUZZ_DB_NAME is absent; using the isolated settings default ecommerce_course_project_fuzz.'
}
if (
    $Environment.ContainsKey('DB_NAME') -and
    $Environment.ContainsKey('FUZZ_DB_NAME') -and
    $Environment['DB_NAME'] -eq $Environment['FUZZ_DB_NAME']
) {
    $Issues.Add('FUZZ_DB_NAME must differ from DB_NAME.')
}

foreach ($Port in @(8000, 5173)) {
    if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) {
        $Issues.Add(('Port ' + $Port + ' is already in use.'))
    }
}

if ($Issues.Count -gt 0) {
    Write-Host 'Collaborator setup is not ready:' -ForegroundColor Red
    foreach ($Issue in $Issues) {
        Write-Host ('- ' + $Issue)
    }
    exit 1
}

Write-Host 'Static prerequisites passed.' -ForegroundColor Green
& $Python --version
& npm.cmd --version

Push-Location $BackendRoot
try {
    & $Python manage.py check --settings backend.settings_fuzz
    if ($LASTEXITCODE -ne 0) {
        throw 'Django isolated-settings check failed.'
    }
    if (-not $SkipDatabase) {
        & $Python manage.py showmigrations --settings backend.settings_fuzz | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw 'Could not connect to the isolated PostgreSQL database.'
        }
        Write-Host 'Isolated PostgreSQL connection passed.' -ForegroundColor Green
    }
}
finally {
    Pop-Location
}

Write-Host 'Collaborator setup is ready for the READINESS rehearsal.' -ForegroundColor Green
