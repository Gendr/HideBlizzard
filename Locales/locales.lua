--[[	Locale	]]--

local format = string.format
local print = print
local rawset = rawset
local setmetatable = setmetatable
local tostring = tostring

----------------------

local GAME_LOCALE = GAME_LOCALE
local GetLocale = GetLocale

----------------------

local addonName, ns = ...

----------------------

local locale = GAME_LOCALE or GetLocale()
if (locale == "enGB") then locale = "enUS" end

local L = setmetatable({}, {
	__index = function(t, k)
		if (locale ~= "enUS") then print(format("|cffaeaee0%s:|r |cffff0000No translation available in your language!|r |cffffffff(%s)", addonName, locale)) end
		local v = tostring(k)
		rawset(t, k, v)

		return v
	end
})

ns.L = L

if (locale == "enUS") then
L["Welcome! Type /hideblizz to configure."] = "Welcome! Type /hideblizz to configure."
L["Updated to latest version"] = "Updated to latest version"
L["Cannot open options while in combat."] = "Cannot open options while in combat."

L["Info"] = "Info"
L["Version:"] = "Version:"
L["Reset"] = "Reset"
L["This will wipe all settings and reload the user interface."] = "This will wipe all settings and reload the user interface."

L["ActionBar"] = "ActionBar"
L["Enable Action Bar"] = "Enable Action Bar"
L["Hide frames connected to the action bar."] = "Hide frames connected to the action bar."
L["Bag Bar"] = "Bag Bar"
L["Hides the bag bar frame."] = "Hides the bag bar frame."
L["Gryphons"] = "Gryphons"
L["Hides the art (gryphons) at each ends of the action bar."] = "Hides the art (gryphons) at each ends of the action bar."
L["Hotkey"] = "Hotkey"
L["Hides the hotkey text on the action bar buttons."] = "Hides the hotkey text on the action bar buttons."
L["Macro"] = "Macro"
L["Hides the macro text on the action bar buttons."] = "Hides the macro text on the action bar buttons."
L["Main Menu Bar"] = "Main Menu Bar"
L["Hides the action bar frame."] = "Hides the action bar frame."
L["Note: Most options will be disabled."] = "Note: Most options will be disabled."
L["Micro Bar"] = "Micro Bar"
L["Hides the micro bar buttons located at the bottom-right of the screen."] = "Hides the micro bar buttons located at the bottom-right of the screen."
L["Stance Bar"] = "Stance Bar"
L["Hides the stance / shapeshift bar."] = "Hides the stance / shapeshift bar."
L["Status Tracking Bar"] = "Status Tracking Bar"
L["Hides all status tracking bars (artifact/faction/honor/level)."] = "Hides all status tracking bars (artifact/faction/honor/level)."
L["Vehicle Leave"] = "Vehicle Leave"
L["Hides the vehicle leave button above the action bar."] = "Hides the vehicle leave button above the action bar."
L["Vehicle Menu Bar"] = "Vehicle Menu Bar"
L["Hides the vehicle action bar."] = "Hides the vehicle action bar."

L["Alert Frames"] = "Alert Frames"
L["Azerite Alert"] = "Azerite Alert"
L["Hides the azerite alert window."] = "Hides the azerite alert window."
L["Collection Alert"] = "Collection Alert"
L["Hides the collection alert window."] = "Hides the collection alert window."
L["Talent Alert"] = "Talent Alert"
L["Hides the talent alert window."] = "Hides the talent alert window."

L["Buttons"] = "Buttons"
L["Enable Buttons"] = "Enable Buttons"
L["Hides buttons connected to the chat and minimap frame."] = "Hides buttons connected to the chat and minimap frame."

L["Minimap Buttons"] = "Minimap Buttons"
L["Calendar"] = "Calendar"
L["Hides the calendar button."] = "Hides the calendar button."
L["Clock"] = "Clock"
L["Hides the clock."] = "Hides the clock."
L["Garrison"] = "Garrison"
L["Hides the garrison button."] = "Hides the garrison button."
L["Instance"] = "Instance"
L["Hides the instance difficulty button."] = "Hides the instance difficulty button."
L["Looking For Group"] = "Looking For Group"
L["Hides the looking for group (LFG) button."] = "Hides the looking for group (LFG) button."
L["Mail"] = "Mail"
L["Hides the mail button."] = "Hides the mail button."
L["Tracking"] = "Tracking"
L["Hides the tracking button."] = "Hides the tracking button."
L["Voice"] = "Voice"
L["Hides the voice chat button."] = "Hides the voice chat button."
L["World Map"] = "World Map"
L["Hides the world map button."] = "Hides the world map button."
L["Zoom"] = "Zoom"
L["Hides both the zoom buttons"] = "Hides both the zoom buttons."

L["Chat Buttons"] = "Chat Buttons"
L["Channel"] = "Channel"
L["Hides the chat channel button on the chat frame."] = "Hides the chat channel button on the chat frame."
L["Menu"] = "Menu"
L["Hides the chat menu button on the chat frame."] = "Hides the chat menu button on the chat frame."
L["Quick Join"] = "Quick Join"
L["Hides the chat quick join toast button on the chat frame."] = "Hides the chat quick join toast button on the chat frame."
L["Voice"] = "Voice"
L["Hides the chat voice buttons on the chat frame."] = "Hides the chat voice buttons on the chat frame."

L["Pet"] = "Pet"
L["Enable Pet"] = "Enable Pet"
L["Hides pet related frames."] = "Hides pet related frames."
L["Pet Action Bar"] = "Pet Action Bar"
L["Hides the pet action bar."] = "Hides the pet action bar."
L["Pet Cast Bar"] = "Pet Cast Bar"
L["Hides the pet casting bar."] = "Hides the pet casting bar."
L["Party Pet Unit Frame"] = "Party Pet Unit Frame"
L["Hides the party pet unit frame."] = "Hides the party pet unit frame."
L["Pet Unit Frame"] = "Pet Unit Frame"
L["Hides the pet unit frame."] = "Hides the pet unit frame."

L["Player"] = "Player"
L["Enable Player"] = "Enable Player"
L["Hides player related frames."] = "Hides player related frames."
L["Arcane Bar"] = "Arcane Bar"
L["Hides the %smage class%s arcane charges bar."] = "Hides the %smage class%s arcane charges bar."
L["Chi Bar"] = "Chi Bar"
L["Hides the %smonk class%s chi bar."] = "Hides the %smonk class%s chi bar."
L["Combo Bar"] = "Combo Bar"
L["Hides the %sdruid%s / %srogue%s class combo bar."] = "Hides the %sdruid%s / %srogue%s class combo bar."
L["Insanity Bar"] = "Insanity Bar"
L["Hides the priest class insanity bar."] = "Hides the priest class insanity bar."
L["Power Bar"] = "Power Bar"
L["Hides the %spaladin class%s power bar."] = "Hides the %spaladin class%s power bar."
L["Priest Bar"] = "Priest Bar"
L["Hides the priest class bar."] = "Hides the priest class bar."
L["Rune Frame"] = "Rune Frame"
L["Hides the %sdeathknight class%s rune frame."] = "Hides the %sdeathknight class%s rune frame."
L["Shard Frame"] = "Shard Frame"
L["Hides the %swarlock class%s shard frame."] = "Hides the %swarlock class%s shard frame."
L["Stagger Bar"] = "Stagger Bar"
L["Hides the %smonk class%s stagger bar."] = "Hides the %smonk class%s stagger bar."
L["Totem Frame"] = "Totem Frame"
L["Hides the totem frame."] = "Hides the totem frame."

L["Unit Frames"] = "Unit Frames"
L["Focus Frame"] = "Focus Frame"
L["Hides the focus frame."] = "Hides the focus frame."
L["Player Cast Bar"] = "Player Cast Bar"
L["Hides the player cast bar."] = "Hides the player cast bar."
L["Player Power Bar"] = "Player Power Bar"
L["Hides the player power bar."] = "Hides the player power bar."
L["Player Unit Frame"] = "Player Unit Frame"
L["Hides the player unit frame."] = "Hides the player unit frame."
L["Target Unit Frame"] = "Target Unit Frame"
L["Hides the target unit frame."] = "Hides the target unit frame."
L["SpecialFrames"] = "SpecialFrames"
L["Enable Special Frames"] = "Enable Special Frames"
L["Hides various UI frames."] = "Hides various UI frames."
L["Armored Man"] = "Armored Man"
L["Hides the armored man (durability) under the minimap."] = "Hides the armored man (durability) under the minimap."
L["Aura"] = "Aura"
L["Hides the buff / debuff frame."] = "Hides the buff / debuff frame."
L["Capture Bar"] = "Capture Bar"
L["Hides the capture bar under the minimap."] = "Hides the capture bar under the minimap."
L["Island Expedition"] = "Island Expedition"
L["Hides the island expedition frame at top of the screen."] = "Hides the island expedition frame at top of the screen."
L["Note: This will hide other top screen UI frames."] = "Note: This will hide other top screen UI frames."
L["Minimap"] = "Minimap"
L["Hides the minimap."] = "Hides the minimap."
L["Mirror Bar"] = "Mirror Bar"
L["Hides the mirror (breath/fatigue) bar at top of screen."] = "Hides the mirror (breath/fatigue) bar at top of screen."
L["Talking Head"] = "Talking Head"
L["Hides the talking head frame."] = "Hides the talking head frame."
L["Vehicle Seat Indicator"] = "Vehicle Seat Indicator"
L["Hides the vehicle seat indicator frame under the minimap."] = "Hides the vehicle seat indicator frame under the minimap."

L["All Alerts"] = "All Alerts"
L["Hides all alert windows."] = "Hides all alert windows."
L["Boss Alert"] = "Boss Alert"
L["Hides the boss killed alert window."] = "Hides the boss alert window."
L["Garrison Alert"] = "Garrison Alert"
L["Hides the garrison alert window."] = "Hides the garrison alert window."
L["Level Up Alert"] = "Level Up Alert"
L["Hides the level up alert window."] = "Hides the level up alert window."

L["Messages"] = "Messages"
L["System Message"] = "System Message"
L["Hides all the system message text at top of the screen."] = "Hides all the system message text at top of the screen."
L["Info Message"] = "Info Message"
L["Hides all the notification text at top of the screen."] = "Hides all the notification text at top of the screen."
L["Error Message"] = "Error Message"
L["Hides all the error text at top of the screen."] = "Hides all the error text at top of the screen."
L["Subzone Text"] = "Subzone Text"
L["Hides the subzone text in middle of the screen."] = "Hides the subzone text in middle of the screen."
L["Zone Text"] = "Zone Text"
L["Hides the zone text in middle of the screen."] = "Hides the zone text in middle of the screen."

L["Party/Raid"] = "Party/Raid"
L["Boss Frame"] = "Boss Frame"
L["Hides the boss frames under the minimap."] = "Hides the boss frames under the minimap."
L["Compact Raid Frame"] = "Compact Raid Frame"
L["Hides the compact raid frame box on left side of screen."] = "Hides the compact raid frame box on left side of screen."
L["Party Frame"] = "Party Frame"
L["Hides the party frame."] = "Hides the party frame."
L["Phasing Icon"] = "Phasing Icon"
L["Hides the phasing icon when in a party."] = "Hides the phasing icon when in a party."
L["Tooltips"] = "Tooltips"
L["Game Tooltip"] = "Game Tooltip"
L["Hides the game tooltip frame."] = "Hides the game tooltip frame."
L["Shopping Tooltips"] = "Shopping Tooltips"
L["Hides both the shopping tooltip frames."] = "Hides both the shopping tooltip frames."
end
