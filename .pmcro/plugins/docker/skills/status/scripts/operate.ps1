[CmdletBinding()]
param([switch]$Execute)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $Execute) {
    Write-Output 'dry run: docker version'
    exit 0
}
$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
    [Console]::Error.WriteLine('docker is not on PATH. This skill does not install it.')
    exit 1
}
& docker version
exit $LASTEXITCODE
