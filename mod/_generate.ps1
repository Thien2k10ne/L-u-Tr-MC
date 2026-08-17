# Sinh file manifest.js liet ke tat ca file trong thu muc mod
# File duoc xep vao chuyen muc theo thu muc cha:
#   mod\mod     -> mod
#   mod\texture -> texture
#   mod\map     -> map
#   mod\skin    -> skin
#   (file o root) -> mod
$modDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outFile = Join-Path $modDir "manifest.js"

# Anh bia rieng cho tung mod (map theo ten file)
$thumbMap = @{
    "Hydra_Visuals.mcpack"            = "https://media.forgecdn.net/attachments/1861/107/banner-740x340-png.png"
    "Animated glowing ores v1.7.0 .mcpack" = "thumbs/ores.gif"
    "Mike_Ultra_Visuals.mcpack"       = "thumbs/mike_ultra.png"
}

# Map ten thu muc -> chuyen muc
$folderCatMap = @{
    "mod"     = "mod"
    "texture" = "texture"
    "map"     = "map"
    "skin"    = "skin"
}

# Phan loai mac dinh theo duoi file (chi dung khi khong thuoc thu muc nao)
function Get-CategoryByExt([string]$name) {
    $ext = [System.IO.Path]::GetExtension($name).ToLower()
    switch ($ext) {
        ".mcpack"  { return "texture" }
        ".mcaddon" { return "texture" }
        ".mcworld" { return "map" }
        ".mctemplate" { return "map" }
        ".skin"    { return "skin" }
        ".zip"     { return "texture" }
        default    { return "mod" }
    }
}

$items = @()
$files = Get-ChildItem -LiteralPath $modDir -Recurse -File | Where-Object {
    $_.Name -ne "manifest.js" -and $_.Name -ne "_generate.ps1"
}

foreach ($f in $files) {
    $sizeStr = if ($f.Length -ge 1MB) { "{0:N1} MB" -f ($f.Length / 1MB) }
               elseif ($f.Length -ge 1KB) { "{0:N1} KB" -f ($f.Length / 1KB) }
               else { "$($f.Length) B" }

    $rel = $f.FullName.Substring($modDir.Length + 1)
    $rel = $rel.Replace("\", "/")
    $relDir = [System.IO.Path]::GetDirectoryName($rel)
    $relDirName = if ($relDir) { [System.IO.Path]::GetFileName($relDir) } else { "" }

    $cat = if ($relDirName -ne "" -and $folderCatMap.ContainsKey($relDirName)) {
        $folderCatMap[$relDirName]
    } else {
        Get-CategoryByExt $f.Name
    }

    $item = [PSCustomObject]@{
        id   = "m_" + [Guid]::NewGuid().ToString("N").Substring(0, 8)
        name = $f.Name
        url  = "mod/" + $rel
        size = $sizeStr
        game = "Minecraft"
        desc = "File mod trong thu muc mod."
        cat  = $cat
    }

    if ($thumbMap.ContainsKey($f.Name)) {
        $item | Add-Member -NotePropertyName "thumb" -NotePropertyValue $thumbMap[$f.Name]
    }

    $items += $item
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