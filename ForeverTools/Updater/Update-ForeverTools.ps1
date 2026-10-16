[CmdletBinding()]
param(
    [string]$GamePath,
    [switch]$Watch,
    [switch]$Background,
    [switch]$Notify,
    [switch]$EnableStartup,
    [switch]$ListenOnly,
    [switch]$LibraryOnly
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Get-Sha256([string]$Path) {
    $stream = [IO.File]::OpenRead($Path)
    $hash = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hash.ComputeHash($stream))).Replace('-', '').ToLowerInvariant() }
    finally { $hash.Dispose(); $stream.Dispose() }
}

function Get-HelperArguments([string]$Script, [string]$Root) {
    return '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $Script + '" -GamePath "' + $Root + '" -Watch -Notify -ListenOnly'
}

function Set-ForeverToolsStartup([string]$Script, [string]$Root, [string]$Directory) {
    if (!$Directory) { $Directory = [Environment]::GetFolderPath('Startup') }
    [void][IO.Directory]::CreateDirectory($Directory)
    $linkPath = Join-Path $Directory 'ForeverTools Update-Helfer.lnk'
    $shell = New-Object -ComObject WScript.Shell
    try {
        $link = $shell.CreateShortcut($linkPath)
        $link.TargetPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $link.Arguments = Get-HelperArguments $Script $Root
        $link.WorkingDirectory = [IO.Path]::GetDirectoryName($Script)
        $link.WindowStyle = 7
        $link.Description = 'ForeverTools: Updates ueber den Button im Spiel empfangen'
        $link.Save()
    } finally { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($shell) }
    return $linkPath
}

function Remove-ForeverToolsStartup {
    $path = Join-Path ([Environment]::GetFolderPath('Startup')) 'ForeverTools Update-Helfer.lnk'
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path }
}

function Get-UpdateRequests([string]$Root) {
    $requests = @{}
    $accounts = Join-Path $Root 'WTF\Account'
    if (Test-Path -LiteralPath $accounts) {
        # Only account-wide ForeverTools settings. Never execute saved Lua.
        foreach ($account in Get-ChildItem -LiteralPath $accounts -Directory) {
            $file = Join-Path $account.FullName 'SavedVariables\ForeverTools.lua'
            if (Test-Path -LiteralPath $file) {
                try {
                    $text = [IO.File]::ReadAllText($file)
                    if ($text -match '\["updateRequest"\]\s*=\s*(\d+)') {
                        $requests[$file] = $Matches[1]
                    }
                } catch { } # WoW may briefly lock the file while saving.
            }
        }
    }
    return $requests
}

function Assert-SafeAddonPath([string]$Name) {
    if ($Name -notmatch '^[A-Za-z][A-Za-z0-9_-]{0,79}$' -or $Name -match '^(CON|PRN|AUX|NUL|COM[0-9]|LPT[0-9])$') {
        throw "Ungueltiger Addon-Ordner: $Name"
    }
}

function Assert-SafeFilePath([string]$Name) {
    # These two bundled updater files are part of the trusted ForeverTools package.
    # They are installed as files; the running updater never executes downloaded scripts.
    if ($Name -ceq 'Update.cmd' -or $Name -ceq 'Updater/Update-ForeverTools.ps1') { return }
    if ($Name -notmatch '^[A-Za-z0-9_./-]+$' -or $Name.Contains('\') -or
        $Name.StartsWith('/') -or $Name.Split('/') -contains '..' -or
        $Name.Split('/') -contains '.' -or $Name.Contains('//') -or
        [IO.Path]::GetExtension($Name) -notin @('.lua','.toc','.ogg','.wav','.mp3','.blp','.tga','.png','.txt','.md','.xml')) {
        throw "Ungueltige Addon-Datei: $Name"
    }
    foreach ($part in $Name.Split('/')) {
        if ($part -match '^(CON|PRN|AUX|NUL|COM[0-9]|LPT[0-9])(\.|$)' -or $part.EndsWith('.')) {
            throw "Reservierter Dateiname: $Name"
        }
    }
}

function Assert-NoLink([string]$Path) {
    $current = [IO.Path]::GetFullPath($Path)
    while ($current) {
        if (Test-Path -LiteralPath $current) {
            if ((Get-Item -LiteralPath $current -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Verknuepfungen werden nicht beschrieben: $current"
            }
        }
        $current = [IO.Path]::GetDirectoryName($current)
    }
}

function Install-AddonFiles([object]$Catalog, [string]$Source, [string]$Destination, [string]$Backup) {
    if ($Catalog.schema -ne 1 -or @($Catalog.addons).Count -ne 1 -or $Catalog.addons[0].folder -ne 'ForeverTools') {
        throw 'Ungueltiger Katalog: Nur das gemeinsame ForeverTools-Addon ist erlaubt.'
    }
    $names = @{}
    $plan = New-Object 'System.Collections.Generic.List[object]'
    foreach ($addon in $Catalog.addons) {
        Assert-SafeAddonPath $addon.folder
        if ($names.ContainsKey($addon.folder)) { throw 'Doppelter Addon-Ordner.' }
        $names[$addon.folder] = $true
        $files = @{}
        foreach ($file in $addon.files) {
            Assert-SafeFilePath $file.path
            if ($files.ContainsKey($file.path) -or $file.sha256 -notmatch '^[a-f0-9]{64}$') { throw 'Ungueltiger Dateikatalog.' }
            $files[$file.path] = $true
            $relative = $addon.folder + '/' + $file.path
            $sourceFile = Join-Path $Source $relative
            if (!(Test-Path -LiteralPath $sourceFile -PathType Leaf) -or
                (Get-Sha256 $sourceFile) -ne $file.sha256) {
                throw "Dateipruefung fehlgeschlagen: $relative"
            }
            $target = Join-Path $Destination $relative
            Assert-NoLink $target
            if (Test-Path -LiteralPath $target -PathType Container) { throw "Dateiziel ist ein Ordner: $target" }
            $plan.Add(@{source=$sourceFile; target=$target; backup=(Join-Path $Backup $relative); existed=(Test-Path -LiteralPath $target)})
        }
        if (!$files.ContainsKey($addon.folder + '.toc')) { throw "TOC fehlt: $($addon.folder)" }
    }
    if (!$names.ContainsKey('ForeverTools')) { throw 'ForeverTools fehlt im Katalog.' }
    # Validate ALL downloads before touching installed files. Back up every overwritten file.
    foreach ($item in $plan) {
        if ($item.existed) {
            [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($item.backup))
            Copy-Item -LiteralPath $item.target -Destination $item.backup
        }
    }
    $changed = New-Object 'System.Collections.Generic.List[object]'
    try {
        foreach ($item in $plan) {
            [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($item.target))
            $changed.Add($item)
            Copy-Item -LiteralPath $item.source -Destination $item.target -Force
        }
    } catch {
        $installError = $_
        $rollbackErrors = @()
        foreach ($item in $changed) {
            try {
                if ($item.existed) { Copy-Item -LiteralPath $item.backup -Destination $item.target -Force }
                elseif (Test-Path -LiteralPath $item.target) { Remove-Item -LiteralPath $item.target -Force }
            } catch { $rollbackErrors += $_.Exception.Message }
        }
        if ($rollbackErrors.Count) { throw "Installation fehlgeschlagen; Sicherung unter $Backup behalten. Wiederherstellungsfehler: $($rollbackErrors -join '; ')" }
        throw $installError
    }
}

function Sync-ForeverTools([string]$Root) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = @{'User-Agent'='ForeverTools-Updater'; Accept='application/vnd.github+json'}
    $repo = 'https://api.github.com/repos/BP1904/ForeverTools'
    $commit = (Invoke-RestMethod -Uri "$repo/commits/main" -Headers $headers).sha
    if ($commit -notmatch '^[a-f0-9]{40}$') { throw 'Ungueltige GitHub-Version.' }
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $work = Join-Path $tempRoot ('ForeverTools-' + [guid]::NewGuid().ToString('N'))
    [void][IO.Directory]::CreateDirectory($work)
    $success = $false
    try {
        $archive = Join-Path $work 'source.zip'
        Invoke-WebRequest -UseBasicParsing -Uri "https://codeload.github.com/BP1904/ForeverTools/zip/$commit" -Headers $headers -OutFile $archive
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [IO.Compression.ZipFile]::OpenRead($archive)
        try {
            $prefix = "ForeverTools-$commit/"
            $source = Join-Path $work 'source'
            foreach ($entry in $zip.Entries) {
                if (!$entry.FullName.StartsWith($prefix, [StringComparison]::Ordinal)) { throw 'Unerwarteter ZIP-Pfad.' }
                $relative = $entry.FullName.Substring($prefix.Length)
                if (!$relative -or $relative.EndsWith('/')) { continue }
                # Extract only the data catalog and addon files, never downloaded updater scripts.
                if ($relative -ne 'catalog.json' -and $relative -notmatch '^[A-Za-z][A-Za-z0-9_-]*/') { continue }
                if ($relative.Contains('..') -or $relative.Contains('\') -or $relative.Contains(':')) { throw 'Unsicherer ZIP-Pfad.' }
                $out = [IO.Path]::GetFullPath((Join-Path $source $relative))
                if (!$out.StartsWith($source + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'ZIP-Pfad ausserhalb des Zielordners.' }
                [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($out))
                [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $out, $false)
            }
        } finally { $zip.Dispose() }
        $catalog = Get-Content -LiteralPath (Join-Path $source 'catalog.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        $destination = Join-Path $Root 'Interface\AddOns'
        Install-AddonFiles $catalog $source $destination (Join-Path $work 'backup')
        $short = $commit.Substring(0, 8)
        $checked = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $status = "local _, FT = ...`nFT.updateStatus = {commit = `"$short`", checked = `"$checked`"}`n"
        [IO.File]::WriteAllText((Join-Path $destination 'ForeverTools\UpdateStatus.lua'), $status, (New-Object Text.UTF8Encoding $false))
        Write-Host "ERFOLG: ForeverTools mit allen Modulen installiert/geprueft ($short)." -ForegroundColor Green
        Write-Host 'Jetzt im Spiel /reload. Bei neuen Addon-Ordnern WoW gegebenenfalls neu starten.'
        $success = $true
    } finally {
        $resolvedWork = [IO.Path]::GetFullPath($work)
        if ($success -and $resolvedWork.StartsWith($tempRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase) -and
            [IO.Path]::GetFileName($resolvedWork) -match '^ForeverTools-[a-f0-9]{32}$') {
            Remove-Item -LiteralPath $resolvedWork -Recurse -Force
        }
        elseif (!$success) { Write-Warning "Diagnose und vorhandene Sicherungen bleiben erhalten: $work" }
    }
}

function Invoke-RequestedUpdates([string]$Root, [hashtable]$Seen, [bool]$NotifyUser = $false) {
    $requests = Get-UpdateRequests $Root
    foreach ($file in $requests.Keys) {
        if ($Seen[$file] -ne $requests[$file]) {
            $Seen[$file] = $requests[$file]
            try {
                Sync-ForeverTools $Root
                if ($NotifyUser) { [void][Windows.Forms.MessageBox]::Show('Alle ForeverTools-Module wurden aktualisiert. Im Spiel jetzt /reload eingeben.', 'ForeverTools: Update fertig') }
            } catch {
                Write-Host "FEHLER: $_ | Im Spiel Update erneut anfordern." -ForegroundColor Red
                if ($NotifyUser) { [void][Windows.Forms.MessageBox]::Show("Update fehlgeschlagen: $_`nIm Spiel Update erneut anfordern.", 'ForeverTools: Update fehlgeschlagen') }
            }
        }
    }
}

if ($LibraryOnly) { return }
Add-Type -AssemblyName System.Windows.Forms
$configDir = Join-Path $env:LOCALAPPDATA 'ForeverTools'
$config = Join-Path $configDir 'game-path.txt'
if (!$GamePath -and (Test-Path -LiteralPath $config)) { $GamePath = [IO.File]::ReadAllText($config).Trim() }
if (!$GamePath) {
    $picker = New-Object Windows.Forms.FolderBrowserDialog
    $picker.Description = 'WoW-Clientordner mit WoW.exe, Interface und WTF auswaehlen (z.B. _classic_beta_).'
    if ($picker.ShowDialog() -ne [Windows.Forms.DialogResult]::OK) { exit }
    $GamePath = $picker.SelectedPath
    $picker.Dispose()
}
$GamePath = [IO.Path]::GetFullPath($GamePath)
if (!(Test-Path -LiteralPath (Join-Path $GamePath 'Interface') -PathType Container) -or
    @((Get-ChildItem -LiteralPath $GamePath -Filter 'Wow*.exe' -File)).Count -eq 0) {
    throw 'Kein WoW-Clientordner. Mit -GamePath den Ordner mit WoW.exe und Interface angeben.'
}
Assert-NoLink (Join-Path $GamePath 'Interface\AddOns')
[void][IO.Directory]::CreateDirectory($configDir)
[IO.File]::WriteAllText($config, $GamePath)
# A second watcher could race with file installation; allow only one per game folder.
$lockName = 'Local\ForeverTools-' + (($GamePath.ToLowerInvariant() -replace '[^a-z0-9]', '_'))
if ($EnableStartup) {
    $installedScript = Join-Path $GamePath 'Interface\AddOns\ForeverTools\Updater\Update-ForeverTools.ps1'
    if (!(Test-Path -LiteralPath $installedScript -PathType Leaf)) { throw 'ForeverTools zuerst im AddOns-Ordner installieren.' }
    $startupLink = Set-ForeverToolsStartup $installedScript $GamePath
    Write-Host "Einmalig eingerichtet: Windows startet den Update-Helfer kuenftig automatisch. ($startupLink)" -ForegroundColor Green
}
if ($Background) {
    $arguments = Get-HelperArguments $PSCommandPath $GamePath
    $powershell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    Start-Process -FilePath $powershell -ArgumentList $arguments -WindowStyle Hidden
    Write-Host 'Update-Helfer im Hintergrund gestartet. Im Spiel einfach /ad -> Update anklicken.' -ForegroundColor Green
    Write-Host 'Beenden oder Autostart ausschalten: ForeverTools-Symbol neben der Windows-Uhr.'
    return
}
$mutex = New-Object Threading.Mutex($false, $lockName)
if (!$mutex.WaitOne(0)) {
    $mutex.Dispose()
    if ($Watch) { return }
    throw 'Fuer diesen Spielordner laeuft bereits ein Updater.'
}
$tray = $null
if ($Notify) {
    Add-Type -AssemblyName System.Drawing
    $tray = New-Object Windows.Forms.NotifyIcon
    $tray.Icon = [Drawing.SystemIcons]::Application
    $tray.Text = 'ForeverTools: Ingame-Updates bereit'
    $trayMenu = New-Object Windows.Forms.ContextMenu
    $startupItem = $trayMenu.MenuItems.Add('Autostart ausschalten und beenden')
    $startupItem.add_Click({ Remove-ForeverToolsStartup; $script:stopWatcher = $true })
    $stopItem = $trayMenu.MenuItems.Add('Update-Helfer beenden')
    $stopItem.add_Click({ $script:stopWatcher = $true })
    $tray.ContextMenu = $trayMenu
    $tray.Visible = $true
}
try {
    Write-Host "ForeverTools-Updater | BP1904/ForeverTools | $GamePath"
    $seen = Get-UpdateRequests $GamePath
    if (!$ListenOnly) {
        try { Sync-ForeverTools $GamePath } catch {
            if (!$Watch) { throw }
            Write-Host "FEHLER: $_" -ForegroundColor Red
        }
    }
    if ($Watch) {
        Write-Host 'Bereit. Im Spiel: /ad -> Update.'
        Write-Host 'Keine automatischen Downloads im Hintergrund; naechster Download erst nach Update-Anforderung. Beenden: Strg+C.'
        $script:stopWatcher = $false
        while (!$script:stopWatcher) {
            if ($Notify) { [Windows.Forms.Application]::DoEvents() }
            if ($script:stopWatcher) { break }
            Start-Sleep -Seconds 2
            Invoke-RequestedUpdates $GamePath $seen ([bool]$Notify)
        }
    }
} finally {
    if ($tray) { $tray.Visible = $false; $tray.Dispose() }
    $mutex.ReleaseMutex(); $mutex.Dispose()
}
