--[[	Buttons	]]--

local format = string.format
local tostring = tostring

----------------------

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetLFGMode = GetLFGMode
local HasNewMail = HasNewMail

----------------------

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Buttons = HideBlizzard:NewModule("Buttons")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local mod = Buttons
local mod_debug = false
local mod_prefix = "|cffAEAEE0"..tostring(mod)..":|r"

local dummy = function() end

----------------------

local settings
local defaults = {
	profile = {
		-- minimap
		["calendar"] = nil,
		["clock"] = nil,
		["garrison"] = nil,
		["instance"] = nil,
		["lfg"] = nil,
		["mail"] = nil,
		["tracking"] = nil,
		["voice"] = nil,
		["world"] = nil,
		["zoom"] = nil,
		-- chat
		["channel"] = nil,
		["menu"] = nil,
		["quickjoin"] = nil,
		["chatvoice"] = nil,
		["scrollbar"] = nil, -- todo
	},
}

----------------------

local function debug_out(...)
	if (mod_debug) then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", mod_prefix, ...), 1, 0, 0)
	end
end

----------------------

function mod:getOptions()
debug_out("Buttons getOptions")
return {
	name = L["Buttons"],
	type = "group",
	get = function(info)
		local key = info[#info]
		local v = settings[key]

		return v
	end,
	set = function(info, value)
		local key = info[#info]
		settings[key] = value
	end,
	args = {
		enabled = {
			name = format("|cffFFFF55%s|r", L["Enable Buttons"]),
			desc = format("|cffFFFF55%s|r", L["Hides buttons connected to the chat and minimap frame."]),
			descStyle = "inline",
			type = "toggle",
			order = 1,
			width = "full",
			get = function() return HideBlizzard:GetModuleEnabled("Buttons") end,
			set = function(info, value) HideBlizzard:SetModuleEnabled("Buttons", value) end,
		},
		spacer = {
			name = "",
			type = "description",
			order = 1.5,
		},
		minimap = {
			order = 2,
			type = "group",
			name = L["Minimap Buttons"],
			inline = true,
			args = {
				calendar = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Calendar"],
					desc = L["Hides the calendar button."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.calendar = v
						mod:UpdateCalendar()
					end,
				},
				clock = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Clock"],
					desc = L["Hides the clock."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.clock = v
						mod:UpdateClock()
					end,
				},
				garrison = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Garrison"],
					desc = L["Hides the garrison button."],
					type = "toggle",
					order = 3,
					set = function(info, v)
						settings.garrison = v
						mod:UpdateGarrison()
					end,
				},
				instance = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Instance"],
					desc = L["Hides the instance difficulty button."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.instance = v
						mod:UpdateInstance()
					end,
				},
				lfg = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Looking For Group"],
					desc = L["Hides the looking for group (LFG) button."],
					type = "toggle",
					order = 5,
					set = function(info, v)
						settings.lfg = v
						mod:UpdateLFG()
					end,
				},
				mail = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Mail"],
					desc = L["Hides the mail button."],
					type = "toggle",
					order = 6,
					set = function(info, v)
						settings.mail = v
						mod:UpdateMail()
					end,
				},
				tracking = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Tracking"],
					desc = L["Hides the tracking button."],
					type = "toggle",
					order = 7,
					set = function(info, v)
						settings.tracking = v
						mod:UpdateTracking()
					end,
				},
				voice = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Voice"],
					desc = L["Hides the voice chat button."],
					type = "toggle",
					order = 8,
					set = function(info, v)
						settings.voice = v
						mod:UpdateVoice()
					end,
				},
				world = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["World Map"],
					desc = L["Hides the world map button."],
					type = "toggle",
					order = 9,
					set = function(info, v)
						settings.world = v
						mod:UpdateWorld()
					end,
				},
				zoom = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Zoom"],
					desc = L["Hides both the zoom buttons."],
					type = "toggle",
					order = 10,
					set = function(info, v)
						settings.zoom = v
						mod:UpdateZoom()
					end,
				},
			},
		},
		chat = {
			order = 3,
			type = "group",
			name = L["Chat Buttons"],
			inline = true,
			args = {
				channel = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Channel"],
					desc = L["Hides the chat channel button on the chat frame."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.channel = v
						mod:UpdateChannel()
					end,
				},
				menu = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Menu"],
					desc = L["Hides the chat menu button on the chat frame."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.menu = v
						mod:UpdateMenu()
					end,
				},
				quickjoin = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Quick Join"],
					desc = L["Hides the chat quick join toast button on the chat frame."],
					type = "toggle",
					order = 3,
					set = function(info, v)
						settings.quickjoin = v
						mod:UpdateQuickjoin()
					end,
				},
				chatvoice = {
					disabled = function() return not Buttons:IsEnabled() end,
					name = L["Voice"],
					desc = L["Hides the chat voice buttons on the chat frame."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.chatvoice = v
						mod:UpdateChatVoice()
					end,
				},
			},
		},
	},
}
end

----------------------

function mod:OnInitialize()
	debug_out("Buttons OnInitialize")

	mod:SetEnabledState(HideBlizzard:GetModuleEnabled("Buttons"))

	mod.db = HideBlizzard.db:RegisterNamespace("Buttons", defaults)
	settings = mod.db.profile

	local options = mod:getOptions()
	HideBlizzard:RegisterModuleOptions("Buttons", options, "Buttons")

end

----------------------

function mod:OnEnable()
	debug_out("Buttons OnEnable")

	mod:UpdateView()
end

----------------------

function mod:OnDisable()
	debug_out("Buttons OnDisable")

	mod:UpdateView()
end

----------------------

function mod:UpdateView()
	debug_out("Buttons UpdateView")

	mod:UpdateCalendar()
	mod:UpdateClock()
	mod:UpdateGarrison()
	mod:UpdateInstance()
	mod:UpdateLFG()
	mod:UpdateMail()
	mod:UpdateTracking()
	mod:UpdateVoice()
	mod:UpdateWorld()
	mod:UpdateZoom()

	mod:UpdateChannel()
	mod:UpdateMenu()
	mod:UpdateQuickjoin()
	mod:UpdateChatVoice()
end

----------------------

function mod:UpdateCalendar()
	if (settings.calendar == nil) then return end
	debug_out("UpdateCalendar")

	local GameTimeFrame = _G.GameTimeFrame
	if (settings.calendar and mod:IsEnabled()) then
		GameTimeFrame:Hide()
		GameTimeFrame.Show = dummy
	else
		GameTimeFrame.Show = nil
		GameTimeFrame:Show()

		settings.calendar = nil
	end
end

----------------------

function mod:UpdateClock()
	if (settings.clock == nil) then return end
	debug_out("UpdateClock")

	local TimeManagerClockButton = _G.TimeManagerClockButton
	if (settings.clock and mod:IsEnabled()) then
		TimeManagerClockButton:Hide()
		TimeManagerClockButton.Show = dummy
	else
		TimeManagerClockButton.Show = nil
		TimeManagerClockButton:Show()

		settings.clock = nil
	end
end

----------------------

function mod:UpdateGarrison()
	if (settings.garrison == nil) then return end
	debug_out("UpdateGarrison")

	local GarrisonLandingPageMinimapButton = _G.GarrisonLandingPageMinimapButton
	if (settings.garrison and mod:IsEnabled()) then
		GarrisonLandingPageMinimapButton:Hide()
		GarrisonLandingPageMinimapButton.Show = dummy
	else
		GarrisonLandingPageMinimapButton.Show = nil
		if (GarrisonLandingPageMinimapButton) then
			GarrisonLandingPageMinimapButton:Show()
		end
		settings.garrison = nil
	end
end

----------------------

function mod:UpdateInstance()
	if (settings.instance == nil) then return end
	debug_out("UpdateInstance")

	local MiniMapInstanceDifficulty = _G.MiniMapInstanceDifficulty
	if (settings.instance and mod:IsEnabled()) then
		MiniMapInstanceDifficulty:Hide()
		MiniMapInstanceDifficulty.Show = dummy
	else
		MiniMapInstanceDifficulty.Show = nil
		if (MiniMapInstanceDifficulty) then
			MiniMapInstanceDifficulty:Show()
		end
		settings.instance = nil
	end
end

----------------------

function mod:UpdateLFG()
	if (settings.lfg == nil) then return end
	debug_out("UpdateLFG")

	local QueueStatusMinimapButton = _G.QueueStatusMinimapButton
	if (settings.lfg and mod:IsEnabled()) then
		for i=1, NUM_LE_LFG_CATEGORYS do
			local mode, submode = GetLFGMode(i)
			if (mode == "queued") then
				QueueStatusMinimapButton:Hide()
				QueueStatusMinimapButton.Show = dummy
			end
		end
	else
		for i=1, NUM_LE_LFG_CATEGORYS do
			local mode, submode = GetLFGMode(i)
			if ( mode == "queued" ) then
				QueueStatusMinimapButton.Show = nil
				QueueStatusMinimapButton:Show()
			end
		end
		settings.lfg = nil
	end
end

----------------------

function mod:UpdateMail()
	if (settings.mail == nil) then return end
	debug_out("UpdateMail")

	local MiniMapMailFrame = _G.MiniMapMailFrame
	if (settings.mail and mod:IsEnabled()) then
		if (HasNewMail()) then
			MiniMapMailFrame:Hide()
			MiniMapMailFrame.Show = dummy
		end
	else
		if (HasNewMail()) then
			MiniMapMailFrame.Show = nil
			MiniMapMailFrame:Show()
		end
		settings.mail = nil
	end
end

----------------------

function mod:UpdateTracking()
	if (settings.tracking == nil) then return end
	debug_out("UpdateTracking")

	local MiniMapTracking = _G.MiniMapTracking
	if (settings.tracking and mod:IsEnabled()) then
		MiniMapTracking:Hide()
		MiniMapTracking.Show = dummy
	else
		MiniMapTracking.Show = nil
		MiniMapTracking:Show()

		settings.tracking = nil
	end
end

----------------------

function mod:UpdateVoice()
	if (settings.voice == nil) then return end
	debug_out("UpdateVoice")

	local MiniMapVoiceChatFrame = _G.MiniMapVoiceChatFrame
	if (settings.voice and mod:IsEnabled()) then
		if (MiniMapVoiceChatFrame) then
			MiniMapVoiceChatFrame:Hide()
			MiniMapVoiceChatFrame.Show = dummy
		end
	else
		if (MiniMapVoiceChatFrame) then
			MiniMapVoiceChatFrame.Show = nil
			MiniMapVoiceChatFrame:Show()
		end
		settings.voice = nil
	end
end

----------------------

function mod:UpdateWorld()
	if (settings.world == nil) then return end
	debug_out("UpdateWorld")

	local MiniMapWorldMapButton = _G.MiniMapWorldMapButton
	if (settings.world and mod:IsEnabled()) then
		MiniMapWorldMapButton:Hide()
		MiniMapWorldMapButton.Show = dummy
	else
		MiniMapWorldMapButton.Show = nil
		MiniMapWorldMapButton:Show()

		settings.world = nil
	end
end

----------------------

function mod:UpdateZoom()
	if (settings.zoom == nil) then return end
	debug_out("UpdateZoom")

	local MinimapZoomIn = _G.MinimapZoomIn
	local MinimapZoomOut = _G.MinimapZoomOut
	if (settings.zoom and mod:IsEnabled()) then
		MinimapZoomIn:Hide()
		MinimapZoomIn.Show = dummy

		MinimapZoomOut:Hide()
		MinimapZoomOut.Show = dummy
	else
		MinimapZoomIn.Show = nil
		MinimapZoomIn:Show()

		MinimapZoomOut.Show = nil
		MinimapZoomOut:Show()

		settings.zoom = nil
	end
end

----------------------

function mod:UpdateChannel()
	if (settings.channel == nil) then return end
	debug_out("UpdateChannel")

	local ChatFrameChannelButton = _G.ChatFrameChannelButton
	if (settings.channel and mod:IsEnabled()) then
		ChatFrameChannelButton:Hide()
		ChatFrameChannelButton.Show = dummy
	else
		ChatFrameChannelButton.Show = nil
		ChatFrameChannelButton:Show()

		settings.channel = nil
	end
end

----------------------

function mod:UpdateMenu()
	if (settings.menu == nil) then return end
	debug_out("UpdateMenu")

	local ChatFrameMenuButton = _G.ChatFrameMenuButton
	if (settings.menu and mod:IsEnabled()) then
		ChatFrameMenuButton:Hide()
		ChatFrameMenuButton.Show = dummy
	else
		ChatFrameMenuButton.Show = nil
		ChatFrameMenuButton:Show()

		settings.menu = nil
	end
end

----------------------

function mod:UpdateQuickjoin()
	if (settings.quickjoin == nil) then return end
	debug_out("UpdateQuickjoin")

	local QuickJoinToastButton = _G.QuickJoinToastButton
	if (settings.quickjoin and mod:IsEnabled()) then
		if (QuickJoinToastButton) then
			QuickJoinToastButton:Hide()
			QuickJoinToastButton.Show = dummy
		end
	else
		if (QuickJoinToastButton) then
			QuickJoinToastButton.Show = nil
			QuickJoinToastButton:Show()
		end
		settings.quickjoin = nil
	end
end

----------------------

function mod:UpdateChatVoice()
	if (settings.chatvoice == nil) then return end
	debug_out("UpdateChatVoice")

	local ChatFrameToggleVoiceDeafenButton = _G.ChatFrameToggleVoiceDeafenButton
	if (settings.chatvoice and mod:IsEnabled()) then

		if (ChatFrameToggleVoiceDeafenButton) then
			ChatFrameToggleVoiceDeafenButton:Hide()
			ChatFrameToggleVoiceDeafenButton.Show = dummy
		end
	else
		if (ChatFrameToggleVoiceDeafenButton) then
			ChatFrameToggleVoiceDeafenButton.Show = nil
		end
		settings.chatvoice = nil
	end
end
