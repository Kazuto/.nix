-- Helper utility functions for sketchybar
-- Provides common functions for string formatting, math operations, and error handling

local helpers = {}

-- Logging configuration
local LOG_LEVEL = {
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  DEBUG = 4
}

local current_log_level = LOG_LEVEL.INFO

-- Set logging level
function helpers.set_log_level(level)
  current_log_level = level
end

-- Log functions
function helpers.log_error(message)
  if current_log_level >= LOG_LEVEL.ERROR then
    print("[ERROR] " .. tostring(message))
  end
end

function helpers.log_warn(message)
  if current_log_level >= LOG_LEVEL.WARN then
    print("[WARN] " .. tostring(message))
  end
end

function helpers.log_info(message)
  if current_log_level >= LOG_LEVEL.INFO then
    print("[INFO] " .. tostring(message))
  end
end

function helpers.log_debug(message)
  if current_log_level >= LOG_LEVEL.DEBUG then
    print("[DEBUG] " .. tostring(message))
  end
end

-- Execute system command with error handling
function helpers.execute_command(command)
  if not command or command == "" then
    helpers.log_error("execute_command: empty command provided")
    return nil
  end
  
  helpers.log_debug("Executing command: " .. command)
  
  local handle = io.popen(command .. " 2>/dev/null")
  if not handle then
    helpers.log_error("execute_command: failed to execute command: " .. command)
    return nil
  end
  
  local result = handle:read("*a")
  local success, exit_type, exit_code = handle:close()
  
  if not success then
    helpers.log_error("execute_command: command failed with exit code " .. tostring(exit_code) .. ": " .. command)
    return nil
  end
  
  return result and result ~= "" and result or nil
end

-- Safe execution wrapper with fallback
function helpers.safe_execute(func, fallback, error_message)
  local success, result = pcall(func)
  if success then
    return result
  else
    if error_message then
      helpers.log_error(error_message .. ": " .. tostring(result))
    else
      helpers.log_error("safe_execute failed: " .. tostring(result))
    end
    return fallback
  end
end

-- String formatting functions
function helpers.trim(str)
  if not str then return "" end
  return str:match("^%s*(.-)%s*$")
end

function helpers.split(str, delimiter)
  if not str then return {} end
  delimiter = delimiter or "%s"
  local result = {}
  for match in str:gmatch("([^" .. delimiter .. "]+)") do
    table.insert(result, match)
  end
  return result
end

function helpers.starts_with(str, prefix)
  if not str or not prefix then return false end
  return str:sub(1, #prefix) == prefix
end

function helpers.ends_with(str, suffix)
  if not str or not suffix then return false end
  return str:sub(-#suffix) == suffix
end

function helpers.truncate(str, max_length, suffix)
  if not str then return "" end
  suffix = suffix or "..."
  if #str <= max_length then
    return str
  end
  return str:sub(1, max_length - #suffix) .. suffix
end

function helpers.pad_left(str, length, char)
  str = tostring(str or "")
  char = char or " "
  while #str < length do
    str = char .. str
  end
  return str
end

function helpers.pad_right(str, length, char)
  str = tostring(str or "")
  char = char or " "
  while #str < length do
    str = str .. char
  end
  return str
end

-- Mathematical utility functions
function helpers.round(num, decimals)
  if not num then return 0 end
  decimals = decimals or 0
  local mult = 10 ^ decimals
  return math.floor(num * mult + 0.5) / mult
end

function helpers.clamp(value, min_val, max_val)
  if not value then return min_val end
  return math.max(min_val, math.min(max_val, value))
end

function helpers.percentage(value, total)
  if not value or not total or total == 0 then return 0 end
  return helpers.round((value / total) * 100, 1)
end

function helpers.lerp(a, b, t)
  if not a or not b or not t then return a or 0 end
  return a + (b - a) * helpers.clamp(t, 0, 1)
end

-- Color utility functions
function helpers.hex_to_rgb(hex)
  if not hex then return {0, 0, 0} end
  hex = hex:gsub("#", "")
  if #hex ~= 6 then return {0, 0, 0} end
  
  local r = tonumber(hex:sub(1, 2), 16) or 0
  local g = tonumber(hex:sub(3, 4), 16) or 0
  local b = tonumber(hex:sub(5, 6), 16) or 0
  
  return {r, g, b}
end

function helpers.rgb_to_hex(r, g, b)
  r = helpers.clamp(r or 0, 0, 255)
  g = helpers.clamp(g or 0, 0, 255)
  b = helpers.clamp(b or 0, 0, 255)
  
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Table utility functions
function helpers.table_merge(t1, t2)
  local result = {}
  if t1 then
    for k, v in pairs(t1) do
      result[k] = v
    end
  end
  if t2 then
    for k, v in pairs(t2) do
      result[k] = v
    end
  end
  return result
end

function helpers.table_copy(t)
  if type(t) ~= "table" then return t end
  local result = {}
  for k, v in pairs(t) do
    result[k] = helpers.table_copy(v)
  end
  return result
end

function helpers.table_contains(t, value)
  if not t then return false end
  for _, v in pairs(t) do
    if v == value then return true end
  end
  return false
end

-- Time utility functions
function helpers.format_duration(seconds)
  if not seconds or seconds < 0 then return "0:00" end
  
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local secs = seconds % 60
  
  if hours > 0 then
    return string.format("%d:%02d:%02d", hours, minutes, secs)
  else
    return string.format("%d:%02d", minutes, secs)
  end
end

function helpers.parse_duration(duration_str)
  if not duration_str then return 0 end
  
  local hours, minutes, seconds = duration_str:match("(%d+):(%d+):(%d+)")
  if hours then
    return tonumber(hours) * 3600 + tonumber(minutes) * 60 + tonumber(seconds)
  end
  
  local minutes, seconds = duration_str:match("(%d+):(%d+)")
  if minutes then
    return tonumber(minutes) * 60 + tonumber(seconds)
  end
  
  return tonumber(duration_str) or 0
end

-- File utility functions
function helpers.file_exists(path)
  if not path then return false end
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

function helpers.read_file(path)
  if not helpers.file_exists(path) then
    return nil
  end
  
  local file = io.open(path, "r")
  if not file then return nil end
  
  local content = file:read("*a")
  file:close()
  return content
end

function helpers.write_file(path, content)
  if not path or not content then return false end
  
  local file = io.open(path, "w")
  if not file then return false end
  
  file:write(content)
  file:close()
  return true
end

-- Environment utility functions
function helpers.get_env(name, default)
  return os.getenv(name) or default
end

function helpers.expand_path(path)
  if not path then return "" end
  if helpers.starts_with(path, "~/") then
    local home = helpers.get_env("HOME", "")
    return home .. path:sub(2)
  end
  return path
end

-- Validation functions
function helpers.is_number(value)
  return type(value) == "number" or (type(value) == "string" and tonumber(value) ~= nil)
end

function helpers.is_string(value)
  return type(value) == "string"
end

function helpers.is_table(value)
  return type(value) == "table"
end

function helpers.is_function(value)
  return type(value) == "function"
end

-- Debounce function
function helpers.debounce(func, delay)
  local timer = nil
  return function(...)
    local args = {...}
    if timer then
      timer:cancel()
    end
    timer = hs.timer.doAfter(delay, function()
      func(table.unpack(args))
    end)
  end
end

-- Throttle function
function helpers.throttle(func, delay)
  local last_call = 0
  return function(...)
    local now = os.time()
    if now - last_call >= delay then
      last_call = now
      return func(...)
    end
  end
end

-- Get table length (for tables with non-numeric keys)
function helpers.table_length(t)
  if not t then return 0 end
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

-- Application icon mapping function
-- Maps application names to their corresponding icons
function helpers.get_app_icon(app_name)
  if not app_name or app_name == "" then
    return ":default:"
  end
  
  -- Icon mapping table (subset of most common applications)
  local icon_map = {
    ["Live"] = ":ableton:",
    ["Activity Monitor"] = ":activity_monitor:",
    ["Aktivitätsanzeige"] = ":activity_monitor:",
    ["Adobe Bridge"] = ":adobe_bridge:",
    ["Affinity Designer"] = ":affinity_designer:",
    ["Affinity Designer 2"] = ":affinity_designer_2:",
    ["Affinity Photo"] = ":affinity_photo:",
    ["Affinity Photo 2"] = ":affinity_photo_2:",
    ["Affinity Publisher"] = ":affinity_publisher:",
    ["Affinity Publisher 2"] = ":affinity_publisher_2:",
    ["Airmail"] = ":airmail:",
    ["AirPort Utility"] = ":airport_utility:",
    ["Alacritty"] = ":alacritty:",
    ["Alfred"] = ":alfred:",
    ["Android Messages"] = ":android_messages:",
    ["Android Studio"] = ":android_studio:",
    ["Anki"] = ":anki:",
    ["Anytype"] = ":anytype:",
    ["Apifox"] = ":apifox:",
    ["App Eraser"] = ":app_eraser:",
    ["App Store"] = ":app_store:",
    ["Arc"] = ":arc:",
    ["Arduino"] = ":arduino:",
    ["Arduino IDE"] = ":arduino:",
    ["Atom"] = ":atom:",
    ["Audacity"] = ":audacity:",
    ["Bambu Studio"] = ":bambu_studio:",
    ["MoneyMoney"] = ":bank:",
    ["Battle.net"] = ":battle_net:",
    ["Bear"] = ":bear:",
    ["BetterTouchTool"] = ":bettertouchtool:",
    ["Bilibili"] = ":bilibili:",
    ["哔哩哔哩"] = ":bilibili:",
    ["Bitwarden"] = ":bit_warden:",
    ["Blender"] = ":blender:",
    ["Blitzit"] = ":blitzit:",
    ["BluOS Controller"] = ":bluos_controller:",
    ["Books"] = ":book:",
    ["Calibre"] = ":book:",
    ["Bücher"] = ":book:",
    ["Brave Browser"] = ":brave_browser:",
    ["Bruno"] = ":bruno:",
    ["BusyCal"] = ":busycal:",
    ["Calculator"] = ":calculator:",
    ["Calculette"] = ":calculator:",
    ["Rechner"] = ":calculator:",
    ["Calendar"] = ":calendar:",
    ["日历"] = ":calendar:",
    ["Fantastical"] = ":calendar:",
    ["Cron"] = ":calendar:",
    ["Amie"] = ":calendar:",
    ["Calendrier"] = ":calendar:",
    ["カレンダー"] = ":calendar:",
    ["Notion Calendar"] = ":calendar:",
    ["Kalender"] = ":calendar:",
    ["calibre"] = ":calibre:",
    ["Capacities"] = ":capacities:",
    ["Caprine"] = ":caprine:",
    ["Amazon Chime"] = ":chime:",
    ["Cisco AnyConnect Secure Mobility Client"] = ":cisco_anyconnect:",
    ["Cisco Secure Client"] = ":cisco_anyconnect:",
    ["Citrix Workspace"] = ":citrix:",
    ["Citrix Viewer"] = ":citrix:",
    ["Claude"] = ":claude:",
    ["ClickUp"] = ":click_up:",
    ["Code"] = ":code:",
    ["Code - Insiders"] = ":code:",
    ["Cold Turkey Blocker"] = ":cold_turkey_blocker:",
    ["Color Picker"] = ":color_picker:",
    ["数码测色计"] = ":color_picker:",
    ["Copilot"] = ":copilot:",
    ["CotEditor"] = ":coteditor:",
    ["Creative Cloud"] = ":creative_cloud:",
    ["Cursor"] = ":cursor:",
    ["Cypress"] = ":cypress:",
    ["DataGrip"] = ":datagrip:",
    ["DataSpell"] = ":dataspell:",
    ["DaVinci Resolve"] = ":davinciresolve:",
    ["DBeaver"] = ":dbeaver:",
    ["DeepSeek"] = ":deepseek:",
    ["Deezer"] = ":deezer:",
    ["Default"] = ":default:",
    ["deno"] = ":deno:",
    ["CleanMyMac X"] = ":desktop:",
    ["DEVONthink 3"] = ":devonthink3:",
    ["Dexcom"] = ":dexcom:",
    ["Dia"] = ":dia:",
    ["DingTalk"] = ":dingtalk:",
    ["钉钉"] = ":dingtalk:",
    ["阿里钉"] = ":dingtalk:",
    ["Discord"] = ":discord:",
    ["Discord Canary"] = ":discord:",
    ["Discord PTB"] = ":discord:",
    ["Docker"] = ":docker:",
    ["Docker Desktop"] = ":docker:",
    ["GrandTotal"] = ":dollar:",
    ["Receipts"] = ":dollar:",
    ["Double Commander"] = ":doublecmd:",
    ["Drafts"] = ":drafts:",
    ["draw.io"] = ":draw_io:",
    ["Dropbox"] = ":dropbox:",
    ["Element"] = ":element:",
    ["Emacs"] = ":emacs:",
    ["Evernote Legacy"] = ":evernote_legacy:",
    ["FaceTime"] = ":face_time:",
    ["FaceTime 通话"] = ":face_time:",
    ["Feishu"] = ":feishu:",
    ["Figma"] = ":figma:",
    ["Final Cut Pro"] = ":final_cut_pro:",
    ["Finder"] = ":finder:",
    ["访达"] = ":finder:",
    ["Firefox"] = ":firefox:",
    ["Firefox Developer Edition"] = ":firefox_developer_edition:",
    ["Firefox Nightly"] = ":firefox_developer_edition:",
    ["FL Studio"] = ":flstudio:",
    ["Folx"] = ":folx:",
    ["Fork"] = ":fork:",
    ["Foxit PDF Reader"] = ":foxit_reader:",
    ["Freeform"] = ":freeform:",
    ["FreeTube"] = ":freetube:",
    ["Fusion"] = ":fusion:",
    ["System Preferences"] = ":gear:",
    ["System Settings"] = ":gear:",
    ["系统设置"] = ":gear:",
    ["Réglages Système"] = ":gear:",
    ["システム設定"] = ":gear:",
    ["Systemeinstellungen"] = ":gear:",
    ["System­einstellungen"] = ":gear:",
    ["Ghostty"] = ":ghostty:",
    ["GitHub Desktop"] = ":git_hub:",
    ["Godot"] = ":godot:",
    ["GoLand"] = ":goland:",
    ["Goodnotes"] = ":goodnotes:",
    ["Chromium"] = ":google_chrome:",
    ["Google Chrome"] = ":google_chrome:",
    ["Google Chrome Canary"] = ":google_chrome:",
    ["Thorium"] = ":google_chrome:",
    ["Grammarly Editor"] = ":grammarly:",
    ["Granola"] = ":granola:",
    ["Home Assistant"] = ":home_assistant:",
    ["Hyper"] = ":hyper:",
    ["IntelliJ IDEA"] = ":idea:",
    ["IINA"] = ":iina:",
    ["Adobe Illustrator"] = ":illustrator:",
    ["Illustrator"] = ":illustrator:",
    ["Adobe InDesign"] = ":indesign:",
    ["InDesign"] = ":indesign:",
    ["Infuse"] = ":infuse:",
    ["Inkdrop"] = ":inkdrop:",
    ["Inkscape"] = ":inkscape:",
    ["Insomnia"] = ":insomnia:",
    ["iPhone Mirroring"] = ":iphone_mirroring:",
    ["Iris"] = ":iris:",
    ["iTerm"] = ":iterm:",
    ["iTerm2"] = ":iterm:",
    ["Jellyfin Media Player"] = ":jellyfin:",
    ["Joplin"] = ":joplin:",
    ["카카오톡"] = ":kakaotalk:",
    ["KakaoTalk"] = ":kakaotalk:",
    ["Kakoune"] = ":kakoune:",
    ["KeePassXC"] = ":kee_pass_x_c:",
    ["Keyboard Maestro"] = ":keyboard_maestro:",
    ["Keynote"] = ":keynote:",
    ["Keynote 讲演"] = ":keynote:",
    ["kitty"] = ":kitty:",
    ["Kodi"] = ":kodi:",
    ["LanguageTool for Desktop"] = ":languagetool_for_desktop:",
    ["League of Legends"] = ":league_of_legends:",
    ["LibreWolf"] = ":libre_wolf:",
    ["LibreOffice"] = ":libreoffice:",
    ["Adobe Lightroom"] = ":lightroom:",
    ["Lightroom Classic"] = ":lightroomclassic:",
    ["LINE"] = ":line:",
    ["Linear"] = ":linear:",
    ["LM Studio"] = ":lm_studio:",
    ["LocalSend"] = ":localsend:",
    ["Logic Pro"] = ":logicpro:",
    ["Logseq"] = ":logseq:",
    ["Canary Mail"] = ":mail:",
    ["HEY"] = ":mail:",
    ["Mail"] = ":mail:",
    ["Mailspring"] = ":mail:",
    ["MailMate"] = ":mail:",
    ["Superhuman"] = ":mail:",
    ["Spark"] = ":mail:",
    ["邮件"] = ":mail:",
    ["メール"] = ":mail:",
    ["MAMP"] = ":mamp:",
    ["MAMP PRO"] = ":mamp:",
    ["Maps"] = ":maps:",
    ["Google Maps"] = ":maps:",
    ["マップ"] = ":maps:",
    ["Karten"] = ":maps:",
    ["Marta"] = ":marta:",
    ["Matlab"] = ":matlab:",
    ["MATLABWindow"] = ":matlab:",
    ["MATLAB_R2024b"] = ":matlab:",
    ["MATLAB_R2024a"] = ":matlab:",
    ["MATLAB_R2023b"] = ":matlab:",
    ["MATLAB_R2023a"] = ":matlab:",
    ["MATLAB_R2022b"] = ":matlab:",
    ["MATLAB_R2022a"] = ":matlab:",
    ["MATLAB_R2021b"] = ":matlab:",
    ["MATLAB_R2021a"] = ":matlab:",
    ["Mattermost"] = ":mattermost:",
    ["Google Meet"] = ":meet:",
    ["Messages"] = ":messages:",
    ["信息"] = ":messages:",
    ["Nachrichten"] = ":messages:",
    ["メッセージ"] = ":messages:",
    ["Messenger"] = ":messenger:",
    ["Microsoft Edge"] = ":microsoft_edge:",
    ["Microsoft Excel"] = ":microsoft_excel:",
    ["Microsoft Outlook"] = ":microsoft_outlook:",
    ["Microsoft PowerPoint"] = ":microsoft_power_point:",
    ["Microsoft Remote Desktop"] = ":microsoft_remote_desktop:",
    ["Microsoft Teams"] = ":microsoft_teams:",
    ["Microsoft Teams (work or school)"] = ":microsoft_teams:",
    ["Microsoft Word"] = ":microsoft_word:",
    ["Min"] = ":min_browser:",
    ["Miro"] = ":miro:",
    ["MongoDB Compass"] = ":mongodb:",
    ["Moonlight"] = ":moonlight:",
    ["mpv"] = ":mpv:",
    ["Mullvad Browser"] = ":mullvad_browser:",
    ["Music"] = ":music:",
    ["音乐"] = ":music:",
    ["Musique"] = ":music:",
    ["ミュージック"] = ":music:",
    ["Musik"] = ":music:",
    ["Navicat Premium"] = ":navicat:",
    ["Neovide"] = ":neovide:",
    ["neovide"] = ":neovide:",
    ["Neovim"] = ":neovim:",
    ["neovim"] = ":neovim:",
    ["nvim"] = ":neovim:",
    ["网易云音乐"] = ":netease_music:",
    ["NimbleCommander"] = ":nimble_commander:",
    ["NimbleCommander-Unsigned"] = ":nimble_commander:",
    ["Noodl"] = ":noodl:",
    ["Noodl Editor"] = ":noodl:",
    ["NordVPN"] = ":nord_vpn:",
    ["Notability"] = ":notability:",
    ["Notes"] = ":notes:",
    ["备忘录"] = ":notes:",
    ["メモ"] = ":notes:",
    ["Notizen"] = ":notes:",
    ["Notion"] = ":notion:",
    ["Nova"] = ":nova:",
    ["Numbers"] = ":numbers:",
    ["Numbers 表格"] = ":numbers:",
    ["Obsidian"] = ":obsidian:",
    ["OBS"] = ":obsstudio:",
    ["OmniFocus"] = ":omni_focus:",
    ["1Password"] = ":one_password:",
    ["Open Video Downloader"] = ":open_video_downloader:",
    ["ChatGPT"] = ":openai:",
    ["OpenAI Translator"] = ":openai_translator:",
    ["OpenVPN Connect"] = ":openvpn_connect:",
    ["Opera"] = ":opera:",
    ["OrbStack"] = ":orbstack:",
    ["OrcaSlicer"] = ":orcaslicer:",
    ["Orion"] = ":orion:",
    ["Orion RC"] = ":orion:",
    ["Overleaf"] = ":overleaf:",
    ["ShareLaTeX"] = ":overleaf:",
    ["Pages"] = ":pages:",
    ["Pages 文稿"] = ":pages:",
    ["Parallels Desktop"] = ":parallels:",
    ["Parsec"] = ":parsec:",
    ["Passwords"] = ":passwords:",
    ["Passwörter"] = ":passwords:",
    ["PDF Expert"] = ":pdf_expert:",
    ["Pearcleaner"] = ":pearcleaner:",
    ["Phoenix Slides"] = ":phoenix_slides:",
    ["Photos"] = ":photos:",
    ["Fotos"] = ":photos:",
    ["Adobe Photoshop"] = ":photoshop:",
    ["PhpStorm"] = ":php_storm:",
    ["Pi-hole Remote"] = ":pihole:",
    ["Pine"] = ":pine:",
    ["Plex"] = ":plex:",
    ["Plexamp"] = ":plexamp:",
    ["Podcasts"] = ":podcasts:",
    ["播客"] = ":podcasts:",
    ["PomoDone App"] = ":pomodone:",
    ["Postman"] = ":postman:",
    ["Premiere"] = ":premiere:",
    ["Adobe Premiere"] = ":premiere:",
    ["Adobe Premiere Pro 2024"] = ":premiere:",
    ["Preview"] = ":preview:",
    ["预览"] = ":preview:",
    ["Skim"] = ":preview:",
    ["zathura"] = ":preview:",
    ["Aperçu"] = ":preview:",
    ["プレビュー"] = ":preview:",
    ["Vorschau"] = ":preview:",
    ["Proton Mail"] = ":proton_mail:",
    ["Proton Mail Bridge"] = ":proton_mail:",
    ["Proton VPN"] = ":proton_vpn:",
    ["ProtonVPN"] = ":proton_vpn:",
    ["PrusaSlicer"] = ":prusaslicer:",
    ["SuperSlicer"] = ":prusaslicer:",
    ["PyCharm"] = ":pycharm:",
    ["qBittorrent"] = ":qbittorrent:",
    ["QLMarkdown"] = ":qlmarkdown:",
    ["QQ"] = ":qq:",
    ["QQ音乐"] = ":qqmusic:",
    ["QQMusic"] = ":qqmusic:",
    ["Quantumult X"] = ":quantumult_x:",
    ["qutebrowser"] = ":qute_browser:",
    ["Raindrop.io"] = ":raindrop_io:",
    ["Raycast"] = ":raycast:",
    ["Reeder"] = ":reeder5:",
    ["rekordbox"] = ":rekordbox:",
    ["Reminders"] = ":reminders:",
    ["提醒事项"] = ":reminders:",
    ["Rappels"] = ":reminders:",
    ["リマインダー"] = ":reminders:",
    ["Erinnerungen"] = ":reminders:",
    ["Replit"] = ":replit:",
    ["Repo Prompt"] = ":repo_prompt:",
    ["Rider"] = ":rider:",
    ["JetBrains Rider"] = ":rider:",
    ["Rio"] = ":rio:",
    ["Royal TSX"] = ":royaltsx:",
    ["RustDesk"] = ":rustdesk:",
    ["Safari"] = ":safari:",
    ["Safari浏览器"] = ":safari:",
    ["Safari Technology Preview"] = ":safari:",
    ["Sequel Ace"] = ":sequel_ace:",
    ["Sequel Pro"] = ":sequel_pro:",
    ["Session"] = ":session:",
    ["Setapp"] = ":setapp:",
    ["SF Symbols"] = ":sf_symbols:",
    ["SF Symbole"] = ":sf_symbols:",
    ["Shortcuts"] = ":shortcuts:",
    ["Signal"] = ":signal:",
    ["sioyek"] = ":sioyek:",
    ["Sketch"] = ":sketch:",
    ["Skype"] = ":skype:",
    ["Slack"] = ":slack:",
    ["Spark Desktop"] = ":spark:",
    ["Spotify"] = ":spotify:",
    ["Spotlight"] = ":spotlight:",
    ["Steam"] = ":steam:",
    ["Steam Helper"] = ":steam:",
    ["Studio 3T"] = ":studio_3t:",
    ["Sublime Text"] = ":sublime_text:",
    ["Summoners War"] = ":summoners_war:",
    ["superProductivity"] = ":superproductivity:",
    ["Surfshark"] = ":surfshark:",
    ["T3 Chat"] = ":t3chat:",
    ["Tabby"] = ":tabby:",
    ["TablePlus"] = ":tableplus:",
    ["Tana"] = ":tana:",
    ["TeamSpeak 3"] = ":team_speak:",
    ["Telegram"] = ":telegram:",
    ["Terminal"] = ":terminal:",
    ["终端"] = ":terminal:",
    ["ターミナル"] = ":terminal:",
    ["Typora"] = ":text:",
    ["TextEdit"] = ":textedit:",
    ["Microsoft To Do"] = ":things:",
    ["Things"] = ":things:",
    ["Thunderbird"] = ":thunderbird:",
    ["TickTick"] = ":tick_tick:",
    ["TIDAL"] = ":tidal:",
    ["Tiny RDM"] = ":tinyrdm:",
    ["Todoist"] = ":todoist:",
    ["Toggl Track"] = ":toggl_track:",
    ["Tor Browser"] = ":tor_browser:",
    ["Tower"] = ":tower:",
    ["TradingView"] = ":trading_view:",
    ["Transmit"] = ":transmit:",
    ["Trello"] = ":trello:",
    ["Tweetbot"] = ":twitter:",
    ["Twitter"] = ":twitter:",
    ["UTM"] = ":utm:",
    ["VeraCrypt"] = ":veracrypt:",
    ["MacVim"] = ":vim:",
    ["Vim"] = ":vim:",
    ["VimR"] = ":vim:",
    ["Vivaldi"] = ":vivaldi:",
    ["VLC"] = ":vlc:",
    ["VMware Fusion"] = ":vmware_fusion:",
    ["Vorta"] = ":vorta:",
    ["VSCodium"] = ":vscodium:",
    ["Warp"] = ":warp:",
    ["Weather"] = ":weather:",
    ["Wetter"] = ":weather:",
    ["WebStorm"] = ":web_storm:",
    ["Webull Desktop"] = ":webull:",
    ["微信"] = ":wechat:",
    ["WeChat"] = ":wechat:",
    ["企业微信"] = ":wecom:",
    ["WeCom"] = ":wecom:",
    ["WezTerm"] = ":wezterm:",
    ["WhatsApp"] = ":whats_app:",
    ["‎WhatsApp"] = ":whats_app:",
    ["Windows App"] = ":windows_app:",
    ["WireGuard"] = ":wireguard:",
    ["Xcode"] = ":xcode:",
    ["Yandex Browser"] = ":yandex_bower:",
    ["Yandex"] = ":yandex_bower:",
    ["Yandex Music"] = ":yandex_music:",
    ["Yazi"] = ":yazi:",
    ["yazi"] = ":yazi:",
    ["YouTube"] = ":youtube:",
    ["YouTube Music"] = ":youtube_music:",
    ["Yuque"] = ":yuque:",
    ["语雀"] = ":yuque:",
    ["Zed"] = ":zed:",
    ["Zen"] = ":zen_browser:",
    ["Zen Browser"] = ":zen_browser:",
    ["Zeplin"] = ":zeplin:",
    ["zoom.us"] = ":zoom:",
    ["Zotero"] = ":zotero:",
    ["Zulip"] = ":zulip:"
  }
  
  -- Check for exact match first
  local icon = icon_map[app_name]
  if icon then
    return icon
  end
  
  -- Check for partial matches (for apps with version numbers or suffixes)
  for app_pattern, app_icon in pairs(icon_map) do
    if app_name:find(app_pattern, 1, true) then
      return app_icon
    end
  end
  
  -- Return default icon if no match found
  return ":default:"
end

return helpers