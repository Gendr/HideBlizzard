local UnitClass = UnitClass

local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Player = HideBlizzard:NewModule("Player")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local _, class = UnitClass("player")
local dummy = function() end

local db
local defaults = {
  profile = {
    ["combobar"] = nil,
    ["totemframe"] = nil,
    -- unit frames
    ["playercastbar"] = nil,
    ["playerunitframe"] = nil,
    ["targetunitframe"] = nil,
  },
}

function Player:getOptions()
return {
  type = "group",
  name = L["Player"],
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
      name = format("|cffFFFF55%s|r", L["Enable Player"]),
      desc = format("|cffFFFF55%s|r", L["Hides player related frames"]), descStyle = "inline",
      get = function() return HideBlizzard:GetModuleEnabled("Player") end,
      set = function(info, value) HideBlizzard:SetModuleEnabled("Player", value) end,
    },
    spacer = {
      order = 1.5, type = "description",
      name = "",
    },
    combobar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 2, type = "toggle",
      name = L["Combo Bar"], desc = L["Hides the combo bar"],
      set = function(info, v)
        db.combobar = v
        self:UpdateComboBar()
      end,
    },
    playercastbar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 3, type = "toggle",
      name = L["Player Cast Bar"], desc = L["Hides the player cast bar"],
      set = function(info, v)
        db.playercastbar = v
          self:UpdatePlayerCastBar()
        end,
    },
    playerunitframe = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 4, type = "toggle",
      name = L["Player Unit Frame"], desc = L["Hides the player unit frame"],
      set = function(info, v)
        db.playerunitframe = v
        self:UpdatePlayerUnitFrame()
      end,
    },
    targetunitframe = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 6, type = "toggle",
      name = L["Target Unit Frame"], desc = L["Hides the target unit frame"],
      set = function(info, v)
        db.targetunitframe = v
        self:UpdateTargetUnitFrame()
      end,
    },
    totemframe = {
      disabled = function() return (not Player:IsEnabled() or class ~= "SHAMAN") end,
      order = 7, type = "toggle",
      name = L["Totem Frame"], desc = L["Hides the totem frame"],
      set = function(info, v)
        db.totemframe = v
        self:UpdateTotemFrame()
      end,
    },
  },
}
end

function Player:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("Player"))

  self.db = HideBlizzard.db:RegisterNamespace("Player", defaults)
  db = self.db.profile

  local options = self:getOptions()
  HideBlizzard:RegisterModuleOptions("Player", options, "Player")
end

function Player:OnEnable()
  self:UpdateView()
end

function Player:OnDisable()
  self:UpdateView()
end

function Player:UpdateView()
  self:UpdateComboBar()
  self:UpdateTotemFrame()

  self:UpdatePlayerCastBar()
  self:UpdatePlayerUnitFrame()
  self:UpdateTargetUnitFrame()
end

function Player:UpdateComboBar()
  if (db.combobar == nil) then return end

  if (not class == "DRUID") or (not class == "ROGUE") then return end

  local ComboFrame = _G.ComboFrame

  if db.combobar and Player:IsEnabled() then
    if ComboFrame then
      ComboFrame:Hide()
      ComboFrame.Show = dummy
    else
      ComboFrame.Show = dummy
    end
  else
    if ComboFrame then
      ComboFrame.Show = nil
	  ComboFrame_Update(ComboFrame)
    end
    db.combobar = nil
  end
end

function Player:UpdatePlayerCastBar()
  if (db.playercastbar == nil) then return end

  local CastingBarFrame = _G.CastingBarFrame

  if db.playercastbar and Player:IsEnabled() then
    CastingBarFrame:Hide()
    CastingBarFrame.Show = dummy
  else
    CastingBarFrame.Show = nil

    db.playercastbar = nil
  end
end

function Player:UpdatePlayerUnitFrame()
  if (db.playerunitframe == nil) then return end

  local PlayerFrame = _G.PlayerFrame

  if db.playerunitframe and Player:IsEnabled() then
    PlayerFrame:Hide()
    PlayerFrame.Show = dummy
  else
    PlayerFrame.Show = nil
    PlayerFrame:Show()

    db.playerunitframe = nil
  end
end

function Player:UpdateTargetUnitFrame()
  if (db.targetunitframe == nil) then return end

  local UnitExists = UnitExists
  local TargetFrame = _G.TargetFrame

  if db.targetunitframe and Player:IsEnabled() then
    if UnitExists("target") then
      TargetFrame:Hide()
      TargetFrame.Show = dummy
    else
      TargetFrame.Show = dummy
    end
  else
    TargetFrame.Show = nil
    if UnitExists("target") then
      TargetFrame:Show()
    end
    db.targetunitframe = nil
  end
end

function Player:UpdateTotemFrame()
  if (db.totemframe == nil) then return end

  if (not class == "SHAMAN") then return end

  local GetTotemInfo = GetTotemInfo
  local MAX_TOTEMS = MAX_TOTEMS
  local TotemFrame = _G.TotemFrame

  if db.totemframe and Player:IsEnabled() then
    for i=1, MAX_TOTEMS do
      local hasTotem = GetTotemInfo(i)
      if hasTotem then
        TotemFrame:Hide()
        TotemFrame.Show = dummy
      end
    end
  else
    for i=1, MAX_TOTEMS do
      local hasTotem = GetTotemInfo(i)
      if hasTotem then
        TotemFrame.Show = nil
        TotemFrame:Show()
      end
    end
    db.totemframe = nil
  end
end
