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
    },
    @{
        name   = "Sodium"
        cat    = "texture"
        size   = "-"
        source = "IMS"
        srcurl = "https://modrinth.com/mod/sodium/versions"
        dlurl  = "https://modrinth.com/mod/sodium/versions"
        thumb  = "thumbs/sodium.webp"
        desc   = "Performance mod giam lag, tang FPS manh me, toi uu render engine."
    },
    @{
        name   = "Fabric API"
        cat    = "texture"
        size   = "-"
        source = "Player7457"
        srcurl = "https://modrinth.com/mod/fabric-api"
        dlurl  = "https://modrinth.com/mod/fabric-api"
        thumb  = "thumbs/fabric_api.png"
        desc   = "Thu vien API chay cac mod Fabric, bat buoc cho gan het mod Fabric."
    },
    @{
        name   = "Lithium"
        cat    = "texture"
        size   = "-"
        source = "jellysquid3"
        srcurl = "https://modrinth.com/mod/lithium"
        dlurl  = "https://modrinth.com/mod/lithium"
        thumb  = "thumbs/lithium.webp"
        desc   = "Toi uu hoa game engine, giam lag khong doi gameplay."
    },
    @{
        name   = "AppleSkin"
        cat    = "texture"
        size   = "-"
        source = "squeek502"
        srcurl = "https://modrinth.com/mod/appleskin"
        dlurl  = "https://modrinth.com/mod/appleskin"
        thumb  = "thumbs/appleskin.png"
        desc   = "Hien thi muc do an (hunger/saturation) truc quan tren thanh do an."
    },
    @{
        name   = "BetterNether"
        cat    = "mod"
        size   = "-"
        source = "pupismin"
        srcurl = "https://modrinth.com/mod/betternether"
        dlurl  = "https://modrinth.com/mod/betternether"
        thumb  = "thumbs/betternether.webp"
        desc   = "Lam moi Nether voi sinh vat, cay coi, hang dong va dung san moi."
    },
    @{
        name   = "[Let's Do] Vinery"
        cat    = "mod"
        size   = "-"
        source = "Cristelknight"
        srcurl = "https://modrinth.com/mod/lets-do-vinery"
        dlurl  = "https://modrinth.com/mod/lets-do-vinery"
        thumb  = "thumbs/vinery.webp"
        desc   = "Lam ruou, trong nho, he thong nha may ruou va khach san."
    },
    @{
        name   = "Creeper Overhaul"
        cat    = "mod"
        size   = "-"
        source = "ThatGravyBoat"
        srcurl = "https://modrinth.com/mod/creeper-overhaul"
        dlurl  = "https://modrinth.com/mod/creeper-overhaul"
        thumb  = "thumbs/creeper_overhaul.png"
        desc   = "Lam moi Creepers voi nhieu loai moi o cac sinh quyen khac nhau."
    },
    @{
        name   = "The Bumblezone - Fabric"
        cat    = "mod"
        size   = "-"
        source = "ThatGravyBoat"
        srcurl = "https://modrinth.com/mod/the-bumblezone-fabric"
        dlurl  = "https://modrinth.com/mod/the-bumblezone-fabric"
        thumb  = "thumbs/bumblezone.png"
        desc   = "Mo khoang khong ong kho lo voi sinh vat va dungeon moi."
    },
    @{
        name   = "Particle Effects"
        cat    = "mod"
        size   = "-"
        source = "LopyMine"
        srcurl = "https://modrinth.com/mod/particle-effects"
        dlurl  = "https://modrinth.com/mod/particle-effects"
        thumb  = "thumbs/particle_effects.webp"
        desc   = "Them nhieu hieu ung hat (particle) dep mat cho game."
    },
    @{
        name   = "Creeper Firework"
        cat    = "mod"
        size   = "-"
        source = "MarbleGateKeeper"
        srcurl = "https://modrinth.com/mod/creeper-firework"
        dlurl  = "https://modrinth.com/mod/creeper-firework"
        thumb  = "thumbs/creeper_firework.webp"
        desc   = "Bien Creeper thanh phao hoa vui nhon khi no."
    },
    @{
        name   = "PatPat [Mod & Plugin]"
        cat    = "mod"
        size   = "-"
        source = "nikita51"
        srcurl = "https://modrinth.com/plugin/patpat"
        dlurl  = "https://modrinth.com/plugin/patpat"
        thumb  = "thumbs/patpat.webp"
        desc   = "Mod/Plugin cho phep vut (pat) dau moi nguoi choi."
    },
    @{
        name   = "Cobblemon"
        cat    = "map"
        size   = "-"
        source = "BlazingBRO"
        srcurl = "https://modrinth.com/mod/cobblemon"
        dlurl  = "https://modrinth.com/mod/cobblemon"
        thumb  = "thumbs/cobblemon.webp"
        desc   = "Pokemon trong Minecraft: bat, chien dau va thu thap Cobblemon."
    },
    @{
        name   = "Waystones"
        cat    = "map"
        size   = "-"
        source = "BlayTheNinth"
        srcurl = "https://modrinth.com/mod/waystones"
        dlurl  = "https://modrinth.com/mod/waystones"
        thumb  = "thumbs/waystones.webp"
        desc   = "Cay da danh dau (waystone) de di chuyen nhanh giua cac diem."
    },
    @{
        name   = "Biomes O' Plenty"
        cat    = "map"
        size   = "-"
        source = "Forstride"
        srcurl = "https://modrinth.com/mod/biomes-o-plenty"
        dlurl  = "https://modrinth.com/mod/biomes-o-plenty"
        thumb  = "thumbs/biomes_o_plenty.png"
        desc   = "Them hon 100 sinh quyen moi da dang va do hoa dep cho the gioi."
    },
    @{
        name   = "Dynamic Trees"
        cat    = "map"
        size   = "-"
        source = "Nyfaria"
        srcurl = "https://modrinth.com/mod/dynamictrees"
        dlurl  = "https://modrinth.com/mod/dynamictrees"
        thumb  = "thumbs/dynamic_trees.webp"
        desc   = "Cay coi lon len tu tu va do than cay that, he thong cay dong."
    },
    @{
        name   = "Fresh Animations"
        cat    = "texture"
        size   = "-"
        source = "FreshLX"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/fresh-animations"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/fresh-animations"
        thumb  = "thumbs/fresh_animations.webp"
        desc   = "Lam moi toan bo animation cho moi loai sinh vat, song dong hon."
    },
    @{
        name   = "Fresh Moves"
        cat    = "texture"
        size   = "-"
        source = "Ithan"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/fresh-moves"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/fresh-moves"
        thumb  = "thumbs/fresh_moves.png"
        desc   = "Nang cao ho tro mod cho Fresh Animations, di chuyen nguyen ban."
    },
    @{
        name   = "Motschen's Better Leaves"
        cat    = "texture"
        size   = "-"
        source = "Motschen"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/motschens-better-leaves"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/motschens-better-leaves"
        thumb  = "thumbs/better_leaves.png"
        desc   = "Lam la cay dep, day va toi uu hon, thay the texture la mac dinh."
    },
    @{
        name   = "Low On Fire"
        cat    = "texture"
        size   = "-"
        source = "Haikis"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/low-on-fire"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/low-on-fire"
        thumb  = "thumbs/low_on_fire.png"
        desc   = "Giam do choi cua lua, khong gay kho chiu cho mat."
    },
    @{
        name   = "Torches Reimagined"
        cat    = "texture"
        size   = "-"
        source = "Reijvi"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/torches-reimagined"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/torches-reimagined"
        thumb  = "thumbs/torches_reimagined.png"
        desc   = "Lam moi duoc va duoc cam (torch) voi texture chuan hoa."
    },
    @{
        name   = "Enchantment Descriptions Compat"
        cat    = "texture"
        size   = "-"
        source = "CyberRat2"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/enchantment-descriptions-compat"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/enchantment-descriptions-compat"
        thumb  = "thumbs/enchant_desc_compat.png"
        desc   = "Ho tro texture cho mod Enchantment Descriptions."
    },
    @{
        name   = "Fast Better Grass"
        cat    = "texture"
        size   = "-"
        source = "robotkoer"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/fast-better-grass"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/fast-better-grass"
        thumb  = "thumbs/fast_better_grass.png"
        desc   = "Co dep hon nhung van hoat dong nhanh, phu hop may yeu."
    },
    @{
        name   = "Aimz - Better Crosshair"
        cat    = "texture"
        size   = "-"
        source = "GamerPotion"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/aimz-better-crosshair"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/aimz-better-crosshair"
        thumb  = "thumbs/better_crosshair.png"
        desc   = "La ngam (crosshair) dep, ro rang, ho tro nhieu phong cach."
    },
    @{
        name   = "Stay Clear"
        cat    = "texture"
        size   = "-"
        source = "Robdog"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/stay-clear"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/stay-clear"
        thumb  = "thumbs/stay_clear.png"
        desc   = "Texture trong suot cho block chan nhin, de xay dung."
    },
    @{
        name   = "Better Lanterns"
        cat    = "texture"
        size   = "-"
        source = "Nico4play"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/better-lanterns"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/better-lanterns"
        thumb  = "thumbs/better_lanterns.png"
        desc   = "Lam den long (lantern) dep hon voi do hoa chi tiet."
    },
    @{
        name   = "Sky Villages - Supplementaries Compat"
        cat    = "texture"
        size   = "-"
        source = "Aureljz"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/sky-villages-supplementaries-compat"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/sky-villages-supplementaries-compat"
        thumb  = "thumbs/sky_villages_compat.png"
        desc   = "Ho tro texture cho lang tren troi cua mod Supplementaries."
    },
    @{
        name   = "Alternative Rain Sounds"
        cat    = "texture"
        size   = "-"
        source = "paoleks"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/alternative-rain-sounds"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/alternative-rain-sounds"
        thumb  = "thumbs/alternative_rain.png"
        desc   = "Thay doi am thanh mua trong game bang am thanh thuc."
    },
    @{
        name   = "Lower Shield - Enhanced Combat Visibility"
        cat    = "texture"
        size   = "-"
        source = "dihogenn"
        srcurl = "https://www.curseforge.com/minecraft/texture-packs/lower-shield"
        dlurl  = "https://www.curseforge.com/minecraft/texture-packs/lower-shield"
        thumb  = "thumbs/lower_shield.gif"
        desc   = "Ha thap vi tri khiên de khong che mat nhin khi chien dau."
    },
    @{
        name   = "Just Enough Items (JEI)"
        cat    = "mod"
        size   = "-"
        source = "mezz"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/jei"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/jei"
        thumb  = "thumbs/jei.jpeg"
        desc   = "Xem toan bo vat pham va cong thuc che tao (recipe) trong game."
    },
    @{
        name   = "Bookshelf"
        cat    = "mod"
        size   = "-"
        source = "DarkhaxDev"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/bookshelf"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/bookshelf"
        thumb  = "thumbs/bookshelf.png"
        desc   = "Thu vien ho tro (API) can thiet cho nhieu mod khac."
    },
    @{
        name   = "Enchantment Descriptions"
        cat    = "mod"
        size   = "-"
        source = "DarkhaxDev"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/enchantment-descriptions"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/enchantment-descriptions"
        thumb  = "thumbs/enchantment_descriptions.png"
        desc   = "Hien thi mo ta chi tiet cua tung phu phep (enchantment)."
    },
    @{
        name   = "Nature's Compass"
        cat    = "mod"
        size   = "-"
        source = "Chaosyr"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/natures-compass"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/natures-compass"
        thumb  = "thumbs/natures_compass.png"
        desc   = "La ban la tim sinh quyen (biome) mong muon."
    },
    @{
        name   = "Iris Shaders"
        cat    = "mod"
        size   = "-"
        source = "IMS"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/irisshaders"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/irisshaders"
        thumb  = "thumbs/iris.webp"
        desc   = "Tai shader tuong thich, chay man me tren Fabric."
    },
    @{
        name   = "Lithostitched"
        cat    = "mod"
        size   = "-"
        source = "Apollo"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/lithostitched"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/lithostitched"
        thumb  = "thumbs/lithostitched.png"
        desc   = "Thu vien ho tro cho cac mod chinh sua world gen."
    },
    @{
        name   = "Simple Voice Chat"
        cat    = "mod"
        size   = "-"
        source = "BreadLoaf"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/simple-voice-chat"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/simple-voice-chat"
        thumb  = "thumbs/simple_voice_chat.png"
        desc   = "Goi thoai (voice chat) trong game, can cai tren may chu."
    },
    @{
        name   = "BadOptimizations"
        cat    = "mod"
        size   = "-"
        source = "thosea"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/badoptimizations"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/badoptimizations"
        thumb  = "thumbs/badoptimizations.png"
        desc   = "Toi uu hoa hieu nang, giam lag khong can cau hinh."
    },
    @{
        name   = "3D Skin Layers"
        cat    = "mod"
        size   = "-"
        source = "tr7zw"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/skin-layers-3d"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/skin-layers-3d"
        thumb  = "thumbs/skin_layers_3d.webp"
        desc   = "Hien thi lop skin (ao, tay...) dang 3D nhu Bedrock."
    },
    @{
        name   = "Continuity"
        cat    = "mod"
        size   = "-"
        source = "Pepper_Bell"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/continuity"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/continuity"
        thumb  = "thumbs/continuity.png"
        desc   = "Ho tro texture lien mach (connected textures) cho Fabric."
    },
    @{
        name   = "Fast Leaf Decay"
        cat    = "mod"
        size   = "-"
        source = "olafskiii"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/fast-leaf-decay"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/fast-leaf-decay"
        thumb  = "thumbs/fast_leaf_decay.png"
        desc   = "La cay rung nhanh hon sau khi chat cay."
    },
    @{
        name   = "Clean Swing Through Grass"
        cat    = "mod"
        size   = "-"
        source = "Raycoms"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/clean-swing-through-grass"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/clean-swing-through-grass"
        thumb  = "thumbs/clean_swing.png"
        desc   = "Vuot qua co, la va cay khi danh nhau, khong bi can."
    },
    @{
        name   = "Cherished Worlds"
        cat    = "mod"
        size   = "-"
        source = "TheIllusiveC4"
        srcurl = "https://www.curseforge.com/minecraft/mc-mods/cherished-worlds"
        dlurl  = "https://www.curseforge.com/minecraft/mc-mods/cherished-worlds"
        thumb  = "thumbs/cherished_worlds.png"
        desc   = "Ghim (pin) cac the gioi yeu thich trong man hinh chon world."
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
