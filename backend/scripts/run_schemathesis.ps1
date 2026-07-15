param(
    [int]$MaxExamples = 1000,
    [int]$Seed = 9839,
    [string]$BaseUrl = 'http://127.0.0.1:8000'
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$St = Join-Path $RepoRoot '.venv\Scripts\st.exe'
$Results = Join-Path $RepoRoot 'docs\project\results'
$Username = $env:EXPERIMENT_USERNAME
$Password = $env:EXPERIMENT_PASSWORD
$env:PYTHONUTF8 = '1'
$env:PYTHONIOENCODING = 'utf-8'

if ([string]::IsNullOrWhiteSpace($Username)) {
    $Username = 'experiment_user'
}
if ([string]::IsNullOrWhiteSpace($Password)) {
    $Password = 'CourseProject-Only-Password-Change-Me'
}
if (-not (Test-Path -LiteralPath $St)) {
    throw 'Schemathesis executable was not found. Install requirements-dev.txt.'
}

$TokenBody = @{
    username = $Username
    password = $Password
} | ConvertTo-Json
$TokenResponse = Invoke-RestMethod `
    -Method Post `
    -Uri ($BaseUrl + '/api/token/') `
    -ContentType 'application/json' `
    -Body $TokenBody
$Authorization = 'Authorization: Bearer ' + $TokenResponse.access

New-Item -ItemType Directory -Force -Path $Results | Out-Null
$Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$OutputPath = Join-Path $Results ('schemathesis-' + $Timestamp + '.log')

Push-Location $BackendRoot
try {
    # Schemathesis writes progress and failures to both output streams. PowerShell
    # must not convert native stderr into a terminating NativeCommandError.
    $ErrorActionPreference = 'Continue'
    & $St `
        --config-file schemathesis.toml `
        run ($BaseUrl + '/api/schema/') `
        --url $BaseUrl `
        --include-path-regex '^/api/(cart/update|orders/create)/$' `
        --header $Authorization `
        --mode all `
        --checks 'not_a_server_error,status_code_conformance,content_type_conformance,response_schema_conformance,negative_data_rejection' `
        --max-examples $MaxExamples `
        --seed $Seed `
        --continue-on-failure `
        --no-color 2>&1 | Tee-Object -FilePath $OutputPath
    $RunExitCode = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    Write-Host ('Schemathesis log: ' + $OutputPath)
    exit $RunExitCode
}
finally {
    Pop-Location
}
