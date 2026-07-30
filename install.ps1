<#
.SYNOPSIS
  Deploys the Claude agent scaffold into a target project directory.

.DESCRIPTION
  Copies the shared `common/` tree and the selected pack overlay into the
  target project. Safe to re-run - existing files are preserved unless
  -Force is supplied.

.PARAMETER NewProjectDir
  Absolute or relative path to the target project directory. Created if it
  does not exist.

.PARAMETER Pack
  Pack and optional version, e.g. `csharp`, `csharp@v1`, `appsheet@v1`.
  Default: csharp (latest version).

.PARAMETER Force
  Overwrite existing files in the target. Without this flag, existing files
  are skipped and reported.

.PARAMETER AllowPackSwitch
  Proceed when the target's recorded .claude/.pack names a different pack
  than -Pack. Without this flag, installing a different pack over an
  existing install is refused after listing the files that would be
  orphaned. Re-installing the same pack (any version) is never a switch
  and never requires this flag.

.EXAMPLE
  .\install.ps1 -NewProjectDir C:\repos\MyService

.EXAMPLE
  .\install.ps1 -NewProjectDir ..\my-project -Pack appsheet@v1 -Force

.EXAMPLE
  .\install.ps1 -NewProjectDir ..\my-project -Pack terraform -Force -AllowPackSwitch
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $NewProjectDir,

    [string] $Pack = 'csharp',

    [switch] $Force,

    [switch] $AllowPackSwitch
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = $scriptRoot
$commonRoot = Join-Path $sourceRoot 'common'

if (-not (Test-Path $commonRoot)) {
    Write-Error "Source layout not found. Expected common/ at $sourceRoot"
    exit 1
}

# Parse pack@version.
if ($Pack -match '^(?<name>[^@]+)(@(?<version>.+))?$') {
    $packName = $Matches['name']
    $packVersion = if ($Matches['version']) { $Matches['version'] } else { 'latest' }
} else {
    Write-Error "Invalid -Pack value: $Pack. Expected <name> or <name>@<version>."
    exit 1
}

$packDir = Join-Path $sourceRoot "packs/$packName"
if (-not (Test-Path $packDir)) {
    Write-Host "Unknown pack: $packName. Available:"
    Get-ChildItem -Path (Join-Path $sourceRoot 'packs') -Directory |
        ForEach-Object { Write-Host "  $($_.Name)" }
    exit 1
}

if ($packVersion -eq 'latest') {
    $versionDirs = Get-ChildItem -Path $packDir -Directory |
        Where-Object { $_.Name -match '^v[0-9]+$' } |
        Sort-Object { [int]($_.Name.Substring(1)) }
    if (-not $versionDirs) {
        Write-Error "Pack '$packName' has no installable versions yet. See packs/$packName/PACK.md"
        exit 1
    }
    $packVersion = $versionDirs[-1].Name
}

$packVersionDir = Join-Path $packDir $packVersion
if (-not (Test-Path $packVersionDir)) {
    Write-Host "Unknown version '$packVersion' for pack '$packName'. Available:"
    Get-ChildItem -Path $packDir -Directory |
        Where-Object { $_.Name -match '^v[0-9]+$' } |
        ForEach-Object { Write-Host "  $($_.Name)" }
    exit 1
}

$claudeTemplateRel = 'do-work/templates/CLAUDE.md.template'
$claudeTemplatePath = Join-Path $packVersionDir $claudeTemplateRel
if (-not (Test-Path $claudeTemplatePath)) {
    Write-Error "Pack '$packName@$packVersion' is missing required $claudeTemplateRel"
    exit 1
}

$target = Resolve-Path -Path $NewProjectDir -ErrorAction SilentlyContinue
if (-not $target) {
    Write-Host "Creating target directory: $NewProjectDir"
    New-Item -ItemType Directory -Path $NewProjectDir -Force | Out-Null
    $target = Resolve-Path -Path $NewProjectDir
}

# Guard against pack mixing. The installer never removes files, so replacing
# an installed pack with a different one orphans the first pack's
# uniquely-named agents (still discoverable and spawnable by Claude Code) and
# silently swaps same-named agents (ratchet.md, reviewer.md, git-workflow.md,
# do-work-run) between incompatible toolchains and ratchet dimension sets.
$existingPackFile = Join-Path $target '.claude/.pack'
if (Test-Path $existingPackFile) {
    $existingPackName = $null
    $existingPackVersion = $null
    Get-Content $existingPackFile | ForEach-Object {
        if ($_ -match '^pack:\s*(.+)$') { $existingPackName = $Matches[1].Trim() }
        if ($_ -match '^version:\s*(.+)$') { $existingPackVersion = $Matches[1].Trim() }
    }

    if ($existingPackName -and $existingPackName -ne $packName) {
        $oldPackVersionDir = Join-Path $sourceRoot "packs/$existingPackName/$existingPackVersion"
        $orphaned = @()
        if (Test-Path $oldPackVersionDir) {
            $oldFiles = Get-ChildItem -Path $oldPackVersionDir -Recurse -File |
                ForEach-Object { $_.FullName.Substring($oldPackVersionDir.Length).TrimStart('\', '/') }
            $newFiles = Get-ChildItem -Path $packVersionDir -Recurse -File |
                ForEach-Object { $_.FullName.Substring($packVersionDir.Length).TrimStart('\', '/') }
            $newFilesSet = [System.Collections.Generic.HashSet[string]]::new([string[]] $newFiles)
            $orphaned = $oldFiles | Where-Object { -not $newFilesSet.Contains($_) } | Sort-Object
        }

        if (-not $AllowPackSwitch) {
            Write-Host "Target was installed with pack '$existingPackName@$existingPackVersion'. Requested pack is '$packName@$packVersion'."
            Write-Host "Refusing: installing a different pack over an existing install orphans the previous pack's files - Claude Code still discovers and can spawn orphaned agents by their frontmatter 'name:', and same-named agents (ratchet.md, reviewer.md, git-workflow.md, the do-work-run command) get silently swapped between incompatible toolchains and ratchet dimension sets."
            Write-Host ""
            if ($orphaned.Count -gt 0) {
                Write-Host "$($orphaned.Count) file(s) unique to '$existingPackName@$existingPackVersion' would be orphaned:"
                $orphaned | ForEach-Object { Write-Host "  - $_" }
            } else {
                Write-Host "Could not enumerate the previous pack's overlay - packs/$existingPackName/$existingPackVersion is no longer present in this scaffold checkout."
            }
            Write-Host ""
            Write-Host "Re-run with -AllowPackSwitch to proceed anyway."
            exit 1
        }

        Write-Host "Switching pack: '$existingPackName@$existingPackVersion' -> '$packName@$packVersion' (-AllowPackSwitch supplied)."
        if ($orphaned.Count -gt 0) {
            Write-Host "$($orphaned.Count) file(s) unique to '$existingPackName@$existingPackVersion' will be orphaned:"
            $orphaned | ForEach-Object { Write-Host "  - $_" }
        }
        Write-Host ""
    }
}

Write-Host "Source: $sourceRoot"
Write-Host "Pack:   $packName@$packVersion"
Write-Host "Target: $target"
Write-Host ""

$copied  = @()
$skipped = @()

$claudeTemplateRelSep = $claudeTemplateRel -replace '/', [IO.Path]::DirectorySeparatorChar

function Copy-Tree {
    param([string] $SourcePath)

    Get-ChildItem -Path $SourcePath -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($SourcePath.Length).TrimStart('\', '/')
        $relNorm  = $relative -replace '/', [IO.Path]::DirectorySeparatorChar

        if ($relNorm -eq $claudeTemplateRelSep) {
            return
        }

        $destPath = Join-Path $target $relative
        $destDir  = Split-Path -Parent $destPath
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        if ((Test-Path $destPath) -and -not $Force) {
            $script:skipped += $relative
            return
        }

        Copy-Item -Path $_.FullName -Destination $destPath -Force
        $script:copied += $relative
    }
}

Copy-Tree -SourcePath $commonRoot
Copy-Tree -SourcePath $packVersionDir

# Special-case: install CLAUDE.md.template from the chosen pack to <target>/CLAUDE.md.
$claudeDest = Join-Path $target 'CLAUDE.md'
if ((Test-Path $claudeDest) -and -not $Force) {
    $skipped += 'CLAUDE.md'
} else {
    Copy-Item -Path $claudeTemplatePath -Destination $claudeDest -Force
    $copied += 'CLAUDE.md'
}

# Write pack identity sentinel.
$packSentinel = Join-Path $target '.claude/.pack'
$sentinelDir = Split-Path -Parent $packSentinel
if (-not (Test-Path $sentinelDir)) {
    New-Item -ItemType Directory -Path $sentinelDir -Force | Out-Null
}
$scaffoldCommit = try {
    (git -C $sourceRoot rev-parse --short HEAD 2>$null).Trim()
} catch { 'unknown' }
if (-not $scaffoldCommit) { $scaffoldCommit = 'unknown' }
$timestamp = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
@"
pack: $packName
version: $packVersion
installed_at: $timestamp
scaffold_commit: $scaffoldCommit
"@ | Set-Content -Path $packSentinel -Encoding utf8

Write-Host "Copied $($copied.Count) file(s):"
$copied | ForEach-Object { Write-Host "  + $_" }

if ($skipped.Count -gt 0) {
    Write-Host ""
    Write-Host "Skipped $($skipped.Count) existing file(s) - re-run with -Force to overwrite:"
    $skipped | ForEach-Object { Write-Host "  - $_" }
}

Write-Host ""
Write-Host "Pack identity written to .claude/.pack"
Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "  1. cd $target"
Write-Host "  2. Review CLAUDE.md and .claude/conventions/"
Write-Host "  3. git add . && git commit -m 'chore: bootstrap claude agent scaffold'"
