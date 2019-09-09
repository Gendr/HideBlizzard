--[[	Action Bar	]]--

local format = string.format
local next = next
local tostring = tostring

----------------------

local AddMessage = AddMessage
local CanExitVehicle = CanExitVehicle
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetNumShapeshiftForms = GetNumShapeshiftForms
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitInVehicle = UnitInVehicle

----------------------

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local ActionBar = HideBlizzard:NewModule("ActionBar")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local mod = ActionBar
local mod_debug = false
local mod_prefix = "|cffaeaee0"..tostring(mod)..":|r"

local dummy = function() end

----------------------

local settings
local defaults = {
	profile = {
		["bagbar"] = nil,
		["gryphons"] = nil,
		["hotkey"] = nil,
		["macro"] = nil,
		["mainmenubar"] = nil,
		["microbar"] = nil,
		["stancebar"] = nil,
		["status"] = nil,
		["vehicleleave"] = nil,
		["vehiclemenubar"] = nil,
		-- alerts
		["azerite"] = nil,
		["collection"] = nil,
		["talent"] = nil,
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
debug_out("ActionBar getOptions")
return {
	type = "group",
	name = L["ActionBar"],
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
			name = format("|cffFFFF55%s|r",L["Enable Action Bar"]),
			desc = format("|cffFFFF55%s|r", L["Hides frames connected to the main action bar."]),
			descStyle = "inline",
			type = "toggle",
			order = 1,
			width = "full",
			get = function() return HideBlizzard:GetModuleEnabled("ActionBar") end,
			set = function(info, value) HideBlizzard:SetModuleEnabled("ActionBar", value) end,
		},
		spacer = {
			name = "",
			type = "description",
			order = 1.5,
		},
		bagbar = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Bag Bar"],
			desc = L["Hides the bag bar frame."],
			type = "toggle",
			order = 2,
			set = function(info, v)
				settings.bagbar = v
				mod:UpdateBagBar()
			end,
		},
		gryphons = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Gryphons"],
			desc = L["Hides the art (gryphons) at each ends of the action bar."],
			type = "toggle",
			order = 3,
			set = function(info, v)
				settings.gryphons = v
				mod:UpdateGryphons()
			end,
		},
		hotkey = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Hotkey"],
			desc = L["Hides the hotkey text on the action bar buttons."],
			type = "toggle",
			order = 4,
			set = function(info, v)
				settings.hotkey = v
				mod:UpdateHotkey()
			end,
		},
		macro = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Macro"],
			desc = L["Hides the macro text on the action bar buttons."],
			type = "toggle",
			order = 5,
			set = function(info, v)
				settings.macro = v
				mod:UpdateMacro()
			end,
		},
		mainmenubar = {
			disabled = function() return not ActionBar:IsEnabled() end,
			name = L["Main Menu Bar"],
			desc = format("%s\n|cffFF0000%s|r", L["Hides the action bar frame."], L["Note: Most options will be disabled."]),
			type = "toggle",
			order = 6,
			set = function(info, v)
				settings.mainmenubar = v
				mod:UpdateMainMenuBar()
			end,
		},
		microbar = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Micro Bar"],
			desc = L["Hides the micro bar buttons located at the bottom-right of the screen."],
			type = "toggle",
			order = 7,
			set = function(info, v)
				settings.microbar = v
				mod:UpdateMicroBar()
			end,
		},
		stancebar = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Stance Bar"],
			desc = L["Hides the stance / shapeshift bar."],
			type = "toggle",
			order = 8,
			set = function(info, v)
				settings.stancebar = v
				mod:UpdateStanceBar()
			end,
		},
		status = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Status Tracking Bar"],
			desc = L["Hides all status tracking bars (artifact/faction/honor/level)."],
			type = "toggle",
			order = 9,
			set = function(info, v)
				settings.status = v
				mod:UpdateStatus()
			end,
		},
		vehicleleave = {
			disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
			name = L["Vehicle Leave"],
			desc = L["Hides the vehicle leave button above the action bar."],
			type = "toggle",
			order = 10,
			set = function(info, v)
				settings.vehicleleave = v
				mod:UpdateVehicleLeave()
			end,
		},
		vehiclemenubar = {
			disabled = function() return not ActionBar:IsEnabled() end,
			name = L["Vehicle Menu Bar"],
			desc = L["Hides the vehicle action bar."],
			type = "toggle",
			order = 11,
			set = function(info, v)
				settings.vehiclemenubar = v
				mod:UpdateVehicleMenuBar()
			end,
		},
		alerts = {
			name = L["Alert Frames"],
			order = 12,
			type = "group",
			inline = true,
			args = {
				azerite = {
					disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
					name = L["Azerite Alert"],
					desc = L["Hides the azerite alert window."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.azerite = v
						mod:UpdateAzerite()
					end,
				},
				collection = {
					disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
					name = L["Collection Alert"],
					desc = L["Hides the collection alert window."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.collection = v
						mod:UpdateCollection()
					end,
				},
				talent = {
					disabled = function() return (not ActionBar:IsEnabled() or settings.mainmenubar) end,
					name = L["Talent Alert"],
					desc = L["Hides the talent alert window."],
					type = "toggle",
					order = 3,
					set = function(info, v)
						settings.talent = v
						mod:UpdateTalent()
					end,
				},
			},
		},
	},
}
end

----------------------

function mod:OnInitialize()
	debug_out("ActionBar OnInitialize")

	mod:SetEnabledState(HideBlizzard:GetModuleEnabled("ActionBar"))

	mod.db = HideBlizzard.db:RegisterNamespace("ActionBar", defaults)
	settings = mod.db.profile

	local options = mod:getOptions()
	HideBlizzard:RegisterModuleOptions("ActionBar", options, "ActionBar")
end

----------------------

function mod:OnEnable()
	debug_out("ActionBar OnEnable")

	mod:UpdateView()
end

----------------------

function mod:OnDisable()
	debug_out("ActionBar OnDisable")

	mod:UpdateView()
end

----------------------

function mod:UpdateView()
	debug_out("ActionBar UpdateView")

	mod:UpdateBagBar()
	mod:UpdateGryphons()
	mod:UpdateHotkey()
	mod:UpdateMacro()
	mod:UpdateMainMenuBar()
	mod:UpdateMicroBar()
	mod:UpdateStatus()
	mod:UpdateStanceBar()
	mod:UpdateVehicleLeave()
	mod:UpdateVehicleMenuBar()

	mod:UpdateAzerite()
	mod:UpdateCollection()
	mod:UpdateTalent()
end

----------------------

function mod:UpdateAzerite()
	if (settings.azerite == nil) then return end
	debug_out("UpdateAzerite")

	local CharacterMicroButtonAlert = _G.CharacterMicroButtonAlert
	if (settings.azerite and mod:IsEnabled()) then
		if (CharacterMicroButtonAlert) then
			CharacterMicroButtonAlert:Hide()
			CharacterMicroButtonAlert.Show = dummy
		end
	else
		CharacterMicroButtonAlert.Show = nil

		settings.azerite = nil
	end
end

----------------------

function mod:UpdateBagBar()
	if (settings.bagbar == nil) then return end
	debug_out("UpdateBagBar")

	local MicroButtonAndBagsBar = _G.MicroButtonAndBagsBar
	if (settings.bagbar and mod:IsEnabled()) then
		MicroButtonAndBagsBar:Hide()
	else
		MicroButtonAndBagsBar:Show()

		settings.bagbar = nil
	end
end

----------------------

function mod:UpdateCollection()
	if (settings.collection == nil) then return end
	debug_out("UpdateCollection")

	local CollectionsMicroButtonAlert = _G.CollectionsMicroButtonAlert
	if (settings.collection and mod:IsEnabled()) then
		CollectionsMicroButtonAlert:Hide()
		CollectionsMicroButtonAlert.Show = dummy
	else
		CollectionsMicroButtonAlert.Show = nil

		settings.collection = nil
	end
end

----------------------

function mod:UpdateGryphons()
	if (settings.gryphons == nil) then return end
	debug_out("UpdateGryphons")

	if (settings.gryphons and mod:IsEnabled()) then
		MainMenuBarArtFrame.LeftEndCap:Hide()
		MainMenuBarArtFrame.RightEndCap:Hide()
	else
		MainMenuBarArtFrame.LeftEndCap:Show()
		MainMenuBarArtFrame.RightEndCap:Show()

		settings.gryphons = nil
	end
end

----------------------

function mod:UpdateHotkey()
	if (settings.hotkey == nil) then return end
	debug_out("UpdateHotkey")
	
	if (settings.hotkey and mod:IsEnabled()) then
		for i=1, NUM_ACTIONBAR_BUTTONS do
			local hkab = _G["ActionButton"..i.."HotKey"]
			hkab:Hide()

			local hkmbl = _G["MultiBarBottomLeftButton"..i.."HotKey"]
			hkmbl:Hide()

			local hkmbr = _G["MultiBarBottomRightButton"..i.."HotKey"]
			hkmbr:Hide()

			local hkmbll = _G["MultiBarLeftButton"..i.."HotKey"]
			hkmbll:Hide()

			local hkmbrr = _G["MultiBarRightButton"..i.."HotKey"]
			hkmbrr:Hide()
		end
	else
		for i=1, NUM_ACTIONBAR_BUTTONS do
			local hkab = _G["ActionButton"..i.."HotKey"]
			hkab:Show()

			local hkmbl = _G["MultiBarBottomLeftButton"..i.."HotKey"]
			hkmbl:Show()

			local hkmbr = _G["MultiBarBottomRightButton"..i.."HotKey"]
			hkmbr:Show()

			local hkmbll = _G["MultiBarLeftButton"..i.."HotKey"]
			hkmbll:Show()

			local hkmbrr = _G["MultiBarRightButton"..i.."HotKey"]
			hkmbrr:Show()
		end
		settings.hotkey = nil
	end
end

----------------------

function mod:UpdateMacro()
	if (settings.macro == nil) then return end
	debug_out("UpdateMacro")

	if (settings.macro and mod:IsEnabled()) then
		for i=1, NUM_ACTIONBAR_BUTTONS do
			local mab = _G["ActionButton"..i.."Name"]
			mab:Hide()

			local mmbl = _G["MultiBarBottomLeftButton"..i.."Name"]
			mmbl:Hide()

			local mmbr = _G["MultiBarBottomRightButton"..i.."Name"]
			mmbr:Hide()

			local mmbll = _G["MultiBarLeftButton"..i.."Name"]
			mmbll:Hide()

			local mmbrr = _G["MultiBarRightButton"..i.."Name"]
			mmbrr:Hide()
		end

	else
		for i=1, NUM_ACTIONBAR_BUTTONS do
			local mab = _G["ActionButton"..i.."Name"]
			mab:Show()

			local mmbl = _G["MultiBarBottomLeftButton"..i.."Name"]
			mmbl:Show()

			local mmbr = _G["MultiBarBottomRightButton"..i.."Name"]
			mmbr:Show()

			local mmbll = _G["MultiBarLeftButton"..i.."Name"]
			mmbll:Show()

			local mmbrr = _G["MultiBarRightButton"..i.."Name"]
			mmbrr:Show()
		end
		settings.macro = nil
	end
end

----------------------

function mod:UpdateMainMenuBar()
	if ( settings.mainmenubar == nil ) then return end
	debug_out("UpdateMainMenuBar")

	local MainMenuBar = _G.MainMenuBar
	if (settings.mainmenubar and mod:IsEnabled()) then
		MainMenuBar:Hide()
		MainMenuBar.Show = dummy
	else
		if (not UnitHasVehicleUI("player")) then
			MainMenuBar.Show = nil
			MainMenuBar:Show()
		end
		settings.mainmenubar = nil
	end
end

----------------------

function mod:UpdateMicroBar()
	if ( settings.microbar == nil ) then return end
	debug_out("UpdateMicroBar")

	if (settings.microbar and mod:IsEnabled()) then
		for _, button in next, {
			"CharacterMicroButton",
			"SpellbookMicroButton",
			"TalentMicroButton",
			"AchievementMicroButton",
			"QuestLogMicroButton",
			"GuildMicroButton",
			"LFDMicroButton",
			"EJMicroButton",
			"CollectionsMicroButton",
			"MainMenuMicroButton",
			"HelpMicroButton",
			"StoreMicroButton",
		} do
			if (_G[button]) then
				_G[button]:Hide()
				_G[button].Show = dummy
			end
		end
	else
		for _, button in next, {
			"CharacterMicroButton",
			"SpellbookMicroButton",
			"TalentMicroButton",
			"AchievementMicroButton",
			"QuestLogMicroButton",
			"GuildMicroButton",
			"LFDMicroButton",
			"EJMicroButton",
			"CollectionsMicroButton",
			"MainMenuMicroButton",
			"HelpMicroButton",
			"StoreMicroButton",
		} do
			if ( _G[button] ) then
				_G[button].Show = nil
				_G[button]:Show()
			end
		end
		settings.microbar = nil
	end
end

----------------------

function mod:UpdateStanceBar()
	if (settings.stancebar == nil) then return end
	debug_out("UpdateStanceBar")

	local StanceBarFrame = _G.StanceBarFrame
	if (settings.stancebar and mod:IsEnabled()) then
		if (GetNumShapeshiftForms() ~= 0) then
			StanceBarFrame:Hide()
			StanceBarFrame.Show = dummy
		end
	else
		if (GetNumShapeshiftForms() ~= 0) then
			StanceBarFrame.Show = nil
			StanceBar_Update()
		end
		settings.stancebar = nil
	end
end

----------------------

function mod:UpdateStatus()
	if ( settings.status == nil ) then return end
	debug_out("UpdateStatus")

	local StatusTrackingBarManager = _G.StatusTrackingBarManager
	if (settings.status and mod:IsEnabled()) then
		if (StatusTrackingBarManager) then
			StatusTrackingBarManager:Hide()
			StatusTrackingBarManager.Show = function() end
		end
	else
		StatusTrackingBarManager.Show = nil
		if (StatusTrackingBarManager) then
			StatusTrackingBarManager:Show()
		end
		settings.status = nil
	end
end

----------------------

function mod:UpdateTalent()
	if ( settings.talent == nil ) then return end
	debug_out("UpdateTalent")

	local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
	if (settings.talent and mod:IsEnabled()) then
		if (TalentMicroButtonAlert) then
			TalentMicroButtonAlert:Hide()
			TalentMicroButtonAlert.Show = dummy
		end
	else
		TalentMicroButtonAlert.Show = nil

		settings.talent = nil
	end
end

----------------------

function mod:UpdateVehicleLeave()
	if (settings.vehicleleave == nil) then return end
	debug_out("UpdateVehicleLeave")

	local MainMenuBarVehicleLeaveButton = _G.MainMenuBarVehicleLeaveButton
	if (settings.vehicleleave and mod:IsEnabled()) then
		if (CanExitVehicle()) then
			MainMenuBarVehicleLeaveButton:Hide()
			MainMenuBarVehicleLeaveButton.Show = dummy
		end
	else
		if (CanExitVehicle()) then
			MainMenuBarVehicleLeaveButton.Show = nil
			MainMenuBarVehicleLeaveButton:Show()
		end
		settings.vehicleleave = nil
	end
end

----------------------

function mod:UpdateVehicleMenuBar()
	if (settings.vehiclemenubar == nil) then return end
	debug_out("UpdateVehicleMenuBar")

	local OverrideActionBar = _G.OverrideActionBar
	if (settings.vehiclemenubar and mod:IsEnabled()) then
		if (UnitInVehicle("player") and UnitHasVehicleUI("player")) then
			OverrideActionBar:Hide()
			OverrideActionBar.Show = dummy
		end
	else
		if (UnitInVehicle("player") and UnitHasVehicleUI("player")) then
			OverrideActionBar.Show = nil
			OverrideActionBar:Show()
		end
		settings.vehiclemenubar = nil
	end
end
