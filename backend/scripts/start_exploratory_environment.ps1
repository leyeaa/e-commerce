param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('READINESS', 'E-01', 'E-02')]
    [string]$SessionId
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$FrontendRoot = Join-Path $RepoRoot 'frontend'
$EvidenceRoot = Join-Path $RepoRoot 'docs\project\results\exploratory'
$ProcessRecord = Join-Path $EvidenceRoot ($SessionId + '-processes.json')
$BackendLog = Join-Path $EvidenceRoot ($SessionId + '-backend.log')
$BackendErrorLog = Join-Path $EvidenceRoot ($SessionId + '-backend-error.log')
$FrontendLog = Join-Path $EvidenceRoot ($SessionId + '-frontend.log')
$FrontendErrorLog = Join-Path $EvidenceRoot ($SessionId + '-frontend-error.log')

function Assert-PortAvailable([int]$Port) {
    $Listener = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    if ($Listener) {
        throw ('Port ' + $Port + ' is already in use. Stop that service before starting the session.')
    }
}

function Wait-ForUrl([string]$Url, [int]$Seconds) {
    $Deadline = (Get-Date).AddSeconds($Seconds)
    do {
        try {
            $Response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 2
            if ($Response.StatusCode -ge 200 -and $Response.StatusCode -lt 500) {
                return
            }
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    } while ((Get-Date) -lt $Deadline)
    throw ('Service did not become ready: ' + $Url)
}

Assert-PortAvailable 8000
Assert-PortAvailable 5173
New-Item -ItemType Directory -Force -Path $EvidenceRoot | Out-Null

$BackendProcess = Start-Process `
    -FilePath 'powershell.exe' `
    -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'start_fuzz_server.ps1') `
    -WorkingDirectory $BackendRoot `
    -WindowStyle Hidden `
    -RedirectStandardOutput $BackendLog `
    -RedirectStandardError $BackendErrorLog `
    -PassThru

try {
    Wait-ForUrl 'http://127.0.0.1:8000/api/schema/' 60
    & (Join-Path $PSScriptRoot 'capture_exploratory_snapshot.ps1') `
        -SessionId $SessionId `
        -Label 'before'

    $FrontendProcess = Start-Process `
        -FilePath 'npm.cmd' `
        -ArgumentList 'run', 'dev', '--', '--host', '127.0.0.1', '--port', '5173', '--strictPort' `
        -WorkingDirectory $FrontendRoot `
        -WindowStyle Hidden `
        -RedirectStandardOutput $FrontendLog `
        -RedirectStandardError $FrontendErrorLog `
        -PassThru
    Wait-ForUrl 'http://127.0.0.1:5173/' 60

    $Record = @{
        session_id = $SessionId
        started_at = (Get-Date).ToString('o')
        backend_launcher_pid = $BackendProcess.Id
        frontend_launcher_pid = $FrontendProcess.Id
    }
    $Record | ConvertTo-Json | Set-Content -LiteralPath $ProcessRecord -Encoding utf8

    Write-Host 'Exploratory environment ready.'
    Write-Host 'Application: http://127.0.0.1:5173/'
    Write-Host 'Backend:     http://127.0.0.1:8000/'
    Write-Host ('Session:     ' + $SessionId)
}
catch {
    Stop-Process -Id $BackendProcess.Id -ErrorAction SilentlyContinue
    if ($FrontendProcess) {
        Stop-Process -Id $FrontendProcess.Id -ErrorAction SilentlyContinue
    }
    throw
}
