$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\..\tools\Update-ForeverTools.ps1" -LibraryOnly
$work = Join-Path ([IO.Path]::GetTempPath()) ('ForeverTools-Test-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($work)
function Assert($Condition, $Message) { if (!$Condition) { throw $Message } }
function Must-Reject([scriptblock]$Action) {
    $rejected = $false
    try { & $Action } catch { $rejected = $true }
    Assert $rejected 'Unsafe input was accepted'
}
try {
    $source = Join-Path $work 'source'
    $dest = Join-Path $work 'game\Interface\AddOns'
    [void][IO.Directory]::CreateDirectory((Join-Path $source 'ForeverTools'))
    [void][IO.Directory]::CreateDirectory((Join-Path $dest 'Unrelated'))
    [IO.File]::WriteAllText((Join-Path $source 'ForeverTools\ForeverTools.toc'), '## Interface: 16001')
    [IO.File]::WriteAllText((Join-Path $dest 'Unrelated\keep.txt'), 'keep')
    $hash = (Get-FileHash (Join-Path $source 'ForeverTools\ForeverTools.toc')).Hash.ToLowerInvariant()
    $catalog = @{schema=1; addons=@(@{folder='ForeverTools'; files=@(@{path='ForeverTools.toc'; sha256=$hash})})}
    Install-AddonFiles $catalog $source $dest (Join-Path $work 'backup1')
    Assert (Test-Path (Join-Path $dest 'ForeverTools\ForeverTools.toc')) 'Addon not installed'
    Assert ((Get-Content (Join-Path $dest 'Unrelated\keep.txt')) -eq 'keep') 'Unrelated addon changed'
    [IO.File]::WriteAllText((Join-Path $dest 'ForeverTools\ForeverTools.toc'), 'old')
    $catalog.addons[0].files[0].sha256 = 'a' * 64
    Must-Reject { Install-AddonFiles $catalog $source $dest (Join-Path $work 'backup2') }
    Assert ((Get-Content (Join-Path $dest 'ForeverTools\ForeverTools.toc')) -eq 'old') 'Failed verification modified installation'
    $catalog.addons[0].files[0].sha256 = $hash
    Install-AddonFiles $catalog $source $dest (Join-Path $work 'backup3')
    Assert ((Get-Content (Join-Path $work 'backup3\ForeverTools\ForeverTools.toc')) -eq 'old') 'Backup missing'
    [IO.File]::WriteAllText((Join-Path $source 'ForeverTools\Extra.lua'), 'new extra')
    $extraHash = (Get-FileHash (Join-Path $source 'ForeverTools\Extra.lua')).Hash.ToLowerInvariant()
    $catalog.addons[0].files += @{path='Extra.lua'; sha256=$extraHash}
    [IO.File]::WriteAllText((Join-Path $dest 'ForeverTools\ForeverTools.toc'), 'rollback original')
    $script:failSource = Join-Path $source 'ForeverTools\Extra.lua'
    function Copy-Item {
        param([string]$LiteralPath, [string]$Destination, [switch]$Force)
        if ($LiteralPath -eq $script:failSource) { throw 'Simulated write failure' }
        Microsoft.PowerShell.Management\Copy-Item -LiteralPath $LiteralPath -Destination $Destination -Force:$Force
    }
    try {
        Must-Reject { Install-AddonFiles $catalog $source $dest (Join-Path $work 'backup-rollback') }
        Assert ((Get-Content (Join-Path $dest 'ForeverTools\ForeverTools.toc')) -eq 'rollback original') 'Rollback failed'
    } finally { Remove-Item Function:\Copy-Item }
    $catalog.addons[0].files = @($catalog.addons[0].files[0])
    foreach ($path in @('../escape.lua', '/absolute.lua', 'x\bad.lua', 'script.ps1', 'x//bad.lua', 'CON.lua', 'dir/../bad.lua')) {
        Must-Reject { Assert-SafeFilePath $path }
    }
    foreach ($name in @('..', 'Bad/Folder', 'CON', 'C:\WoW')) { Must-Reject { Assert-SafeAddonPath $name } }
    Assert-SafeFilePath 'Update.cmd'
    Assert-SafeFilePath 'Updater/Update-ForeverTools.ps1'
    Must-Reject { Assert-SafeFilePath 'Updater/Other.ps1' }
    $catalog.addons += @{folder='ForeverTools'; files=@()}
    Must-Reject { Install-AddonFiles $catalog $source $dest (Join-Path $work 'backup4') }
    $otherAddon = @{schema=1; addons=@(@{folder='AutoRank'; files=@()})}
    Must-Reject { Install-AddonFiles $otherAddon $source $dest (Join-Path $work 'backup-other') }
    $saved = Join-Path $work 'game\WTF\Account\123\SavedVariables'
    [void][IO.Directory]::CreateDirectory($saved)
    [IO.File]::WriteAllText((Join-Path $saved 'ForeverTools.lua'), 'ForeverToolsDB = { ["updateRequest"] = 123456, } error("NEVER EXECUTE")')
    $requests = Get-UpdateRequests (Join-Path $work 'game')
    Assert ($requests.Count -eq 1 -and @($requests.Values)[0] -eq '123456') 'Request not recognized'
    # End-to-end offline: fixed GitHub commit, archive extraction, catalog validation and status.
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Add-Type -AssemblyName System.IO.Compression
    $script:testCommit = 'b' * 40
    $archiveRoot = Join-Path $work 'archive'
    $payload = Join-Path $archiveRoot ('ForeverTools-' + $script:testCommit)
    [void][IO.Directory]::CreateDirectory((Join-Path $payload 'ForeverTools'))
    Copy-Item (Join-Path $source 'ForeverTools\ForeverTools.toc') (Join-Path $payload 'ForeverTools\ForeverTools.toc')
    $catalog.addons = @($catalog.addons[0])
    [IO.File]::WriteAllText((Join-Path $payload 'catalog.json'), ($catalog | ConvertTo-Json -Depth 10))
    $script:testZip = Join-Path $work 'download.zip'
    $zipWriter = [IO.Compression.ZipFile]::Open($script:testZip, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($file in Get-ChildItem -LiteralPath $archiveRoot -File -Recurse) {
            $relative = $file.FullName.Substring($archiveRoot.Length + 1).Replace('\', '/')
            [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipWriter, $file.FullName, $relative)
        }
    } finally { $zipWriter.Dispose() }
    function Invoke-RestMethod { return @{sha=$script:testCommit} }
    function Invoke-WebRequest { param($Uri, $Headers, $OutFile, [switch]$UseBasicParsing)
        Assert ($Uri.EndsWith($script:testCommit)) 'Download not pinned to commit'
        Copy-Item -LiteralPath $script:testZip -Destination $OutFile
    }
    Sync-ForeverTools (Join-Path $work 'game')
    $status = Get-Content (Join-Path $dest 'ForeverTools\UpdateStatus.lua') -Raw
    Assert ($status.Contains('bbbbbbbb') -and $status.Contains('checked')) 'Status not written'
    Write-Host 'PASS: install, backup, hash failure, unrelated files, path validation, duplicate catalog, safe request parsing'
    Write-Host 'PASS: complete offline download/extract/install/status flow'
} finally {
    $resolved = [IO.Path]::GetFullPath($work)
    $temp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if ($resolved.StartsWith($temp, [StringComparison]::OrdinalIgnoreCase) -and [IO.Path]::GetFileName($resolved) -match '^ForeverTools-Test-[a-f0-9]{32}$') {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
