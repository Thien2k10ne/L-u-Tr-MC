(function () {
            "use strict";

            // Trang nằm trong thư mục con (trangchu/, kho/) -> tiền tố "../" cho tài nguyên
            var PAGE_PREFIX = (function () {
                var p = (window.location.pathname || "").replace(/\/+$/, "");
                var last = p.split("/").pop() || "";
                return (last === "kho" || last === "trangchu") ? "../" : "";
            })();

            // Đường dẫn thật tới trang đối tác (cho link nav, đổi trang sẽ load lại web)
            function linkFor(seg) {
                var p = (window.location.pathname || "").replace(/\/+$/, "").replace(/\/index\.html$/, "");
                var last = p.split("/").pop() || "";
                var parent = p.replace(/\/[^/]+$/, "");
                if (last === "kho" || last === "trangchu") {
                    return (parent + "/" + seg + "/").replace(/\/{2,}/g, "/");
                }
                return seg + "/";
            }

            // Ẩn preloader khi trang tải xong
            function hidePreloader() {
                var p = document.getElementById("preloader");
                if (p) p.classList.add("hidden");
            }
            if (document.readyState === "complete") {
                hidePreloader();
            } else {
                window.addEventListener("load", hidePreloader);
                setTimeout(hidePreloader, 4000);
            }

            // Dữ liệu (UNLOCK_DATA, MC_DATA) nằm trong js/data.js

            var mods = [];
            var unlocks = UNLOCK_DATA.slice();

            function compareVersion(a, b) {
                var pa = String(a.version || "").split(".").map(function (n) { return parseInt(n, 10) || 0; });
                var pb = String(b.version || "").split(".").map(function (n) { return parseInt(n, 10) || 0; });
                var len = Math.max(pa.length, pb.length);
                for (var i = 0; i < len; i++) {
                    var va = pa[i] || 0, vb = pb[i] || 0;
                    if (va !== vb) return vb - va;
                }
                return 0;
            }

            var minecraftVersions = MC_DATA.slice().sort(compareVersion);

            function esc(s) {
                var d = document.createElement("div");
                d.textContent = s == null ? "" : String(s);
                return d.innerHTML;
            }

            function formatBytes(bytes) {
                if (!bytes) return "";
                var units = ["B", "KB", "MB", "GB", "TB"];
                var i = 0;
                var n = bytes;
                while (n >= 1024 && i < units.length - 1) { n /= 1024; i++; }
                return (n >= 100 ? Math.round(n) : Math.round(n * 10) / 10) + " " + units[i];
            }

            var LOGO_URL = "https://store-images.s-microsoft.com/image/apps.21661.14216416494490173.9772fa78-5a01-45ce-9b9e-6ec61a10f4e2.f787fea4-1e7a-4458-a112-c5ac10fec5c0";

            function buildCard(item, kind, idx) {
                var thumb = item.thumb
                    ? '<div class="mod-thumb"><img src="' + esc(PAGE_PREFIX + item.thumb) + '" alt=""></div>'
                    : kind === "minecraft"
                        ? '<div class="mod-thumb"><img src="' + LOGO_URL + '" alt=""></div>'
                        : '<div class="mod-thumb"><i class="' + (kind === "mods" ? "fa-solid fa-cubes" : "fa-solid fa-unlock") + '"></i></div>';

                var badges = "";
                if (kind === "mods" && item.cat) {
                    var catNames = { mod: "Mod", texture: "Texture pack", map: "Map", skin: "Skin" };
                    var catIcons = { mod: "fa-cubes", texture: "fa-palette", map: "fa-map", skin: "fa-user-tie" };
                    badges += '<span class="badge-tag"><i class="fa-solid ' + (catIcons[item.cat] || "fa-cubes") + '"></i>' + (catNames[item.cat] || item.cat) + "</span> ";
                }
                var isMinecraft = kind === "minecraft";
                if (!isMinecraft && item.loader) badges += '<span class="badge-tag badge-tag--sky"><i class="fa-solid fa-gears"></i>' + esc(item.loader) + "</span> ";
                if (item.game) badges += '<span class="badge-tag badge-tag--amber"><i class="fa-solid fa-gamepad"></i>' + esc(item.game) + "</span> ";
                if (item.version) badges += '<span class="badge-tag"><i class="fa-solid fa-layer-group"></i>' + esc(item.version) + "</span> ";

                var meta = "";
                if (!isMinecraft && item.loader) meta += '<span class="mod-meta"><i class="fa-solid fa-gears"></i>' + esc(item.loader) + "</span>";
                else if (item.game) meta += '<span class="mod-meta"><i class="fa-solid fa-gamepad"></i>' + esc(item.game) + "</span>";
                if (item.version) meta += '<span class="mod-meta"><i class="fa-solid fa-layer-group"></i>' + esc(item.version) + "</span>";
                if (!isMinecraft && item.size) meta += '<span class="mod-meta"><i class="fa-solid fa-weight-hanging"></i>' + esc(item.size) + "</span>";

                var action = "";
                if (item.dlurl) {
                    action = '<a href="' + esc(item.dlurl) + '" data-dl class="btn-download"><i class="fa-solid fa-cloud-arrow-down"></i> Tải về</a>';
                } else if (item.url) {
                    var qs = "type=" + encodeURIComponent(kind) +
                        "&name=" + encodeURIComponent(item.name || "") +
                        "&url=" + encodeURIComponent(item.url || "") +
                        "&size=" + encodeURIComponent(item.size || "") +
                        "&desc=" + encodeURIComponent(item.desc || "") +
                        "&game=" + encodeURIComponent(item.game || "") +
                        "&version=" + encodeURIComponent(item.version || "") +
                        "&loader=" + encodeURIComponent(item.loader || "") +
                        "&thumb=" + encodeURIComponent(item.thumb || "") +
                        "&cat=" + encodeURIComponent(item.cat || "") +
                        "&source=" + encodeURIComponent(isMinecraft ? "Bandishare" : (item.source || "")) +
                        "&srcurl=" + encodeURIComponent(isMinecraft ? "https://bandishare.io/" : (item.srcurl || ""));
                    action = '<a href="' + PAGE_PREFIX + 'mod.html?' + qs + '" class="btn-download"><i class="fa-solid fa-circle-info"></i> Xem & tải</a>';
                } else {
                    action = '<span class="badge-tag"><i class="fa-solid fa-circle-info"></i> Đang cập nhật</span>';
                }

                return (
                    '<div class="mod-card fade-enter" data-id="' + esc(item.id) + '" style="animation-delay:' + ((idx || 0) * 0.04).toFixed(2) + 's">' +
                        '<div class="mod-card-head">' + thumb +
                            '<div class="min-w-0 flex-1">' +
                                '<div class="mod-name truncate" title="' + esc(item.name) + '">' + esc(item.name) + "</div>" +
                                '<div class="mt-1 flex flex-wrap gap-2">' + badges + "</div>" +
                            "</div>" +
                        "</div>" +
                        (item.desc ? '<p class="mod-desc">' + esc(item.desc) + "</p>" : "") +
                        '<div class="mod-actions">' + action +
                            (item.size && !isMinecraft ? '<span class="file-size"><i class="fa-solid fa-weight-hanging"></i> ' + esc(item.size) + "</span>" : "") +
                        "</div>" +
                    "</div>"
                );
            }

            var currentTab = "mods";

            function setStat(id, target) {
                var el = document.getElementById(id);
                if (!el) return;
                var start = null;
                var dur = 900;
                function step(ts) {
                    if (start === null) start = ts;
                    var p = Math.min((ts - start) / dur, 1);
                    var eased = 1 - Math.pow(1 - p, 3);
                    el.textContent = Math.round(target * eased);
                    if (p < 1) requestAnimationFrame(step);
                }
                requestAnimationFrame(step);
            }

            function renderAll() {
                var modsCount = mods.length;
                var mcCount = minecraftVersions.length;
                var unlocksCount = unlocks.length;

                setStat("statMods", modsCount);
                setStat("statMinecraft", mcCount);
                setStat("statUnlocks", unlocksCount);
                setStat("statTotal", modsCount + mcCount + unlocksCount);
                var el;
                if ((el = document.getElementById("countMods"))) el.textContent = modsCount;
                if ((el = document.getElementById("countMinecraft"))) el.textContent = mcCount;
                if ((el = document.getElementById("countUnlocks"))) el.textContent = unlocksCount;

                updateCatCounts();
                renderList("mods");
                renderList("minecraft");
                renderList("unlocks");
                renderList(currentTab);
            }

            var currentModCat = "all";

            // ===== Đề xuất theo lượt bấm =====
            var CLICKS_KEY = "modArchiveClicks";
            var clickCounts = null;

            function loadClicks() {
                if (clickCounts) return clickCounts;
                clickCounts = {};
                try {
                    var raw = localStorage.getItem(CLICKS_KEY);
                    if (raw) clickCounts = JSON.parse(raw) || {};
                } catch (e) { clickCounts = {}; }
                return clickCounts;
            }

            function getClickCount(id) {
                var c = loadClicks();
                return c[id] || 0;
            }

            function registerClick(id) {
                if (!id) return;
                var c = loadClicks();
                c[id] = (c[id] || 0) + 1;
                try { localStorage.setItem(CLICKS_KEY, JSON.stringify(c)); } catch (e) {}
            }

            function sortByPopularity(list) {
                return list.slice().sort(function (a, b) {
                    var da = getClickCount(a.id), db = getClickCount(b.id);
                    return db - da;
                });
            }

            function getFiltered(kind) {
                var si = document.getElementById("searchInput");
                var q = si ? si.value.trim().toLowerCase() : "";
                var list = kind === "mods" ? mods : kind === "minecraft" ? minecraftVersions : unlocks;
                if (kind === "mods" && currentModCat !== "all") {
                    list = list.filter(function (item) { return item.cat === currentModCat; });
                }
                return list.filter(function (item) {
                    return !q ||
                        (item.name && item.name.toLowerCase().indexOf(q) !== -1) ||
                        (item.desc && item.desc.toLowerCase().indexOf(q) !== -1) ||
                        (item.loader && item.loader.toLowerCase().indexOf(q) !== -1) ||
                        (item.version && item.version.toLowerCase().indexOf(q) !== -1) ||
                        (item.game && item.game.toLowerCase().indexOf(q) !== -1);
                });
            }

            function emptyStateHTML(kind) {
                var isMod = kind === "mods";
                var isMc = kind === "minecraft";
                var icon = isMod ? "fa-solid fa-cubes" : isMc ? "fa-solid fa-cube" : "fa-solid fa-unlock";
                var title = isMod ? "Chưa có mod nào" : isMc ? "Chưa có bản Minecraft nào" : "Chưa có file nào";
                var text = isMod
                    ? "Bỏ file mod vào thư mục mod rồi chạy Cap-nhat-mod.bat, mod sẽ tự hiện ở đây."
                    : isMc
                        ? "Các bản Minecraft sẽ được thêm trực tiếp trong code."
                        : "Kho file unlock đang trống. File sẽ được thêm trực tiếp trong code.";
                return (
                    '<div class="empty-state col-span-full">' +
                        '<div class="empty-icon"><i class="' + icon + '"></i></div>' +
                        '<h3 class="text-xl font-extrabold text-slate-800">' + title + "</h3>" +
                        '<p class="max-w-md text-[0.975rem] leading-relaxed text-slate-500">' + text + "</p>" +
                    "</div>"
                );
            }

            function updateCatCounts() {
                if (!document.getElementById("catCountAll")) return;
                var counts = { all: mods.length, mod: 0, texture: 0, map: 0, skin: 0 };
                mods.forEach(function (m) {
                    if (counts[m.cat] != null) counts[m.cat]++;
                });
                document.getElementById("catCountAll").textContent = counts.all;
                document.getElementById("catCountMod").textContent = counts.mod;
                document.getElementById("catCountTexture").textContent = counts.texture;
                document.getElementById("catCountMap").textContent = counts.map;
                document.getElementById("catCountSkin").textContent = counts.skin;
            }

            var PAGE_SIZE = 20;
            var visibleCount = { mods: PAGE_SIZE, minecraft: PAGE_SIZE, unlocks: PAGE_SIZE };

            function resetVisible(kind) {
                visibleCount[kind] = PAGE_SIZE;
            }

            function renderList(kind) {
                var grid = document.getElementById(kind + "Grid");
                if (!grid) return;
                var moreWrap = document.getElementById("moreWrap");
                var list = getFiltered(kind);
                if (!list.length) {
                    grid.innerHTML = emptyStateHTML(kind);
                    grid.classList.remove("grid");
                    grid.classList.add("block");
                    if (moreWrap) moreWrap.classList.add("hidden");
                    return;
                }
                grid.classList.add("grid");
                grid.classList.remove("block");
                var ordered = sortByPopularity(list);
                var show = ordered.slice(0, visibleCount[kind]);
                grid.innerHTML = show.map(function (item, i) { return buildCard(item, kind, i); }).join("");
                if (moreWrap) {
                    if (ordered.length > show.length) {
                        moreWrap.classList.remove("hidden");
                    } else {
                        moreWrap.classList.add("hidden");
                    }
                }
            }

            function setActiveTab(tab) {
                currentTab = tab;
                document.querySelectorAll(".archive-tab[data-tab]").forEach(function (b) {
                    b.classList.toggle("active", b.getAttribute("data-tab") === tab);
                });
                ["mods", "minecraft", "unlocks"].forEach(function (k) {
                    var g = document.getElementById(k + "Grid");
                    if (g) g.classList.toggle("hidden", k !== tab);
                });
                var modCats = document.getElementById("modCats");
                if (modCats) modCats.classList.toggle("hidden", tab !== "mods");
                resetVisible(tab);
                renderList(tab);
            }

            // ---- Event wiring ----
            var searchInput = document.getElementById("searchInput");
            if (searchInput) {
                searchInput.addEventListener("input", function () {
                    resetVisible(currentTab);
                    renderList(currentTab);
                });
            }

            document.querySelectorAll(".archive-tab[data-tab]").forEach(function (b) {
                b.addEventListener("click", function () { setActiveTab(b.getAttribute("data-tab")); });
            });

            document.querySelectorAll(".cat-chip[data-cat]").forEach(function (c) {
                c.addEventListener("click", function () {
                    currentModCat = c.getAttribute("data-cat");
                    document.querySelectorAll(".cat-chip[data-cat]").forEach(function (x) {
                        x.classList.toggle("active", x === c);
                    });
                    resetVisible("mods");
                    renderList("mods");
                });
            });

            var btnMore = document.getElementById("btnMore");
            if (btnMore) {
                btnMore.addEventListener("click", function () {
                    visibleCount[currentTab] += PAGE_SIZE;
                    renderList(currentTab);
                });
            }

            // ---- FAQ accordion ----
            document.querySelectorAll(".faq-question").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var item = btn.closest(".faq-item");
                    var wasOpen = item.classList.contains("open");
                    document.querySelectorAll(".faq-item.open").forEach(function (o) {
                        o.classList.remove("open");
                        var q = o.querySelector(".faq-question");
                        if (q) q.setAttribute("aria-expanded", "false");
                    });
                    if (!wasOpen) {
                        item.classList.add("open");
                        btn.setAttribute("aria-expanded", "true");
                    }
                });
            });

            // ---- Nút cuộn lên đầu trang + thanh tiến trình ----
            var scrollBtn = document.getElementById("scrollBtn");
            var scrollProgress = document.getElementById("scrollProgress");

            function onScroll() {
                var st = window.pageYOffset || document.documentElement.scrollTop;
                var max = (document.documentElement.scrollHeight || document.body.scrollHeight) - window.innerHeight;
                if (scrollProgress) scrollProgress.style.width = (max > 0 ? (st / max) * 100 : 0) + "%";
                if (scrollBtn) scrollBtn.classList.toggle("show", st > 200);
            }
            window.addEventListener("scroll", onScroll, { passive: true });
            onScroll();

            if (scrollBtn) {
                scrollBtn.addEventListener("click", function () {
                    window.scrollTo({ top: 0, behavior: "smooth" });
                });
            }

            // ---- Tự động đọc danh sách mod từ thư mục mod (chỉ cần ở trang kho) ----
            var manifestCache = null;

            function refreshManifest() {
                if (!document.getElementById("archive")) return;
                var el = document.createElement("script");
                el.onload = function () {
                    var data = window.MOD_MANIFEST;
                    if (!Array.isArray(data)) return;
                    var str = JSON.stringify(data);
                    if (str === manifestCache) return;
                    manifestCache = str;
                    mods = data.map(function (m, i) {
                        return {
                            id: m.id || ("m_" + i),
                            name: m.name,
                            url: m.url,
                            size: m.size,
                            game: m.game || "Minecraft",
                            desc: m.desc || "",
                            loader: m.loader || "",
                            thumb: m.thumb || "",
                            cat: m.cat || "mod",
                            source: m.source || "",
                            srcurl: m.srcurl || "",
                            dlurl: m.dlurl || ""
                        };
                    });
                    renderAll();
                };
                el.onerror = function () {
                    el.parentNode && el.parentNode.removeChild(el);
                };
                el.src = PAGE_PREFIX + "mod/manifest.js?t=" + Date.now();
                document.head.appendChild(el);
            }

            refreshManifest();
            setInterval(refreshManifest, 5000);

            // Mobile menu
            var navOpen = false;
            var btnMobileMenu = document.getElementById("btnMobileMenu");
            if (btnMobileMenu) {
                btnMobileMenu.addEventListener("click", function () {
                    navOpen = !navOpen;
                    var nav = document.getElementById("navMobile");
                    if (nav) nav.style.maxHeight = navOpen ? nav.scrollHeight + "px" : "0px";
                });
            }

            // Gán href thật cho link nav (data-route) -> đổi trang là load lại web như web thường
            document.querySelectorAll("[data-route]").forEach(function (a) {
                var seg = a.getAttribute("data-route");
                var href = linkFor(seg);
                if (a.hasAttribute("data-goto-about")) {
                    href += "#about";
                } else {
                    var tab = a.getAttribute("data-goto-tab");
                    if (tab) href += "#" + tab;
                }
                a.setAttribute("href", href);
            });

            // ---- Xác nhận tải xuống ----
            var confirmModal = document.getElementById("confirmModal");
            var confirmNameEl = document.getElementById("confirmModalName");
            var confirmHintEl = document.getElementById("confirmModalHint");
            var pendingDownload = null;

            function showConfirmModal(name, hint) {
                if (!confirmModal) return;
                confirmNameEl.textContent = name;
                confirmHintEl.textContent = hint;
                confirmModal.classList.add("show");
                confirmModal.setAttribute("aria-hidden", "false");
            }

            function hideConfirmModal() {
                if (!confirmModal) return;
                confirmModal.classList.remove("show");
                confirmModal.setAttribute("aria-hidden", "true");
                pendingDownload = null;
            }

            function performDownload() {
                if (!pendingDownload) return;
                var url = pendingDownload.url;
                var isLocal = url.indexOf("http") !== 0;
                var a = document.createElement("a");
                a.href = url;
                if (isLocal) {
                    a.download = pendingDownload.fileName || "";
                } else {
                    a.target = "_blank";
                    a.rel = "noopener";
                }
                document.body.appendChild(a);
                a.click();
                a.remove();
                hideConfirmModal();
            }

            document.addEventListener("click", function (e) {
                var link = e.target.closest("[data-dl]");
                if (link) {
                    e.preventDefault();
                    var card = link.closest(".mod-card");
                    if (card) registerClick(card.getAttribute("data-id"));
                    var url = link.getAttribute("href");
                    var isExternal = url.indexOf("http") === 0;
                    var name = (link.closest(".mod-card") ? link.closest(".mod-card").querySelector(".mod-name").textContent : "File này");
                    var isLocal = url.indexOf("http") !== 0;
                    var fileName = isLocal ? decodeURIComponent(url.split("/").pop()) : "";
                    pendingDownload = { url: url, fileName: fileName };
                    if (isExternal) {
                        showConfirmModal(
                            "Chuyển tiếp sang web tải?",
                            "Bạn có muốn chuyển tiếp tới " + name + " trên web gốc không? Bạn sẽ rời khỏi web này và mở trang tải gốc."
                        );
                    } else {
                        showConfirmModal(
                            "Tải xuống " + name + "?",
                            "File sẽ được tải về thiết bị của bạn."
                        );
                    }
                    return;
                }
                var infoLink = e.target.closest('a[href*="mod.html"]');
                if (infoLink) {
                    var card2 = infoLink.closest(".mod-card");
                    if (card2) registerClick(card2.getAttribute("data-id"));
                    return;
                }
            });

            if (confirmModal) {
                var confirmOk = document.getElementById("confirmOk");
                var confirmCancel = document.getElementById("confirmCancel");
                if (confirmOk) confirmOk.addEventListener("click", performDownload);
                if (confirmCancel) confirmCancel.addEventListener("click", hideConfirmModal);
                confirmModal.addEventListener("click", function (e) {
                    if (e.target === confirmModal) hideConfirmModal();
                });
            }
            document.addEventListener("keydown", function (e) {
                if (e.key === "Escape") hideConfirmModal();
            });

            // Reveal on scroll + stagger
            var io = new IntersectionObserver(function (entries) {
                entries.forEach(function (en) {
                    if (en.isIntersecting) {
                        en.target.classList.add("visible");
                        io.unobserve(en.target);
                    }
                });
            }, { threshold: 0.12 });

            // Nhóm các .reveal có cùng cha -> gán delay lần lượt
            function applyRevealStagger() {
                document.querySelectorAll(".reveal:not(.visible)").forEach(function (el) {
                    if (el.hasAttribute("data-delay")) return;
                    var parent = el.parentElement;
                    var siblings = parent ? parent.querySelectorAll(".reveal:not(.visible)") : [el];
                    var idx = Array.prototype.indexOf.call(siblings, el);
                    el.setAttribute("data-delay", String(Math.min(idx, 6)));
                });
            }
            applyRevealStagger();
            document.querySelectorAll(".reveal").forEach(function (el) { io.observe(el); });

            // Bottom nav active state
            var bottomNav = document.getElementById("bottomNav");
            function setNavActive(which) {
                if (!bottomNav) return;
                bottomNav.querySelectorAll("a").forEach(function (a) {
                    a.classList.toggle("active", a.getAttribute("data-nav") === which);
                });
            }
            if (bottomNav) {
                setActiveTab = (function (orig) {
                    return function (tab) {
                        orig(tab);
                        setNavActive(tab);
                    };
                })(setActiveTab);
            }

            // Xác định trang hiện tại (trangchu hoặc kho) từ đường dẫn
            var currentPage = (function () {
                var p = (window.location.pathname || "").replace(/\/+$/, "");
                return p.split("/").pop() || "trangchu";
            })();
            var isKhoPage = currentPage === "kho";
            if (bottomNav) setNavActive(isKhoPage ? currentTab : "trangchu");

            // Mở thẳng tab theo hash (#mods / #minecraft / #unlocks) hoặc cuộn tới #about
            var initHash = (location.hash || "").replace("#", "");
            if (initHash === "mods" || initHash === "minecraft" || initHash === "unlocks") {
                setActiveTab(initHash);
            } else if (initHash === "about") {
                setTimeout(function () {
                    var ab = document.getElementById("about");
                    if (ab) ab.scrollIntoView({ behavior: "smooth", block: "start" });
                }, 60);
            }

            renderAll();
        })();