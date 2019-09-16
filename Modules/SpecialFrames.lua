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
    ["gametooltip"] = nil,
    ["minimap"] = nil,
    ["mirrorbar"] = nil,
    ["questtimer"] = nil,
    -- messages
    ["errormessage"] = nil,
    ["infomessage"] = nil,
    ["sysmessage"] = nil,
    ["zonetext"] = nil,
    ["subzonetext"] = nil,
    -- party/raid
    ["compactraid"] = nil,
    ["party"] = nil,
  },
}

function SpecialFrames:getOptions()
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
      name = L["Armored Man"], desc = L["Hides the armored man (durability)"],
      set = function(info, v)
        db.armoredman = v
        self:UpdateArmoredMan()
      end,
    },
    aura = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 3, type = "toggle",
      name = L["Aura"], desc = L["Hides the buff and debuff frame"],
      set = function(info, v)
        db.aura = v
        self:UpdateAura()
      end,
    },
    gametooltip = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 4, type = "toggle",
      name = L["Game Tooltip"], desc = L["Hides the game tooltip frame"],
      set = function(info, v)
        db.gametooltip = v
        self:UpdateGameTooltip()
      end,
    },
    minimap = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 5, type = "toggle",
      name = L["Minimap"],  desc = L["Hides the minimap"],
      set = function(info, v)
        db.minimap = v
        self:UpdateMinimap()
      end,
    },
    mirrorbar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 6, type = "toggle",
      name = L["Mirror Bar"], desc = L["Hides the mirror (breath/fatigue) bar"],
      set = function(info, v)
        db.mirrorbar = v
        self:UpdateMirrorBar()
      end,
    },
    questtimer = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 7, type = "toggle",
      name = L["Quest Timer"], desc = L["Hides the quest timer frame"],
      set = function(info, v)
        db.questtimer = v
        self:UpdateQuestTimer()
      end,
    },
    messages = {
      order = 8, type = "group", inline = true,
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
          name = L["Info Message"],
          desc = format("|cffFFFF00%s|r", L["Hides all the notification text at top of the screen"]),
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
      order = 9, type = "group", inline = true,
      name = L["Party/Raid"],
      args = {
        compactraid = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Compact Raid Frame"], desc = L["Hides the compact raid frame box on left side of screen"],
          set = function(info, v)
            db.compactraid = v
            self:UpdateCompactRaid()
          end,
        },
        party = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Party Frame"], desc = L["Hides the party frame"],
          set = function(info, v)
            db.party = v
            self:UpdateParty()
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

  local options = self:getOptions()
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
  self:UpdateGameTooltip()
  self:UpdateMinimap()
  self:UpdateMirrorBar()
  self:UpdateQuestTimer()

  self:UpdateSystemMessage()
  self:UpdateInfoMessage()
  self:UpdateErrorMessage()
  self:UpdateSubZoneText()
  self:UpdateZoneText()

  self:UpdateCompactRaid()
  self:UpdateParty()
end

function SpecialFrames:UpdateArmoredMan()
  if (db.armoredman == nil) then return end

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
    UIParent_ManageFramePositions()

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

function SpecialFrames:UpdateQuestTimer()
  if (db.questtimer == nil) then return end

  local QuestTimerFrame = _G.QuestTimerFrame

  if db.questtimer and self:IsEnabled() then
    if QuestTimerFrame then
      QuestTimerFrame:Hide()
      QuestTimerFrame.Show = dummy
    else
      QuestTimerFrame.Show = dummy
    end
  else
    if QuestTimerFrame then
      QuestTimerFrame.Show = nil
      QuestTimerFrame_Update(QuestTimerFrame)
    end
    db.questtimer = nil
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
