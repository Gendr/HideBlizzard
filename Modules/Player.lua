--[[	Player	]]--

local format = string.format
local select = select
local tostring = tostring

----------------------

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetShapeshiftForm = GetShapeshiftForm
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetTotemInfo = GetTotemInfo
local MAX_TOTEMS = MAX_TOTEMS
local SetCVar = SetCVar
local UnitClass = UnitClass
local UnitLevel = UnitLevel

----------------------

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Player = HideBlizzard:NewModule("Player")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local mod = Player
local mod_debug = false
local mod_prefix = "|cffAEAEE0"..tostring(mod)..":|r"

local _, class = UnitClass("player")
local dummy = function() end

----------------------

local settings
local defaults = {
	profile = {
		["arcanebar"] = nil,
		["chibar"] = nil,
		["combobar"] = nil,
		["insanitybar"] = nil,
		["powerbar"] = nil,
		["priestbar"] = nil,
		["runeframe"] = nil,
		["shardframe"] = nil,
		["staggerbar"] = nil,
		["totemframe"] = nil,
		-- unit frames
		["focusframe"] = nil,
		["playercastbar"] = nil,
		["playerpowerbar"] = nil,
		["playerunitframe"] = nil,
		["targetunitframe"] = nil,
	},
}

----------------------

local function debug_out(...)
	if (addon_debug) then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", addon_prefix, ...), 1, 0, 0)
	end
end

----------------------

function mod:getOptions()
debug_out("Player getOptions")
return {
	name = L["Player"],
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
			name = format("|cffFFFF55%s|r", L["Enable Player"]),
			desc = format("|cffFFFF55%s|r", L["Hides player related frames."]),
			descStyle = "inline",
			type = "toggle",
			order = 1,
			width = "full",
			get = function() return HideBlizzard:GetModuleEnabled("Player") end,
			set = function(info, value) HideBlizzard:SetModuleEnabled("Player", value) end,
		},
		spacer = {
			name = "",
			type = "description",
			order = 1.5,
		},
		arcanebar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "MAGE") end,
			name = L["Arcane Bar"],
			desc = format(L["Hides the %smage class%s arcane charges bar."], "|cff69CCF0", "|r"),
			type = "toggle",
			order = 2,
			set = function(info, v)
				settings.arcanebar = v
				mod:UpdateArcaneBar()
			end,
		},
		chibar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "MONK") end,
			name = L["Chi Bar"],
			desc = format(L["Hides the %smonk class%s chi bar."], "|cff00FF96", "|r"),
			type = "toggle",
			order = 3,
			set = function(info, v)
				settings.chibar = v
				mod:UpdateChiBar()
			end,
		},
		combobar = {
			disabled = function() return not Player:IsEnabled() end,
			name = L["Combo Bar"],
			desc = format(L["Hides the %sdruid%s / %srogue%s class combo bar."], "|cffFF7D0A", "|r", "|cffFFF569", "|r"),
			type = "toggle",
			order = 4,
			set = function(info, v)
				settings.combobar = v
				mod:UpdateComboBar()
			end,
		},
		insanitybar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "PRIEST") end,
			name = L["Insanity Bar"],
			desc = L["Hides the priest class insanity bar."],
			type = "toggle",
			order = 5,
			set = function(info, v)
				settings.insanitybar = v
				mod:UpdateInsanityBar()
			end,
		},
		powerbar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "PALADIN") end,
			name = L["Power Bar"],
			desc = format(L["Hides the %spaladin class%s power bar."], "|cffF58CBA", "|r"),
			type = "toggle",
			order = 6,
			set = function(info, v)
				settings.powerbar = v
				mod:UpdatePowerBar()
			end,
		},
		priestbar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "PRIEST") end,
			name = L["Priest Bar"],
			desc = L["Hides the priest class bar."],
			type = "toggle",
			order = 7,
			set = function(info, v)
				settings.priestbar = v
				mod:UpdatePriestBar()
			end,
		},
		runeframe = {
			disabled = function() return (not Player:IsEnabled() or class ~= "DEATHKNIGHT") end,
			name = L["Rune Frame"],
			desc = format(L["Hides the %sdeathknight class%s rune frame."], "|cffC41F3B", "|r"),
			type = "toggle",
			order = 8,
			set = function(info, v)
				settings.runeframe = v
				mod:UpdateRuneFrame()
			end,
		},
		shardframe = {
			disabled = function() return (not Player:IsEnabled() or class ~= "WARLOCK") end,
			name = L["Shard Frame"],
			desc = format(L["Hides the %swarlock class%s shard frame."], "|cff9482C9", "|r"),
			type = "toggle",
			order = 9,
			set = function(info, v)
				settings.shardframe = v
				mod:UpdateShardFrame()
			end,
		},
		staggerbar = {
			disabled = function() return (not Player:IsEnabled() or class ~= "MONK") end,
			name = L["Stagger Bar"],
			desc = format(L["Hides the %smonk class%s stagger bar."], "|cff00FF96", "|r"),
			type = "toggle",
			order = 10,
			set = function(info, v)
				settings.staggerbar = v
				mod:UpdateStaggerBar()
			end,
		},
		totemframe = {
			disabled = function() return not Player:IsEnabled() end,
			name = L["Totem Frame"],
			desc = L["Hides the totem frame."],
			type = "toggle",
			order = 11,
			set = function(info, v)
				settings.totemframe = v
				mod:UpdateTotemFrame()
			end,
		},
		units = {
			name = L["Unit Frames"],
			order = 12,
			type = "group",
			inline = true,
			args = {
				focusframe = {
					disabled = function() return not Player:IsEnabled() end,
					name = L["Focus Frame"],
					desc = L["Hides the focus frame."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.focusframe = v
						mod:UpdateFocusFrame()
					end,
				},
				playercastbar = {
					disabled = function() return not Player:IsEnabled() end,
					name = L["Player Cast Bar"],
					desc = L["Hides the player cast bar."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.playercastbar = v
						mod:UpdatePlayerCastBar()
					end,
				},
				playerpowerbar = {
					disabled = function() return not Player:IsEnabled() end,
					name = L["Player Power Bar"],
					desc = L["Hides the player power bar."],
					type = "toggle",
					order = 3,
					set = function(info, v)
						settings.playerpowerbar = v
						mod:UpdatePlayerPowerBar()
					end,
				},
				playerunitframe = {
					disabled = function() return not Player:IsEnabled() end,
					name = L["Player Unit Frame"],
					desc = L["Hides the player unit frame."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.playerunitframe = v
						mod:UpdatePlayerUnitFrame()
					end,
				},
				targetunitframe = {
					disabled = function() return not Player:IsEnabled() end,
					name = L["Target Unit Frame"],
					desc = L["Hides the target unit frame."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.targetunitframe = v
						mod:UpdateTargetUnitFrame()
					end,
				},
			},
		},
	},
}
end

----------------------

function mod:OnInitialize()
	debug_out("Player OnInitialize")

	mod:SetEnabledState(HideBlizzard:GetModuleEnabled("Player"))

	mod.db = HideBlizzard.db:RegisterNamespace("Player", defaults)
	settings = mod.db.profile

	local options = mod:getOptions()
	HideBlizzard:RegisterModuleOptions("Player", options, "Player")
end

----------------------

function mod:OnEnable()
	debug_out("Player OnEnable")

	mod:UpdateView()
end

----------------------

function mod:OnDisable()
	debug_out("Player OnDisable")

	mod:UpdateView()
end

----------------------

function mod:UpdateView()
	debug_out("ActionBar UpdateView")

	mod:UpdateArcaneBar()
	mod:UpdateChiBar()
	mod:UpdateComboBar()
	mod:UpdateInsanityBar()
	mod:UpdatePowerBar()
	mod:UpdatePriestBar()
	mod:UpdateRuneFrame()
	mod:UpdateShardFrame()
	mod:UpdateStaggerBar()
	mod:UpdateTotemFrame()

	mod:UpdateFocusFrame()
	mod:UpdatePlayerCastBar()
	mod:UpdatePlayerPowerBar()
	mod:UpdatePlayerUnitFrame()
	mod:UpdateTargetUnitFrame()
end

----------------------

function mod:UpdateArcaneBar()
	if (settings.arcanebar == nil) then return end
	if (not class == "MAGE") then return end
	debug_out("UpdateArcaneBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  
	local MageArcaneChargesFrame = _G.MageArcaneChargesFrame
	if (settings.arcanebar and mod:IsEnabled()) then
		MageArcaneChargesFrame:Hide()
		MageArcaneChargesFrame.Show = dummy
	else
		MageArcaneChargesFrame.Show = nil
		if (currentSpecName == "Arcane") then
			MageArcaneChargesFrame:Show()
		end

		settings.arcanebar = nil
	end
end

function mod:UpdateChiBar()
	if (settings.chibar == nil) then return end
	if (not class == "MONK") then return end
	debug_out("UpdateChiBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

	local MonkHarmonyBarFrame = _G.MonkHarmonyBarFrame
	if (settings.chibar and mod:IsEnabled()) then

		MonkHarmonyBarFrame:Hide()
		MonkHarmonyBarFrame.Show = dummy
	else
		MonkHarmonyBarFrame.Show = nil
		if (currentSpecName == "Windwalker") then
			MonkHarmonyBarFrame:Show()
		end

		settings.chibar = nil
	end
end

----------------------

function mod:UpdateComboBar()
	if (settings.combobar == nil) then return end

	if (not class == "DRUID") or (not class == "ROGUE") then return end
	debug_out("UpdateComboBar")

	local ComboPointPlayerFrame = _G.ComboPointPlayerFrame
	if (settings.combobar and mod:IsEnabled()) then
		if (class == "ROGUE") then
			ComboPointPlayerFrame:Hide()
			ComboPointPlayerFrame.Show = dummy
			SetCVar("comboPointLocation", 1)
		elseif ( class == "DRUID" ) then
			ComboPointPlayerFrame:Hide()
			ComboPointPlayerFrame.Show = dummy
		end
	else
		if (class == "ROGUE") then
			ComboPointPlayerFrame.Show = nil
			ComboPointPlayerFrame:Show()
			SetCVar("comboPointLocation", 2)
		elseif ( class == "DRUID" ) then
			ComboPointPlayerFrame.Show = nil
			ComboPointPlayerFrame:Show()
		end
		settings.combobar = nil
	end
end

----------------------

function mod:UpdateFocusFrame()
	if (settings.focusframe == nil) then return end
	debug_out("UpdateFocusFrame")

	local FocusFrame = _G.FocusFrame
	if (settings.focusframe and mod:IsEnabled()) then
		FocusFrame:Hide()
		FocusFrame.Show = dummy
	else
		FocusFrame.Show = nil
		if (UnitExists("focus")) then
			FocusFrame:Show()
		end
		settings.focusframe = nil
	end
end

----------------------

function mod:UpdateInsanityBar()
	if (settings.insanitybar == nil) then return end
	if (not class == "PRIEST") then return end
	debug_out("UpdateInsanityBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

	local InsanityBarFrame = _G.InsanityBarFrame
	if (settings.insanitybar and mod:IsEnabled()) then
		InsanityBarFrame:Hide()
		InsanityBarFrame.Show = dummy
	else
		InsanityBarFrame.Show = nil
		if (currentSpecName == "Shadow") then
			InsanityBarFrame:Show()
		end
		settings.insanitybar = nil
	end
end

function mod:UpdatePlayerCastBar()
	if (settings.playercastbar == nil) then return end
	debug_out("UpdatePlayerCastBar")

	local CastingBarFrame = _G.CastingBarFrame
	if (settings.playercastbar and mod:IsEnabled()) then
		CastingBarFrame:Hide()
		CastingBarFrame.Show = dummy
	else
		CastingBarFrame.Show = nil

		settings.playercastbar = nil
	end
end

----------------------

function mod:UpdatePlayerPowerBar()
	if (settings.playerpowerbar == nil) then return end
	debug_out("UpdatePlayerPowerBar")

	local PlayerPowerBarAlt = _G.PlayerPowerBarAlt
	if (settings.playerpowerbar and mod:IsEnabled()) then
		if (PlayerPowerBarAlt) then
			PlayerPowerBarAlt:Hide()
			PlayerPowerBarAlt.Show = dummy
		else
			PlayerPowerBarAlt.Show = dummy
		end
	else
		PlayerPowerBarAlt.Show = nil
		if (PlayerPowerBarAlt) then
			PlayerPowerBarAlt:Show()
		end
		settings.playerpowerbar = nil
	end
end

----------------------

function mod:UpdatePlayerUnitFrame()
	if (settings.playerunitframe == nil) then return end
	debug_out("UpdatePlayerUnitFrame")

	local PlayerFrame = _G.PlayerFrame
	if (settings.playerunitframe and mod:IsEnabled()) then
		PlayerFrame:Hide()
		PlayerFrame.Show = dummy
	else
		PlayerFrame.Show = nil
		PlayerFrame:Show()

		settings.playerunitframe = nil
	end
end

----------------------

function mod:UpdatePowerBar()
	if (settings.powerbar == nil) then return end
	if (not class == "PALADIN") then return end
	debug_out("UpdatePowerBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

	local PaladinPowerBarFrame = _G.PaladinPowerBarFrame
	if (settings.powerbar and mod:IsEnabled()) then
		PaladinPowerBarFrame:Hide()
		PaladinPowerBarFrame.Show = dummy
	else
		PaladinPowerBarFrame.Show = nil
		if (currentSpecName == "Retribution") then
			PaladinPowerBarFrame:Show()
		end
		settings.powerbar = nil
	end
end

----------------------

function mod:UpdatePriestBar()
	if (settings.priestbar == nil) then return end
	if (not class == "PRIEST" ) then return end
	debug_out("UpdatePriestBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

	local PriestBarFrame = _G.PriestBarFrame
	if (settings.priestbar and mod:IsEnabled()) then
		PriestBarFrame:Hide()
		PriestBarFrame.Show = dummy
	else
		if (currentSpecName == "Shadow") and (UnitLevel("player") > 10) then
			PriestBarFrame.Show = nil
			PriestBar_Update()
		end
		settings.priestbar = nil
	end
end

function mod:UpdateRuneFrame()
	if (settings.runeframe == nil) then return end
	if (not class == "DEATHKNIGHT") then return end
	debug_out("UpdateRuneFrame")

	local RuneFrame = _G.RuneFrame
	if (settings.runeframe and mod:IsEnabled()) then
		RuneFrame:Hide()
		RuneFrame.Show = dummy
	else
		RuneFrame.Show = nil
		RuneFrame:Show()

		settings.runeframe = nil
	end
end

----------------------

function mod:UpdateShardFrame()
	if (settings.shardframe == nil) then return end
	if (not class == "WARLOCK") then return end
	debug_out("UpdateShardFrame")

	local WarlockPowerFrame = _G.WarlockPowerFrame
	if (settings.shardframe and mod:IsEnabled()) then
		WarlockPowerFrame:Hide()
		WarlockPowerFrame.Show = dummy
	else
		WarlockPowerFrame.Show = nil
		WarlockPowerFrame:Show()

		settings.shardframe = nil
	end
end

----------------------

function mod:UpdateStaggerBar()
	if (settings.staggerbar == nil) then return end
	if (not class == "MONK") then return end
	debug_out("UpdateStaggerBar")

	local currentSpec = GetSpecialization()
	local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

	local MonkStaggerBar = _G.MonkStaggerBar
	if (settings.staggerbar and mod:IsEnabled()) then
		MonkStaggerBar:Hide()
		MonkStaggerBar.Show = dummy
	else
		MonkStaggerBar.Show = nil
		if (currentSpecName == "Brewmaster") then
			MonkStaggerBar:Show()
		end
		settings.staggerbar = nil
	end
end

----------------------

function mod:UpdateTargetUnitFrame()
	if (settings.targetunitframe == nil) then return end
	debug_out("UpdateTargetUnitFrame")

	local TargetFrame = _G.TargetFrame
	if (settings.targetunitframe and mod:IsEnabled()) then
		TargetFrame:Hide()
		TargetFrame.Show = dummy
	else
		TargetFrame.Show = nil
		if (UnitExists("target")) then
			TargetFrame:Show()
		end
		settings.targetunitframe = nil
	end
end

----------------------

function mod:UpdateTotemFrame()
	if (settings.totemframe == nil) then return end
	debug_out("UpdateTotemFrame")

	local TotemFrame = _G.TotemFrame
	if (settings.totemframe and mod:IsEnabled()) then
		for i=1, MAX_TOTEMS do
			local haveTotem = GetTotemInfo(i)
			if (haveTotem) then
				TotemFrame:Hide()
				TotemFrame.Show = dummy
			end
		end
	else
		for i=1, MAX_TOTEMS do
			local haveTotem = GetTotemInfo(i)
			if (haveTotem) then
				TotemFrame.Show = nil
				TotemFrame:Show()
			end
		end
		settings.totemframe = nil
	end
end
