[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Workspace,
    [string]$Dockerfile = 'Dockerfile',
    [string]$Context = '.',
    [Parameter(Mandatory = $true)][ValidatePattern('^[A-Za-z0-9._/-]+(?::[A-Za-z0-9._-]+)?$')][string]$Tag,
    [switch]$Apply
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Workspace).Path
if (-not $root.EndsWith([IO.Path]::DirectorySeparatorChar)) { $root += [IO.Path]::DirectorySeparatorChar }
function Resolve-Scoped([string]$Relative, [switch]$Leaf) {
    if ([IO.Path]::IsPathRooted($Relative)) { throw 'Docker paths must be relative to Workspace' }
    $full = [IO.Path]::GetFullPath((Join-Path $root $Relative))
    $rootExact = $root.TrimEnd([IO.Path]::DirectorySeparatorChar)
    if (-not ($full.Equals($rootExact, [StringComparison]::OrdinalIgnoreCase) -or $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase))) { throw 'Docker path escapes Workspace' }
    if ($Leaf -and -not (Test-Path -LiteralPath $full -PathType Leaf)) { throw "Missing file: $Relative" }
    if (-not $Leaf -and -not (Test-Path -LiteralPath $full -PathType Container)) { throw "Missing directory: $Relative" }
    return $full
}
$dockerfileFull = Resolve-Scoped $Dockerfile -Leaf
$contextFull = Resolve-Scoped $Context
$display = "docker build --file `"$dockerfileFull`" --tag $Tag `"$contextFull`""
if (-not $Apply) { Write-Output "DRY-RUN $display"; exit 0 }
$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) { [Console]::Error.WriteLine('docker is not on PATH. This skill does not install it.'); exit 1 }
& docker build --file $dockerfileFull --tag $Tag $contextFull
exit $LASTEXITCODE
