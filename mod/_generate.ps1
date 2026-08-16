# Sinh file manifest.js liet ke tat ca file trong thu muc mod
$modDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outFile = Join-Path $modDir "manifest.js"

$items = @()
$files = Get-ChildItem -LiteralPath $modDir -File | Where-Object { $_.Name -ne "manifest.js" -and $_.Name -ne "_generate.ps1" }

foreach ($f in $files) {
    $sizeStr = if ($f.Length -ge 1MB) { "{0:N1} MB" -f ($f.Length / 1MB) }
               elseif ($f.Length -ge 1KB) { "{0:N1} KB" -f ($f.Length / 1KB) }
               else { "$($f.Length) B" }

    $items += [PSCustomObject]@{
        id   = "m_" + [Guid]::NewGuid().ToString("N").Substring(0, 8)
        name = $f.Name
        url  = "mod/" + $f.Name
        size = $sizeStr
        game = "Minecraft"
        desc = "File mod trong thu muc mod."
    }
}

# Dung mang JSON thuc su (ke ca khi chi co 1 phan tu) de web doc dung
$json = "[]"
if ($items.Count -gt 0) {
    $parts = @()
    foreach ($it in $items) {
        $obj = $it | ConvertTo-Json -Depth 4 -Compress
        $parts += $obj
    }
    $json = "[" + ($parts -join ",") + "]"
}
$content = "window.MOD_MANIFEST = " + $json + ";"
[System.IO.File]::WriteAllText($outFile, $content, [System.Text.UTF8Encoding]::new($false))

Write-Host "Da quet $($items.Count) mod trong thu muc mod."