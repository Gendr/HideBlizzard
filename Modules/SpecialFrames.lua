--[[	Special Frames	]]--

local format = string.format
local pairs = pairs
local select = select
local tonumber = tonumber
local tostring = tostring

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetAddOnInfo = GetAddOnInfo
local GetCVar = GetCVar
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local IsAddOnLoaded = IsAddOnLoaded
local IsInInstance = IsInInstance
local LoadAddOn = LoadAddOn
local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES
local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS
local UnitInPhase = UnitInPhase
local UnitIsWarModePhased = UnitIsWarModePhased
local UnitExists = UnitExists

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local SpecialFrames = HideBlizzard:NewModule("SpecialFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local mod = SpecialFrames
local mod_debug = false
local mod_prefix = "|cffAEAEE0"..tostring(mod)..":|r"

local dummy = function() end

local settings
local defaults = {
	profile = {
		["armoredman"] = nil,
		["aura"] = nil,
		["capturebar"] = nil,
		["islandexpedition"] = nil,
		["minimap"] = nil,
		["mirrorbar"] = nil,
		["talkinghead"] = nil,
		["vehicleseat"] = nil,
		-- alerts
		["allalerts"] = nil,
		["boss"] = nil,
		["garrison"] = nil,
		["levelup"] = nil,
		-- messages
		["errormessage"] = nil,
		["infomessage"] = nil,
		["sysmessage"] = nil,
		["zonetext"] = nil,
		["subzonetext"] = nil,
		-- party/raid
		["bossframe"] = nil,
		["compactraid"] = nil,
		["party"] = nil,
		["phaseicon"] = nil,
		--tooltips
		["gametooltip"] = nil,
		["shoppingtooltip"] = nil,
	},
}

local function debug_out(...)
	if (mod_debug) then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", mod_prefix, ...), 1, 0, 0)
	end
end

function mod:getOptions()
debug_out("SpecialFrames getOptions")
return {
	name = L["SpecialFrames"],
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
			name = format("|cffFFFF55%s|r", L["Enable Special Frames"]),
			desc = format("|cffFFFF55%s|r", L["Hides various UI frames."]),
			descStyle = "inline",
			type = "toggle",
			order = 1,
			width = "full",
			get = function() return HideBlizzard:GetModuleEnabled("SpecialFrames") end,
			set = function(info, value) HideBlizzard:SetModuleEnabled("SpecialFrames", value) end,
		},
		spacer = {
			name = "",
			type = "description",
			order = 1.5,
		},
		armoredman = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Armored Man"],
			desc = L["Hides the armored man (durability) under the minimap."],
			type = "toggle",
			order = 2,
			set = function(info, v)
				settings.armoredman = v
				mod:UpdateArmoredMan()
			end,
		},
		aura = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Aura"],
			desc = L["Hides the buff / debuff frame."],
			type = "toggle",
			order = 3,
			set = function(info, v)
				settings.aura = v
				mod:UpdateAura()
			end,
		},
		capturebar = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Capture Bar"],
			desc = L["Hides the capture bar under the minimap."],
			type = "toggle",
			order = 4,
			set = function(info, v)
				settings.capturebar = v
				mod:UpdateCaptureBar()
			end,
		},
		islandexpedition = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Island Expedition"],
			desc = format("%s\n|cffFF0000%s|r", L["Hides the island expedition frame at top of the screen."], L["Note: This will hide other top screen UI frames."]),
			order = 5,
			type = "toggle",
			set = function(info, v)
				settings.islandexpedition = v
				mod:UpdateIslandExpedition()
			end,
		},
		minimap = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Minimap"],
			desc = L["Hides the minimap."],
			order = 6,
			type = "toggle",
			set = function(info, v)
				settings.minimap = v
				mod:UpdateMinimap()
			end,
		},
		mirrorbar = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Mirror Bar"],
			desc = L["Hides the mirror (breath/fatigue) bar at top of screen."],
			order = 7,
			type = "toggle",
			set = function(info, v)
				settings.mirrorbar = v
				mod:UpdateMirrorBar()
			end,
		},
		talkinghead = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Talking Head"],
			desc = L["Hides the talking head frame."],
			order = 8,
			type = "toggle",
			set = function(info, v)
				settings.talkinghead = v
				mod:UpdateTalkingHead()
			end,
		},
		vehicleseat = {
			disabled = function() return not SpecialFrames:IsEnabled() end,
			name = L["Vehicle Seat Indicator"],
			desc = L["Hides the vehicle seat indicator frame under the minimap."],
			order = 9,
			type = "toggle",
			set = function(info, v)
				settings.vehicleseat = v
				mod:UpdateVehicleSeatIndicator()
			end,
		},
		alerts = {
			name = L["Alert Frames"],
			order = 10,
			type = "group",
			inline = true,
			args = {
				allalerts = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["All Alerts"],
					desc = L["Hides all alert windows."],
					order = 1,
					type = "toggle",
					set = function(info, v)
						settings.allalerts = v
						mod:UpdateAllAlerts()
					end,
				},
				boss = {
					disabled = function() return (not SpecialFrames:IsEnabled() or settings.allalerts) end,
					name = L["Boss Alert"],
					desc = L["Hides the boss alert window."],
					order = 2,
					type = "toggle",
					set = function(info, v)
						settings.boss = v
						mod:UpdateBoss()
					end,
				},
				garrison = {
					disabled = function() return (not SpecialFrames:IsEnabled() or settings.allalerts) end,
					name = L["Garrison Alert"],
					desc = L["Hides the garrison alert window."],
					order = 3,
					type = "toggle",
					set = function(info, v)
						settings.garrison = v
						mod:UpdateGarrison()
					end,
				},
				levelup = {
					disabled = function() return (not SpecialFrames:IsEnabled() or settings.allalerts) end,
					name = L["Level Up Alert"],
					desc = L["Hides the level up alert window."],
					order = 4,
					type = "toggle",
					set = function(info, v)
						settings.levelup = v
						mod:UpdateLevelUp()
					end,
				},
			},
		},
		messages = {
			name = L["Messages"],
			order = 11,
			type = "group",
			inline = true,
			args = {
				sysmessage = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["System Message"],
					desc = format("|cffFF0000%s|r", L["Hides all the system message text at top of the screen."]),
					order = 1,
					type = "toggle",
					set = function(info, v)
						settings.sysmessage = v
						mod:UpdateSystemMessage()
					end,
				},
				infomessage = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Info Message"],
					desc = format("|cffFF0000%s|r", L["Hides all the notification text at top of the screen."]),
					order = 2,
					type = "toggle",
					set = function(info, v)
						settings.infomessage = v
						mod:UpdateInfoMessage()
					end,
				},
				errormessage = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Error Message"],
					desc = format("|cffFF0000%s|r", L["Hides all the error text at top of the screen."]),
					order = 3,
					type = "toggle",
					set = function(info, v)
						settings.errormessage = v
						mod:UpdateErrorMessage()
					end,
				},
				subzonetext = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Subzone Text"],
					desc = L["Hides the subzone text in middle of the screen."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.subzonetext = v
						mod:UpdateSubZoneText()
					end,
				},
				zonetext = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Zone Text"],
					desc = L["Hides the zone text in middle of the screen."],
					type = "toggle",
					order = 5,
					set = function(info, v)
						settings.zonetext = v
						mod:UpdateZoneText()
					end,
				},
			},
		},
		partyopt = {
			name = L["Party/Raid"],
			order = 12,
			type = "group",
			inline = true,
			args = {
				bossframe = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Boss Frame"],
					desc = L["Hides the boss frames under the minimap."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.bossframe = v
						mod:UpdateBossFrame()
					end,
				},
				compactraid = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Compact Raid Frame"],
					desc = L["Hides the compact raid frame box on left side of screen."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.compactraid = v
						mod:UpdateCompactRaid()
					end,
				},
				party = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Party Frame"],
					desc = L["Hides the party frame."],
					type = "toggle",
					order = 3,
					set = function(info, v)
						settings.party = v
						mod:UpdateParty()
					end,
				},
				phaseicon = {
					disabled = function() return not SpecialFrames:IsEnabled() or settings.party end,
					name = L["Phasing Icon"],
					desc = L["Hides the phasing icon when in a party."],
					type = "toggle",
					order = 4,
					set = function(info, v)
						settings.phaseicon = v
						mod:UpdatePhaseIcon()
					end,
				},
			},
		},
		tooltips = {
			name = L["Tooltips"],
			order = 13,
			type = "group",
			inline = true,
			args = {
				gametooltip = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Game Tooltip"],
					desc = L["Hides the game tooltip frame."],
					type = "toggle",
					order = 1,
					set = function(info, v)
						settings.gametooltip = v
						mod:UpdateGameTooltip()
					end,
				},
				shoppingtooltip = {
					disabled = function() return not SpecialFrames:IsEnabled() end,
					name = L["Shopping Tooltips"],
					desc = L["Hides both the shopping tooltip frames."],
					type = "toggle",
					order = 2,
					set = function(info, v)
						settings.shoppingtooltip = v
						mod:UpdateShoppingTooltip()
					end,
				},
			},
		},
	},
}
end

function mod:OnInitialize()
	debug_out("SpecialFrames OnInitialize")

	mod:SetEnabledState(HideBlizzard:GetModuleEnabled("SpecialFrames"))

	mod.db = HideBlizzard.db:RegisterNamespace("SpecialFrames", defaults)
	settings = mod.db.profile

	local options = mod:getOptions()
	HideBlizzard:RegisterModuleOptions("SpecialFrames", options, "SpecialFrames")
end

function mod:OnEnable()
	debug_out("SpecialFrames OnEnable")

	mod:UpdateView()
end

function mod:OnDisable()
	debug_out("SpecialFrames OnDisable")

	mod:UpdateView()
end

function mod:UpdateView()
	debug_out("SpecialFrames UpdateView")

	mod:UpdateArmoredMan()
	mod:UpdateAura()
	mod:UpdateCaptureBar()
	mod:UpdateIslandExpedition()
	mod:UpdateMinimap()
	mod:UpdateMirrorBar()
	mod:UpdateTalkingHead()
	mod:UpdateVehicleSeatIndicator()

	mod:UpdateAllAlerts()
	mod:UpdateBoss()
	mod:UpdateGarrison()
	mod:UpdateLevelUp()

	mod:UpdateSystemMessage()
	mod:UpdateInfoMessage()
	mod:UpdateErrorMessage()
	mod:UpdateSubZoneText()
	mod:UpdateZoneText()

	mod:UpdateBossFrame()
	mod:UpdateCompactRaid()
	mod:UpdateParty()
	mod:UpdatePhaseIcon()

	mod:UpdateGameTooltip()
	mod:UpdateShoppingTooltip()
end

function mod:UpdateAllAlerts()
	if (settings.allalerts == nil) then return end
	debug_out("UpdateAllAlerts")

	local AlertFrame = _G.AlertFrame
	if (settings.allalerts and mod:IsEnabled()) then
		hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
			AlertFrame:UnregisterEvent(event)
		end)
		AlertFrame:UnregisterAllEvents()
	else
		hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
			AlertFrame:RegisterEvent(event)
		end)
		AlertFrame:RegisterAllEvents()

		settings.allalerts = nil
	end
end

function mod:UpdateArmoredMan()
	if (settings.armoredman == nil) then return end
	debug_out("UpdateArmoredMan")

	local DurabilityFrame = _G.DurabilityFrame
	if (settings.armoredman and mod:IsEnabled()) then
		if (DurabilityFrame) then
			DurabilityFrame:Hide()
			DurabilityFrame.Show = dummy
		else
			DurabilityFrame.Show = dummy
		end
	else
		DurabilityFrame.Show = nil
		for i=1,18 do
			local isBroken = GetInventoryItemBroken("player", i)
			if (GetInventoryItemBroken("player", i)) then
				DurabilityFrame:Show()
			end
		end
		settings.armoredman = nil
	end

end

function mod:UpdateAura()
	if (settings.aura == nil) then return end
	debug_out("UpdateAura")

	local BuffFrame = _G.BuffFrame
	local TemporaryEnchantFrame = _G.TemporaryEnchantFrame
	if (settings.aura and mod:IsEnabled()) then
		BuffFrame:Hide()
		BuffFrame.Show = dummy

		TemporaryEnchantFrame:Hide()
		TemporaryEnchantFrame.Show = dummy
	else
		BuffFrame.Show = nil
		BuffFrame:Show()

		TemporaryEnchantFrame.Show = nil
		TemporaryEnchantFrame:Show()

		settings.aura = nil
	end
end

function mod:UpdateBoss()
	if (settings.boss == nil) then return end
	debug_out("UpdateBoss")

	if (settings.boss and mod:IsEnabled()) then
		BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
		BossBanner:UnregisterEvent("BOSS_KILL")
	else
		BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
		BossBanner:RegisterEvent("BOSS_KILL")

		settings.boss = nil
	end
end

function mod:UpdateBossFrame()
	if (settings.bossframe == nil) then return end
	debug_out("UpdateBossFrame")

	if (settings.bossframe and mod:IsEnabled()) then
		for i=1, MAX_BOSS_FRAMES do
			local bf = _G["Boss"..i.."TargetFrame"]
			if (UnitExists("boss"..i)) then
				bf:Hide()
				bf.Show = dummy
			else
				bf.Show = dummy
			end
		end
	else
		for i=1, MAX_BOSS_FRAMES do
			local bf = _G["Boss"..i.."TargetFrame"]
			bf.Show = nil
			if (UnitExists("boss"..i)) then
				bf:Show()
			end
		end
		settings.bossframe = nil
	end
end

function mod:UpdateCaptureBar()
	if (settings.capturebar == nil) then return end
	debug_out("UpdateCaptureBar")

	local UIWidgetBelowMinimapContainerFrame = _G.UIWidgetBelowMinimapContainerFrame
	if (settings.capturebar and mod:IsEnabled()) then
		if (UIWidgetBelowMinimapContainerFrame) then
			UIWidgetBelowMinimapContainerFrame:Hide()
			UIWidgetBelowMinimapContainerFrame.Show = dummy
		end
	else
		UIWidgetBelowMinimapContainerFrame.Show = nil
		if (UIWidgetBelowMinimapContainerFrame) then
			UIWidgetBelowMinimapContainerFrame:Show()
		end
		settings.capturebar = nil
	end
end

function mod:UpdateCompactRaid()
	if (settings.compactraid == nil) then return end
	debug_out("UpdateCompactRaid")

	if not CompactRaidFrameManager then return end

	local CompactRaidFrame = _G.CompactRaidFrame
	local CompactRaidFrameManager = _G.CompactRaidFrameManager
	local CompactRaidFrameContainer = _G.CompactRaidFrameContainer
	if (settings.compactraid and mod:IsEnabled()) then
		if (GetNumGroupMembers() > 0) then
			CompactRaidFrameManager:Hide()
			CompactRaidFrameManager.Show = dummy
			CompactRaidFrameContainer:SetParent(UIParent)
		else
			CompactRaidFrameManager:Hide()
			CompactRaidFrameManager.Show = dummy
			CompactRaidFrameContainer:SetParent(UIParent)
		end
	else
		if (GetNumGroupMembers() > 0) then
			CompactRaidFrameManager.Show = nil
			CompactRaidFrameManager:Show()
			CompactRaidFrameContainer:SetParent(CompactRaidFrame)
		end
		settings.compactraid = nil
	end
end

function mod:UpdateGarrison()
	if (settings.garrison == nil) then return end
	debug_out("UpdateGarrison")

	if (settings.garrison and mod:IsEnabled()) then
		AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
	else
		AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")

		settings.garrison = nil
	end
end

function mod:UpdateGameTooltip()
	if (settings.gametooltip == nil) then return end
	debug_out("UpdateGameTooltip")

	local GameTooltip = _G.GameTooltip
	if (settings.gametooltip and mod:IsEnabled()) then
		GameTooltip:SetScript("OnShow", GameTooltip.Hide)
	else
		GameTooltip:SetScript("OnShow", GameTooltip.Show)

		settings.gametooltip = nil
	end
end

function mod:UpdateIslandExpedition()
	if (settings.islandexpedition == nil) then return end
	debug_out("UpdateIslandExpedition")

	local UIWidgetTopCenterContainerFrame = _G.UIWidgetTopCenterContainerFrame
	if (settings.islandexpedition and mod:IsEnabled()) then
		if (UIWidgetTopCenterContainerFrame) then
			UIWidgetTopCenterContainerFrame:Hide()
			UIWidgetTopCenterContainerFrame.Show = dummy
		end
	else
		UIWidgetTopCenterContainerFrame.Show = nil
		if (UIWidgetTopCenterContainerFrame) then
			UIWidgetTopCenterContainerFrame:Show()
		end
		settings.islandexpedition = nil
	end
end

function mod:UpdateLevelUp()
	if (settings.levelup == nil) then return end
	debug_out("UpdateLevelUp")

	if (settings.levelup and mod:IsEnabled()) then
		hooksecurefunc(LevelUpDisplay, "Show", LevelUpDisplay.Hide)
	else
		LevelUpDisplay.Show = nil
		hooksecurefunc(LevelUpDisplay, "Show", function()
			LevelUpDisplay:Show()
		end)
		settings.levelup = nil
	end
end

function mod:UpdateMinimap()
	if (settings.minimap == nil) then return end
	debug_out("UpdateMinimap")

	local MinimapCluster = _G.MinimapCluster
	if (settings.minimap and mod:IsEnabled()) then
		MinimapCluster:Hide()
		MinimapCluster.Show = dummy
		MinimapCluster:EnableMouse(false)
	else
		MinimapCluster.Show = nil
		MinimapCluster:Show()
		MinimapCluster:EnableMouse(true)

		settings.minimap = nil
	end
end

function mod:UpdateMirrorBar()
  if (settings.mirrorbar == nil) then return end

  local MIRRORTIMER_NUMTIMERS = MIRRORTIMER_NUMTIMERS

  if settings.mirrorbar and self:IsEnabled() then
    for i=1, MIRRORTIMER_NUMTIMERS, 1 do
	  local mt = _G["MirrorTimer"..i]
      local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
      if (timer ==  "UNKNOWN") then
        mt:Hide()
        mt.timer = nil
      else
        mt:Hide()
      end
    end
  else
    for i=1, MIRRORTIMER_NUMTIMERS, 1 do
	  local mt = _G["MirrorTimer"..i]
      local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
      if (timer ==  "UNKNOWN") then
        mt:Hide()
        mt.timer = nil
      else
        MirrorTimer_Show(timer, value, maxvalue, scale, paused, label)
      end
    end
    settings.mirrorbar = nil
  end
end

function mod:UpdateParty()
	if (settings.party == nil) then return end
	debug_out("UpdateParty")

	local isCompact = tonumber(GetCVar("useCompactPartyFrames"))
	if (settings.party and mod:IsEnabled()) then
		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i)) and (isCompact == 0) then
				local pf = _G["PartyMemberFrame"..i]
				pf:Hide()
				pf.Show = dummy
			else
				pf.Show = dummy
			end
		end
	else
		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i)) and (isCompact == 0) then
				local pf = _G["PartyMemberFrame"..i]
				pf.Show = nil
				if (UnitExists("party"..i)) then
					pf:Show()
				end
			end
		end
		settings.party = nil
	end
end

function mod:UpdatePhaseIcon()
	if (settings.phaseicon == nil) then return end
	debug_out("UpdatePhaseIcon")

	local isCompact = tonumber(GetCVar("useCompactPartyFrames"))
	if (settings.phaseicon and mod:IsEnabled()) then
		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i)) and (isCompact == 0) then
				if (UnitExists("party"..i)) then
					local icon = _G["PartyMemberFrame"..i.."NotPresentIcon"]
					if UnitInPhase("party"..i) or UnitIsWarModePhased("party"..i) then
						icon:Hide()
						icon.Show = dummy
					else
						icon.Show = dummy
					end
				end
			end
		end
	else
		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i)) and (isCompact == 0) then
				if (UnitExists("party"..i)) then
					local icon = _G["PartyMemberFrame"..i.."NotPresentIcon"]
					icon.Show = nil
					if UnitInPhase("party"..i) or UnitIsWarModePhased("party"..i) then
						if (not icon:IsVisible()) then
--							icon:Hide()
--						else
							icon:Show()
						end
					end
				end
			end
		end
		settings.phaseicon = nil
	end
end

function mod:UpdateTalkingHead()
	if (settings.talkinghead == nil) then return end
	debug_out("UpdateTalkingHead")

	local TalkingHeadFrame = _G.TalkingHeadFrame
	if (settings.talkinghead and mod:IsEnabled()) then
		local _, _, _, enabled, _, _, _ = GetAddOnInfo("Blizzard_TalkingHeadUI")
		if enabled then
			hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame_CloseImmediately()
			end)
		else
			LoadAddOn("Blizzard_TalkingHeadUI")
			hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame_CloseImmediately()
			end)
		end
	else
		settings.talkinghead = nil
	end
end

function mod:UpdateVehicleSeatIndicator()
	if (settings.vehicleseat == nil) then return end
	debug_out("UpdateVehicleSeatIndicator")

	local VehicleSeatIndicator = _G.VehicleSeatIndicator
	if (settings.vehicleseat) and (mod:IsEnabled()) then
		if (VehicleSeatIndicator) then
			VehicleSeatIndicator:Hide()
			VehicleSeatIndicator.Show = dummy
		end
	else
		VehicleSeatIndicator.Show = nil
		if (VehicleSeatIndicator) then
			VehicleSeatIndicator:Show()
		end
		settings.vehicleseat = nil
	end
end

function mod:UpdateShoppingTooltip()
	if (settings.shoppingtooltip == nil) then return end
	debug_out("UpdateShoppingTooltip")

	local ShoppingTooltip1 = _G.ShoppingTooltip1
	local ShoppingTooltip2 = _G.ShoppingTooltip2
	if (settings.shoppingtooltip) and (mod:IsEnabled()) then
		ShoppingTooltip1:SetScript("OnShow", ShoppingTooltip1.Hide)
		ShoppingTooltip2:SetScript("OnShow", ShoppingTooltip2.Hide)
	else
		ShoppingTooltip1:SetScript("OnShow", ShoppingTooltip1.Show)
		ShoppingTooltip2:SetScript("OnShow", ShoppingTooltip2.Show)

		settings.shoppingtooltip = nil
	end
end

function mod:UpdateSystemMessage()
	if (settings.sysmessage == nil) then return end
	debug_out("UpdateSystemMessage")

	local UIErrorsFrame = _G.UIErrorsFrame
	if (settings.sysmessage) and (mod:IsEnabled()) then
		UIErrorsFrame:UnregisterEvent("SYSMSG")
	else
		UIErrorsFrame:RegisterEvent("SYSMSG")

		settings.sysmessage = nil
	end
end

function mod:UpdateInfoMessage()
	if (settings.infomessage == nil) then return end
	debug_out("UpdateInfoMessage")

	local UIErrorsFrame = _G.UIErrorsFrame
	if (settings.infomessage) and (mod:IsEnabled()) then
		UIErrorsFrame:UnregisterEvent("UI_INFO_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_INFO_MESSAGE")

		settings.infomessage = nil
	end
end

function mod:UpdateErrorMessage()
	if (settings.errormessage == nil) then return end
	debug_out("UpdateErrorMessage")

	local UIErrorsFrame = _G.UIErrorsFrame
	if (settings.errormessage) and (mod:IsEnabled()) then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")

		settings.errormessage = nil
	end
end

function mod:UpdateSubZoneText()
	if (settings.subzonetext == nil) then return end
	debug_out("UpdateSubZoneText")

	local SubZoneTextFrame = _G.SubZoneTextFrame
	if (settings.subzonetext) and (mod:IsEnabled()) then
		SubZoneTextFrame:Hide()
		SubZoneTextFrame.Show = dummy
	else
		SubZoneTextFrame.Show = nil

		settings.subzonetext = nil
	end
end

function mod:UpdateZoneText()
	if (settings.zonetext == nil) then return end
	debug_out("UpdateZoneText")

	local ZoneTextFrame = _G.ZoneTextFrame
	if (settings.zonetext) and (mod:IsEnabled()) then
		ZoneTextFrame:Hide()
		ZoneTextFrame.Show = dummy
	else
		ZoneTextFrame.Show = nil

		settings.zonetext = nil
	end
end
