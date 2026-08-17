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
    "Hydra_Visuals.mcpack"            = "thumbs/hydra.png"
    "Animated glowing ores v1.7.0 .mcpack" = "thumbs/ores.gif"
    "Mike_Ultra_Visuals.mcpack"       = "thumbs/mike_ultra.png"
}

# Nguon / tac gia cho tung mod (map theo ten file)
# Gia tri: ten nguon, "|", link nguon, "|", link tai goc (link tai goc, neu de trong se tai file truc tiep tu web)
$sourceMap = @{
    "Hydra_Visuals.mcpack"            = "MCPEDL|https://mcpedl.com/hydra-visuals/|https://mcpedl.com/hydra-visuals/"
    "Animated glowing ores v1.7.0 .mcpack" = "MCPEDL|https://mcpedl.com/glowing-animated-ores/|https://mcpedl.com/glowing-animated-ores/"
    "Mike_Ultra_Visuals.mcpack"       = "MCPEDL|https://mcpedl.com/mike-ultra-visuals/|https://mcpedl.com/mike-ultra-visuals/"
}

# Mod chi co link ngoai (khong co file local, tai tu web goc)
# Thuoc tinh: name, cat, size, source, srcurl, dlurl, thumb, desc
$externalMods = @(
    @{
        name   = "Animated glowing ores v1.7.0"
        cat    = "texture"
        size   = "947 KB"
        source = "MCPEDL"
        srcurl = "https://mcpedl.com/glowing-animated-ores/"
        dlurl  = "https://mcpedl.com/glowing-animated-ores/"
        thumb  = "thumbs/ores.gif"
        desc   = "Texture pack khoang san phat sang (animated glowing ores)."
    },
    @{
        name   = "Hydra Visuals"
        cat    = "texture"
        size   = "3.1 MB"
        source = "MCPEDL"
        srcurl = "https://mcpedl.com/hydra-visuals/"
        dlurl  = "https://mcpedl.com/hydra-visuals/"
        thumb  = "thumbs/hydra.png"
        desc   = "Texture pack visuals chat luong cao cho Minecraft Bedrock."
    },
    @{
        name   = "Mike Ultra Visuals"
        cat    = "texture"
        size   = "11.1 MB"
        source = "MCPEDL"
        srcurl = "https://mcpedl.com/mike-ultra-visuals/"
        dlurl  = "https://mcpedl.com/mike-ultra-visuals/"
        thumb  = "thumbs/mike_ultra.png"
        desc   = "Texture pack visuals nang cao, do hoa sac net."
    },
    @{
        name   = "Furniture Expansion - Vanilla Styled Addon"
        cat    = "mod"
        size   = "171 KB"
        source = "iamorim"
        srcurl = "https://mcpedl.com/furniture-expansion/"
        dlurl  = "https://mcpedl.com/furniture-expansion/"
        thumb  = "thumbs/furniture_expansion.png"
        desc   = "Addon noi that phong cach Vanilla cho Minecraft Bedrock."
    },
    @{
        name   = "Simple Backpack [Achievement friendly] No Lag"
        cat    = "mod"
        size   = "131 KB"
        source = "Zorrocraft1"
        srcurl = "https://mcpedl.com/sbp/"
        dlurl  = "https://mcpedl.com/sbp/"
        thumb  = "thumbs/sbackpack.jpg"
        desc   = "Ba lo don gian, than thien voi achievements, khong lag."
    },
    @{
        name   = "Night Vision Universal | Night vision"
        cat    = "texture"
        size   = "1.41 MB"
        source = "RisabGamerz"
        srcurl = "https://mcpedl.com/night-vision-for-minecraft/"
        dlurl  = "https://mcpedl.com/night-vision-for-minecraft/"
        thumb  = "thumbs/night_vision.jpg"
        desc   = "Texture pack bat nhin ban dem (night vision) hien thi sang ro."
    },
    @{
        name   = "FPS Optimizer | FPS Boost Official"
        cat    = "texture"
        size   = "1.78 MB"
        source = "xiaocraft"
        srcurl = "https://mcpedl.com/fps-optimizer-fps-boost/"
        dlurl  = "https://mcpedl.com/fps-optimizer-fps-boost/"
        thumb  = "thumbs/fps_optimizer.png"
        desc   = "Texture pack toi uu FPS, tang hieu nang, bo fog."
    },
    @{
        name   = "RG Shader | Renderdragon Shaders"
        cat    = "texture"
        size   = "4.69 MB"
        source = "RisabGamerz"
        srcurl = "https://mcpedl.com/rg-shader-v2-1-renderdragon-support-2/"
        dlurl  = "https://mcpedl.com/rg-shader-v2-1-renderdragon-support-2/"
        thumb  = "thumbs/rg_shader.gif"
        desc   = "Shader ho tro Renderdragon, do hoa dep, phu hop may khong co Vibrant Visuals."
    },
    @{
        name   = "ZenXveda Dynamic Lights"
        cat    = "mod"
        size   = "87 KB"
        source = "zenXveda77"
        srcurl = "https://mcpedl.com/zenxvedas-dynamic-lights/"
        dlurl  = "https://mcpedl.com/zenxvedas-dynamic-lights/"
        thumb  = "thumbs/dynamic_lights.png"
        desc   = "Anh sang dong (dynamic lights) toi uu cho mobile va may cau hinh thap."
    },
    @{
        name   = "One Lucky Block"
        cat    = "map"
        size   = "613 KB"
        source = "deahh"
        srcurl = "https://mcpedl.com/one-lucky-block-deahhmc/"
        dlurl  = "https://mcpedl.com/one-lucky-block-deahhmc/"
        thumb  = "thumbs/lucky_block.png"
        desc   = "Map Lucky Block voi nhieu block va phan thuong ngau nhien."
    },
    @{
        name   = "SkyBlock Adventure"
        cat    = "map"
        size   = "5.6 MB"
        source = "AddersURM"
        srcurl = "https://mcpedl.com/skyblock-adventure/"
        dlurl  = "https://mcpedl.com/skyblock-adventure/"
        thumb  = "thumbs/skyblock.png"
        desc   = "Map Skyblock phieu luu, do kho thay doi theo cap do."
    },
    @{
        name   = "One Block (DtA MC)"
        cat    = "map"
        size   = "7.2 MB"
        source = "DtA_MC"
        srcurl = "https://mcpedl.com/dta-one-block-made-by-dta-mc/"
        dlurl  = "https://mcpedl.com/dta-one-block-made-by-dta-mc/"
        thumb  = "thumbs/one_block.png"
        desc   = "Map One Block huyen thoai, sinh ton tu mot khoi duy nhat."
    },
    @{
        name   = "AziFy Natural Shader (AFN)"
        cat    = "texture"
        size   = "3.36 MB"
        source = "Azion Studios"
        srcurl = "https://mcpedl.com/azify-natural-shader-afn-mcbe-pe/"
        dlurl  = "https://mcpedl.com/azify-natural-shader-afn-mcbe-pe/"
        thumb  = "thumbs/azify.png"
        desc   = "Shader tu nhien cho MCBE/PE, toi uu va ho tro 26.30+."
    },
    @{
        name   = "Nature X"
        cat    = "texture"
        size   = "-"
        source = "Huthaifa"
        srcurl = "https://modrinth.com/resourcepack/nature-x"
        dlurl  = "https://modrinth.com/resourcepack/nature-x"
        thumb  = "thumbs/nature_x.webp"
        desc   = "Resource pack 16x lam the gioi song dong, day du hon. Can Sodium, Continuity, Polytone."
    },
    @{
        name   = "Animated Items"
        cat    = "texture"
        size   = "-"
        source = "palettemc"
        srcurl = "https://modrinth.com/resourcepack/animated-items"
        dlurl  = "https://modrinth.com/resourcepack/animated-items"
        thumb  = "thumbs/animated_items.webp"
        desc   = "Lam animation cho nhieu texture vat pham trong Minecraft (71 item)."
    },
    @{
        name   = "Enchantment Glows"
        cat    = "texture"
        size   = "2.1 MB"
        source = "Sinnelar"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/enchantment-glows"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/enchantment-glows"
        thumb  = "thumbs/enchantment_glows.png"
        desc   = "Them hieu ung phat sang cho cong cu da phu phep."
    },
    @{
        name   = "Stay True"
        cat    = "texture"
        size   = "2.1 MB"
        source = "haimcyfly"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/stay-true"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/stay-true"
        thumb  = "thumbs/stay_true.png"
        desc   = "Visual remaster cua texture mac dinh, giu dung phong cach Vanilla. Can OptiFine."
    },
    @{
        name   = "Faithless"
        cat    = "texture"
        size   = "15.4 MB"
        source = "StitchSprites"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/faithless"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/faithless"
        thumb  = "thumbs/faithless.png"
        desc   = "Pack choi nhu mod: nhieu tinh nang QoL, ho tro nguoi khuyet tat thi giac."
    },
    @{
        name   = "Invisible Item Frames"
        cat    = "texture"
        size   = "-"
        source = "CurseForge"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/invisible-item-frames"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/invisible-item-frames"
        thumb  = "thumbs/invisible_item_frames.png"
        desc   = "Lam khung vat pham (item frame) trong suot."
    },
    @{
        name   = "In-Game Brewing Guide"
        cat    = "texture"
        size   = "-"
        source = "CurseForge"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/in-game-brewing-guide"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/in-game-brewing-guide"
        thumb  = "thumbs/brewing_guide.png"
        desc   = "Hien thi bang phe che (brewing guide) ngay trong tro choi."
    }
)

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

    if ($sourceMap.ContainsKey($f.Name)) {
        $parts = $sourceMap[$f.Name] -split "\|"
        $item | Add-Member -NotePropertyName "source" -NotePropertyValue $parts[0]
        if ($parts.Count -gt 1 -and $parts[1] -ne "") {
            $item | Add-Member -NotePropertyName "srcurl" -NotePropertyValue $parts[1]
        }
        if ($parts.Count -gt 2 -and $parts[2] -ne "") {
            $item | Add-Member -NotePropertyName "dlurl" -NotePropertyValue $parts[2]
        }
    }

    $items += $item
}

# Them mod link ngoai (khong co file local)
foreach ($em in $externalMods) {
    $item = [PSCustomObject]@{
        id   = "m_" + [Guid]::NewGuid().ToString("N").Substring(0, 8)
        name = $em.name
        url  = ""
        size = if ($em.ContainsKey("size")) { $em.size } else { "" }
        game = "Minecraft"
        desc = if ($em.ContainsKey("desc")) { $em.desc } else { "Mod t?i t? web g?c." }
        cat  = if ($em.ContainsKey("cat")) { $em.cat } else { "mod" }
    }
    if ($em.ContainsKey("thumb") -and $em.thumb -ne "") {
        $item | Add-Member -NotePropertyName "thumb" -NotePropertyValue $em.thumb
    }
    if ($em.ContainsKey("source") -and $em.source -ne "") {
        $item | Add-Member -NotePropertyName "source" -NotePropertyValue $em.source
    }
    if ($em.ContainsKey("srcurl") -and $em.srcurl -ne "") {
        $item | Add-Member -NotePropertyName "srcurl" -NotePropertyValue $em.srcurl
    }
    if ($em.ContainsKey("dlurl") -and $em.dlurl -ne "") {
        $item | Add-Member -NotePropertyName "dlurl" -NotePropertyValue $em.dlurl
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