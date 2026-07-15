param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('READINESS', 'E-01', 'E-02')]
    [string]$SessionId,

    [switch]$SkipAfterSnapshot
)

$ErrorActionPreference = 'Stop'
$BackendRoot = Split-Path -Parent $PSScriptRoot
$RepoRoot = Split-Path -Parent $BackendRoot
$EvidenceRoot = Join-Path $RepoRoot 'docs\project\results\exploratory'
$ProcessRecord = Join-Path $EvidenceRoot ($SessionId + '-processes.json')

if (-not $SkipAfterSnapshot) {
    & (Join-Path $PSScriptRoot 'capture_exploratory_snapshot.ps1') `
        -SessionId $SessionId `
        -Label 'after'
}

foreach ($Port in @(5173, 8000)) {
    $Listeners = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    foreach ($Listener in $Listeners) {
        $Process = Get-Process -Id $Listener.OwningProcess -ErrorAction SilentlyContinue
        if ($Process -and $Process.ProcessName -in @('node', 'python')) {
            Stop-Process -Id $Process.Id
            Write-Host ('Stopped ' + $Process.ProcessName + ' PID ' + $Process.Id + ' on port ' + $Port)
        }
    }
}

if (Test-Path -LiteralPath $ProcessRecord) {
    $Record = Get-Content -LiteralPath $ProcessRecord | ConvertFrom-Json
    foreach ($ProcessId in @($Record.frontend_launcher_pid, $Record.backend_launcher_pid)) {
        Stop-Process -Id $ProcessId -ErrorAction SilentlyContinue
    }
}

Write-Host ('Exploratory environment stopped for ' + $SessionId + '.')
