local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local SpecialFrames = HideBlizzard:NewModule("SpecialFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local dummy = function() end

local db
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

function SpecialFrames:GetOptions()
return {
  type = "group",
  name = L["SpecialFrames"],
  get = function(info)
    local key = info[#info]
    local v = db[key]
    return v
  end,
  set = function(info, value)
    local key = info[#info]
    db[key] = value
  end,
  args = {
    enabled = {
      order = 1, type = "toggle", width = "full",
      name = format("|cffFFFF55%s|r", L["Enable Special Frames"]),
      desc = format("|cffFFFF55%s|r", L["Hides various UI frames"]), descStyle = "inline",
      get = function() return HideBlizzard:GetModuleEnabled("SpecialFrames") end,
      set = function(info, value) HideBlizzard:SetModuleEnabled("SpecialFrames", value) end,
    },
    spacer = {
      order = 1.5, type = "description",
      name = "",
    },
    armoredman = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 2, type = "toggle",
      name = L["Armored Man"], desc = L["Hides the armored man (durability) under the minimap"],
      set = function(info, v)
        db.armoredman = v
        self:UpdateArmoredMan()
      end,
    },
    aura = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 3, type = "toggle",
      name = L["Aura"], desc = L["Hides the buff / debuff frame"],
      set = function(info, v)
        db.aura = v
        self:UpdateAura()
      end,
    },
    capturebar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 4, type = "toggle",
      name = L["Capture Bar"], desc = L["Hides the capture bar under the minimap"],
      set = function(info, v)
        db.capturebar = v
        self:UpdateCaptureBar()
      end,
    },
    islandexpedition = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 5, type = "toggle",
      name = L["Island Expedition"], desc = format("%s\n|cffFF0000%s|r", L["Hides the island expedition frame at top of the screen"], L["Note: This will hide other top screen UI frames"]),
      set = function(info, v)
        db.islandexpedition = v
        self:UpdateIslandExpedition()
      end,
    },
    minimap = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 6, type = "toggle",
      name = L["Minimap"], desc = L["Hides the minimap"],
      set = function(info, v)
        db.minimap = v
        self:UpdateMinimap()
      end,
    },
    mirrorbar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 7, type = "toggle",
      name = L["Mirror Bar"], desc = L["Hides the mirror (breath/fatigue) bar at top of screen"],
      set = function(info, v)
        db.mirrorbar = v
        self:UpdateMirrorBar()
      end,
    },
    talkinghead = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 8, type = "toggle",
      name = L["Talking Head"], desc = L["Hides the talking head frame"],
      set = function(info, v)
        db.talkinghead = v
        self:UpdateTalkingHead()
      end,
    },
    vehicleseat = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 9, type = "toggle",
      name = L["Vehicle Seat Indicator"], desc = L["Hides the vehicle seat indicator frame under the minimap"],
      set = function(info, v)
        db.vehicleseat = v
        self:UpdateVehicleSeatIndicator()
      end,
    },
    alerts = {
      order = 10, type = "group", inline = true,
      name = L["Alert Frames"],
      args = {
        allalerts = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["All Alerts"], desc = L["Hides all alert windows"],
          set = function(info, v)
            db.allalerts = v
            self:UpdateAllAlerts()
          end,
        },
        boss = {
          disabled = function() return (not self:IsEnabled() or db.allalerts) end,
          order = 2, type = "toggle",
          name = L["Boss Alert"], desc = L["Hides the boss alert window"],
          set = function(info, v)
            db.boss = v
            self:UpdateBoss()
          end,
        },
        garrison = {
          disabled = function() return (not self:IsEnabled() or db.allalerts) end,
          order = 3, type = "toggle",
          name = L["Garrison Alert"], desc = L["Hides the garrison alert window"],
          set = function(info, v)
            db.garrison = v
            self:UpdateGarrison()
          end,
        },
        levelup = {
          disabled = function() return (not self:IsEnabled() or db.allalerts) end,
          order = 4, type = "toggle",
          name = L["Level Up Alert"], desc = L["Hides the level up alert window"],
          set = function(info, v)
            db.levelup = v
            self:UpdateLevelUp()
          end,
        },
      },
    },
    messages = {
      order = 11, type = "group", inline = true,
      name = L["Messages"],
      args = {
        sysmessage = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["System Message"], desc = format("|cffFF0000%s|r", L["Hides all the system message text at top of the screen"]),
          set = function(info, v)
            db.sysmessage = v
            self:UpdateSystemMessage()
          end,
        },
        infomessage = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Info Message"], desc = format("|cffFF0000%s|r", L["Hides all the notification text at top of the screen"]),
          set = function(info, v)
            db.infomessage = v
            self:UpdateInfoMessage()
          end,
        },
        errormessage = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["Error Message"], desc = format("|cffFF0000%s|r", L["Hides all the error text at top of the screen"]),
          set = function(info, v)
            db.errormessage = v
            self:UpdateErrorMessage()
          end,
        },
        subzonetext = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 4, type = "toggle",
          name = L["Subzone Text"], desc = L["Hides the subzone text in middle of the screen"],
          set = function(info, v)
            db.subzonetext = v
            self:UpdateSubZoneText()
          end,
        },
        zonetext = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 5, type = "toggle",
          name = L["Zone Text"], desc = L["Hides the zone text in middle of the screen"],
          set = function(info, v)
            db.zonetext = v
            self:UpdateZoneText()
          end,
        },
      },
    },
    partyopt = {
      order = 12, type = "group", inline = true,
      name = L["Party/Raid"],
      args = {
        bossframe = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Boss Frame"], desc = L["Hides the boss frames under the minimap"],
          set = function(info, v)
            db.bossframe = v
            self:UpdateBossFrame()
          end,
        },
        compactraid = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Compact Raid Frame"], desc = L["Hides the compact raid frame box on left side of screen"],
          set = function(info, v)
            db.compactraid = v
            self:UpdateCompactRaid()
          end,
        },
        party = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["Party Frame"], desc = L["Hides the party frame"],
          set = function(info, v)
            db.party = v
            self:UpdateParty()
          end,
        },
        phaseicon = {
          disabled = function() return (not self:IsEnabled() or db.party) end,
          order = 4, type = "toggle",
          name = L["Phasing Icon"], desc = L["Hides the phasing icon when in a party"],
          set = function(info, v)
            db.phaseicon = v
            self:UpdatePhaseIcon()
          end,
        },
      },
    },
    tooltips = {
      order = 13, type = "group", inline = true,
      name = L["Tooltips"],
      args = {
        gametooltip = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Game Tooltip"], desc = L["Hides the game tooltip frame"],
          set = function(info, v)
            db.gametooltip = v
            self:UpdateGameTooltip()
          end,
        },
        shoppingtooltip = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Shopping Tooltips"], desc = L["Hides both the shopping tooltip frames"],
          set = function(info, v)
            db.shoppingtooltip = v
            self:UpdateShoppingTooltip()
          end,
        },
      },
    },
  },
}
end

function SpecialFrames:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("SpecialFrames"))

  self.db = HideBlizzard.db:RegisterNamespace("SpecialFrames", defaults)
  db = self.db.profile

  local options = self:GetOptions()
  HideBlizzard:RegisterModuleOptions("SpecialFrames", options, "SpecialFrames")
end

function SpecialFrames:OnEnable()
  self:UpdateView()
end

function SpecialFrames:OnDisable()
  self:UpdateView()
end

function SpecialFrames:UpdateView()
  self:UpdateArmoredMan()
  self:UpdateAura()
  self:UpdateCaptureBar()
  self:UpdateIslandExpedition()
  self:UpdateMinimap()
  self:UpdateMirrorBar()
  self:UpdateTalkingHead()
  self:UpdateVehicleSeatIndicator()

  self:UpdateAllAlerts()
  self:UpdateBoss()
  self:UpdateGarrison()
  self:UpdateLevelUp()

  self:UpdateSystemMessage()
  self:UpdateInfoMessage()
  self:UpdateErrorMessage()
  self:UpdateSubZoneText()
  self:UpdateZoneText()

  self:UpdateBossFrame()
  self:UpdateCompactRaid()
  self:UpdateParty()
  self:UpdatePhaseIcon()

  self:UpdateGameTooltip()
  self:UpdateShoppingTooltip()
end

function SpecialFrames:UpdateAllAlerts()
  if (db.allalerts == nil) then return end

  local AlertFrame = _G.AlertFrame

  if db.allalerts and self:IsEnabled() then
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
      AlertFrame:UnregisterEvent(event)
    end)
    AlertFrame:UnregisterAllEvents()
  else
    hooksecurefunc(AlertFrame, "RegisterEvent", function(self, event)
      AlertFrame:RegisterEvent(event)
    end)
    AlertFrame:RegisterAllEvents()

    db.allalerts = nil
  end
end

function SpecialFrames:UpdateArmoredMan()
  if (db.armoredman == nil) then return end

  local GetInventoryItemBroken = GetInventoryItemBroken
  local DurabilityFrame = _G.DurabilityFrame

  if db.armoredman and self:IsEnabled() then
    if DurabilityFrame then
      DurabilityFrame:Hide()
      DurabilityFrame.Show = dummy
    else
      DurabilityFrame.Show = dummy
    end
  else
    DurabilityFrame.Show = nil
    for i=1,18 do
      local isBroken = GetInventoryItemBroken("player", i)
      if GetInventoryItemBroken("player", i) then
        DurabilityFrame:Show()
      end
    end
    db.armoredman = nil
  end

end

function SpecialFrames:UpdateAura()
  if (db.aura == nil) then return end

  local BuffFrame = _G.BuffFrame
  local TemporaryEnchantFrame = _G.TemporaryEnchantFrame

  if db.aura and self:IsEnabled() then
    BuffFrame:Hide()
    BuffFrame.Show = dummy

    TemporaryEnchantFrame:Hide()
    TemporaryEnchantFrame.Show = dummy
  else
    BuffFrame.Show = nil
    BuffFrame:Show()

    TemporaryEnchantFrame.Show = nil
    TemporaryEnchantFrame:Show()

    db.aura = nil
  end
end

function SpecialFrames:UpdateBoss()
  if (db.boss == nil) then return end

  if db.boss and self:IsEnabled() then
    BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
    BossBanner:UnregisterEvent("BOSS_KILL")
  else
    BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
    BossBanner:RegisterEvent("BOSS_KILL")

    db.boss = nil
  end
end

function SpecialFrames:UpdateBossFrame()
  if (db.bossframe == nil) then return end

  local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES
  local UnitExists = UnitExists

  if db.bossframe and self:IsEnabled() then
    for i=1, MAX_BOSS_FRAMES do
      if UnitExists("boss"..i) then
        local bf = _G["Boss"..i.."TargetFrame"]
        bf:Hide()
        bf.Show = dummy
      end
    end
  else
    for i=1, MAX_BOSS_FRAMES do
      if UnitExists("boss"..i) then
        local bf = _G["Boss"..i.."TargetFrame"]
        bf.Show = nil
        bf:Show()
      end
    end
    db.bossframe = nil
  end
end

function SpecialFrames:UpdateCaptureBar()
  if (db.capturebar == nil) then return end

  local UIWidgetBelowMinimapContainerFrame = _G.UIWidgetBelowMinimapContainerFrame

  if db.capturebar and self:IsEnabled() then
    if UIWidgetBelowMinimapContainerFrame then
      UIWidgetBelowMinimapContainerFrame:Hide()
      UIWidgetBelowMinimapContainerFrame.Show = dummy
    end
  else
    UIWidgetBelowMinimapContainerFrame.Show = nil
    if UIWidgetBelowMinimapContainerFrame then
      UIWidgetBelowMinimapContainerFrame:Show()
    end
    db.capturebar = nil
  end
end

function SpecialFrames:UpdateCompactRaid()
  if (db.compactraid == nil) then return end

  local GetNumGroupMembers = GetNumGroupMembers
  local CompactRaidFrame = _G.CompactRaidFrame
  local CompactRaidFrameManager = _G.CompactRaidFrameManager
  local CompactRaidFrameContainer = _G.CompactRaidFrameContainer

  if (not CompactRaidFrameManager) then return end

  if db.compactraid and self:IsEnabled() then
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
    db.compactraid = nil
  end
end

function SpecialFrames:UpdateGarrison()
  if (db.garrison == nil) then return end

  local AlertFrame = _G.AlertFrame

  if db.garrison and self:IsEnabled() then
    AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
  else
    AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")

    db.garrison = nil
  end
end

function SpecialFrames:UpdateGameTooltip()
  if (db.gametooltip == nil) then return end

  local GameTooltip = _G.GameTooltip

  if db.gametooltip and self:IsEnabled() then
    GameTooltip:SetScript("OnShow", GameTooltip.Hide)
  else
    GameTooltip:SetScript("OnShow", GameTooltip.Show)

    db.gametooltip = nil
  end
end

function SpecialFrames:UpdateIslandExpedition()
  if (db.islandexpedition == nil) then return end

  local UIWidgetTopCenterContainerFrame = _G.UIWidgetTopCenterContainerFrame

  if db.islandexpedition and self:IsEnabled() then
    if UIWidgetTopCenterContainerFrame then
      UIWidgetTopCenterContainerFrame:Hide()
      UIWidgetTopCenterContainerFrame.Show = dummy
    end
  else
    UIWidgetTopCenterContainerFrame.Show = nil
    if UIWidgetTopCenterContainerFrame then
      UIWidgetTopCenterContainerFrame:Show()
    end
    db.islandexpedition = nil
  end
end

function SpecialFrames:UpdateLevelUp()
  if (db.levelup == nil) then return end

  local LevelUpDisplay = _G.LevelUpDisplay

  if db.levelup and self:IsEnabled() then
    hooksecurefunc(LevelUpDisplay, "Show", LevelUpDisplay.Hide)
  else
    LevelUpDisplay.Show = nil
    hooksecurefunc(LevelUpDisplay, "Show", function()
      LevelUpDisplay:Show()
    end)
    db.levelup = nil
  end
end

function SpecialFrames:UpdateMinimap()
  if (db.minimap == nil) then return end

  local MinimapCluster = _G.MinimapCluster

  if db.minimap and self:IsEnabled() then
    MinimapCluster:Hide()
    MinimapCluster.Show = dummy
    MinimapCluster:EnableMouse(false)
  else
    MinimapCluster.Show = nil
    MinimapCluster:Show()
    MinimapCluster:EnableMouse(true)

    db.minimap = nil
  end
end

function SpecialFrames:UpdateMirrorBar()
  if (db.mirrorbar == nil) then return end

  local MIRRORTIMER_NUMTIMERS = MIRRORTIMER_NUMTIMERS

  if db.mirrorbar and self:IsEnabled() then
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
    db.mirrorbar = nil
  end
end

function SpecialFrames:UpdateParty()
  if (db.party == nil) then return end

  local GetCVar = GetCVar
  local GetNumSubgroupMembers = GetNumSubgroupMembers
  local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS
  local UnitExists = UnitExists
  local isCompact = tonumber(GetCVar("useCompactPartyFrames"))

  if db.party and self:IsEnabled() then
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("party"..i) then
          local pf = _G["PartyMemberFrame"..i]
          pf:Hide()
          pf.Show = dummy
        end
      end
    end
  else
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("party"..i) then
          local pf = _G["PartyMemberFrame"..i]
          pf.Show = nil
          pf:Show()
        end
      end
    end
    db.party = nil
  end
end

function SpecialFrames:UpdatePhaseIcon()
  if (db.phaseicon == nil) then return end

  local GetCVar = GetCVar
  local GetNumSubgroupMembers = GetNumSubgroupMembers
  local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS
  local UnitExists = UnitExists
  local UnitInPhase = UnitInPhase
  local UnitIsWarModePhased = UnitIsWarModePhased
  local isCompact = tonumber(GetCVar("useCompactPartyFrames"))

  if db.phaseicon and self:IsEnabled() then
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("party"..i) then
          if UnitInPhase("party"..i) or UnitIsWarModePhased("party"..i) then
            local icon = _G["PartyMemberFrame"..i.."NotPresentIcon"]
            icon:Hide()
            icon.Show = dummy
          end
        end
      end
    end
  else
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("party"..i) then
          if UnitInPhase("party"..i) or UnitIsWarModePhased("party"..i) then
            local icon = _G["PartyMemberFrame"..i.."NotPresentIcon"]
            icon.Show = nil
            icon:Show()
          end
        end
      end
    end
    db.phaseicon = nil
  end
end

function SpecialFrames:UpdateTalkingHead()
  if (db.talkinghead == nil) then return end

  local GetAddOnInfo = GetAddOnInfo
  local TalkingHeadFrame = _G.TalkingHeadFrame

  if db.talkinghead and self:IsEnabled() then
    if TalkingHeadFrame then
      hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
        TalkingHeadFrame_CloseImmediately()
      end)
    end
  else
    if TalkingHeadFrame then
      TalkingHeadFrame:RegisterEvent("TALKINGHEAD_REQUESTED")
    end
    db.talkinghead = nil
  end
end

function SpecialFrames:UpdateVehicleSeatIndicator()
  if (db.vehicleseat == nil) then return end

  local VehicleSeatIndicator = _G.VehicleSeatIndicator

  if db.vehicleseat and self:IsEnabled() then
    if VehicleSeatIndicator then
      VehicleSeatIndicator:Hide()
      VehicleSeatIndicator.Show = dummy
    end
  else
    VehicleSeatIndicator.Show = nil
    if VehicleSeatIndicator then
      VehicleSeatIndicator:Show()
    end
    db.vehicleseat = nil
  end
end

function SpecialFrames:UpdateShoppingTooltip()
  if (db.shoppingtooltip == nil) then return end

  local ShoppingTooltip1 = _G.ShoppingTooltip1
  local ShoppingTooltip2 = _G.ShoppingTooltip2

  if db.shoppingtooltip and self:IsEnabled() then
    ShoppingTooltip1:SetScript("OnShow", ShoppingTooltip1.Hide)
    ShoppingTooltip2:SetScript("OnShow", ShoppingTooltip2.Hide)
  else
    ShoppingTooltip1:SetScript("OnShow", ShoppingTooltip1.Show)
    ShoppingTooltip2:SetScript("OnShow", ShoppingTooltip2.Show)

    db.shoppingtooltip = nil
  end
end

function SpecialFrames:UpdateSystemMessage()
  if (db.sysmessage == nil) then return end

  local UIErrorsFrame = _G.UIErrorsFrame

  if db.sysmessage and self:IsEnabled() then
    UIErrorsFrame:UnregisterEvent("SYSMSG")
  else
    UIErrorsFrame:RegisterEvent("SYSMSG")

    db.sysmessage = nil
  end
end

function SpecialFrames:UpdateInfoMessage()
  if (db.infomessage == nil) then return end

  local UIErrorsFrame = _G.UIErrorsFrame

  if db.infomessage and self:IsEnabled() then
    UIErrorsFrame:UnregisterEvent("UI_INFO_MESSAGE")
  else
    UIErrorsFrame:RegisterEvent("UI_INFO_MESSAGE")

    db.infomessage = nil
  end
end

function SpecialFrames:UpdateErrorMessage()
  if (db.errormessage == nil) then return end

  local UIErrorsFrame = _G.UIErrorsFrame

  if db.errormessage and self:IsEnabled() then
    UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
  else
    UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")

    db.errormessage = nil
  end
end

function SpecialFrames:UpdateSubZoneText()
  if (db.subzonetext == nil) then return end

  local SubZoneTextFrame = _G.SubZoneTextFrame

  if db.subzonetext and self:IsEnabled() then
    SubZoneTextFrame:Hide()
    SubZoneTextFrame.Show = dummy
  else
    SubZoneTextFrame.Show = nil

    db.subzonetext = nil
  end
end

function SpecialFrames:UpdateZoneText()
  if (db.zonetext == nil) then return end

  local ZoneTextFrame = _G.ZoneTextFrame

  if db.zonetext and self:IsEnabled() then
    ZoneTextFrame:Hide()
    ZoneTextFrame.Show = dummy
  else
    ZoneTextFrame.Show = nil

    db.zonetext = nil
  end
end
