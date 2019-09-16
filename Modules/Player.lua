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

function Player:GetOptions()
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
    arcanebar = {
      disabled = function() return (not self:IsEnabled() or class ~= "MAGE") end,
      order = 2, type = "toggle",
      name = L["Arcane Bar"], desc = format(L["Hides the %smage class%s arcane charges bar"], "|cff69CCF0", "|r"),
      set = function(info, v)
        db.arcanebar = v
        self:UpdateArcaneBar()
      end,
    },
    chibar = {
      disabled = function() return (not self:IsEnabled() or class ~= "MONK") end,
      order = 3, type = "toggle",
      name = L["Chi Bar"], desc = format(L["Hides the %smonk class%s chi bar"], "|cff00FF96", "|r"),
      set = function(info, v)
        db.chibar = v
        self:UpdateChiBar()
      end,
    },
    combobar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 4, type = "toggle",
      name = L["Combo Bar"], desc = format(L["Hides the %sdruid%s / %srogue%s class combo bar"], "|cffFF7D0A", "|r", "|cffFFF569", "|r"),
      set = function(info, v)
        db.combobar = v
        self:UpdateComboBar()
      end,
    },
    insanitybar = {
      disabled = function() return (not self:IsEnabled() or class ~= "PRIEST") end,
      order = 5, type = "toggle",
      name = L["Insanity Bar"], desc = L["Hides the priest class insanity bar"],
      set = function(info, v)
        db.insanitybar = v
        self:UpdateInsanityBar()
      end,
    },
    powerbar = {
      disabled = function() return (not self:IsEnabled() or class ~= "PALADIN") end,
      order = 6, type = "toggle",
      name = L["Power Bar"], desc = format(L["Hides the %spaladin class%s power bar"], "|cffF58CBA", "|r"),
      set = function(info, v)
        db.powerbar = v
        self:UpdatePowerBar()
      end,
    },
    priestbar = {
      disabled = function() return (not self:IsEnabled() or class ~= "PRIEST") end,
      order = 7, type = "toggle",
      name = L["Priest Bar"], desc = L["Hides the priest class bar"],
      set = function(info, v)
        db.priestbar = v
        self:UpdatePriestBar()
      end,
    },
    runeframe = {
      disabled = function() return (not self:IsEnabled() or class ~= "DEATHKNIGHT") end,
      order = 8, type = "toggle",
      name = L["Rune Frame"], desc = format(L["Hides the %sdeathknight class%s rune frame"], "|cffC41F3B", "|r"),
      set = function(info, v)
        db.runeframe = v
        self:UpdateRuneFrame()
      end,
    },
    shardframe = {
      disabled = function() return (not self:IsEnabled() or class ~= "WARLOCK") end,
      order = 9, type = "toggle",
      name = L["Shard Frame"], desc = format(L["Hides the %swarlock class%s shard frame"], "|cff9482C9", "|r"),
      set = function(info, v)
        db.shardframe = v
        self:UpdateShardFrame()
      end,
    },
    staggerbar = {
      disabled = function() return (not self:IsEnabled() or class ~= "MONK") end,
      order = 10, type = "toggle",
      name = L["Stagger Bar"], desc = format(L["Hides the %smonk class%s stagger bar"], "|cff00FF96", "|r"),
      set = function(info, v)
        db.staggerbar = v
        self:UpdateStaggerBar()
      end,
    },
    totemframe = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 11, type = "toggle",
      name = L["Totem Frame"], desc = L["Hides the totem frame"],
      set = function(info, v)
        db.totemframe = v
        self:UpdateTotemFrame()
      end,
    },
    units = {
      order = 12, type = "group", inline = true,
      name = L["Unit Frames"],
      args = {
        focusframe = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Focus Frame"], desc = L["Hides the focus frame"],
          set = function(info, v)
            db.focusframe = v
            self:UpdateFocusFrame()
          end,
        },
        playercastbar = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Player Cast Bar"], desc = L["Hides the player cast bar"],
          set = function(info, v)
            db.playercastbar = v
            self:UpdatePlayerCastBar()
          end,
        },
        playerpowerbar = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["Player Power Bar"], desc = L["Hides the player power bar"],
          set = function(info, v)
            db.playerpowerbar = v
            self:UpdatePlayerPowerBar()
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
          order = 4, type = "toggle",
          name = L["Target Unit Frame"], desc = L["Hides the target unit frame"],
          set = function(info, v)
            db.targetunitframe = v
            self:UpdateTargetUnitFrame()
          end,
        },
      },
    },
  },
}
end

function Player:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("Player"))

  self.db = HideBlizzard.db:RegisterNamespace("Player", defaults)
  db = self.db.profile

  local options = self:GetOptions()
  HideBlizzard:RegisterModuleOptions("Player", options, "Player")
end

function Player:OnEnable()
  self:UpdateView()
end

function Player:OnDisable()
  self:UpdateView()
end

function Player:UpdateView()
  self:UpdateArcaneBar()
  self:UpdateChiBar()
  self:UpdateComboBar()
  self:UpdateInsanityBar()
  self:UpdatePowerBar()
  self:UpdatePriestBar()
  self:UpdateRuneFrame()
  self:UpdateShardFrame()
  self:UpdateStaggerBar()
  self:UpdateTotemFrame()

  self:UpdateFocusFrame()
  self:UpdatePlayerCastBar()
  self:UpdatePlayerPowerBar()
  self:UpdatePlayerUnitFrame()
  self:UpdateTargetUnitFrame()
end

function Player:UpdateArcaneBar()
  if (db.arcanebar == nil) then return end

  if (not class == "MAGE") then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local MageArcaneChargesFrame = _G.MageArcaneChargesFrame

  if db.arcanebar and Player:IsEnabled() then
    if (currentSpecName == "Arcane") then
      MageArcaneChargesFrame:Hide()
      MageArcaneChargesFrame.Show = dummy
    end
  else
    MageArcaneChargesFrame.Show = nil
    if (currentSpecName == "Arcane") then
      MageArcaneChargesFrame:Show()
    end
    db.arcanebar = nil
  end
end

function Player:UpdateChiBar()
  if (db.chibar == nil) then return end

  if (not class == "MONK") then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local MonkHarmonyBarFrame = _G.MonkHarmonyBarFrame

  if db.chibar and self:IsEnabled() then
    if (currentSpecName == "Windwalker") then
      MonkHarmonyBarFrame:Hide()
      MonkHarmonyBarFrame.Show = dummy
    end
  else
    MonkHarmonyBarFrame.Show = nil
    if (currentSpecName == "Windwalker") then
      MonkHarmonyBarFrame:Show()
    end
    db.chibar = nil
  end
end

function Player:UpdateComboBar()
  if (db.combobar == nil) then return end

  if (not class == "DRUID") or (not class == "ROGUE") then return end

  local SetCVar = SetCVar
  local ComboPointPlayerFrame = _G.ComboPointPlayerFrame

  if db.combobar and self:IsEnabled() then
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
    db.combobar = nil
  end
end

function Player:UpdateFocusFrame()
  if (db.focusframe == nil) then return end

  local UnitExists = UnitExists
  local FocusFrame = _G.FocusFrame

  if db.focusframe and self:IsEnabled() then
    FocusFrame:Hide()
    FocusFrame.Show = dummy
  else
    FocusFrame.Show = nil
    if UnitExists("focus") then
      FocusFrame:Show()
    end
    db.focusframe = nil
  end
end

function Player:UpdateInsanityBar()
  if (db.insanitybar == nil) then return end

  if (not class == "PRIEST") then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local InsanityBarFrame = _G.InsanityBarFrame

  if db.insanitybar and self:IsEnabled() then
    if (currentSpecName == "Shadow") then
      InsanityBarFrame:Hide()
      InsanityBarFrame.Show = dummy
    end
  else
    InsanityBarFrame.Show = nil
    if (currentSpecName == "Shadow") then
      InsanityBarFrame:Show()
    end
    db.insanitybar = nil
  end
end

function Player:UpdatePlayerCastBar()
  if (db.playercastbar == nil) then return end

  local CastingBarFrame = _G.CastingBarFrame

  if db.playercastbar and self:IsEnabled() then
    CastingBarFrame:Hide()
    CastingBarFrame.Show = dummy
  else
    CastingBarFrame.Show = nil

    db.playercastbar = nil
  end
end

function Player:UpdatePlayerPowerBar()
  if (db.playerpowerbar == nil) then return end

  local PlayerPowerBarAlt = _G.PlayerPowerBarAlt

  if db.playerpowerbar and self:IsEnabled() then
    if PlayerPowerBarAlt then
      PlayerPowerBarAlt:Hide()
      PlayerPowerBarAlt.Show = dummy
    else
      PlayerPowerBarAlt.Show = dummy
    end
  else
    PlayerPowerBarAlt.Show = nil
    if PlayerPowerBarAlt then
      PlayerPowerBarAlt:Show()
    end
    db.playerpowerbar = nil
  end
end

function Player:UpdatePlayerUnitFrame()
  if (db.playerunitframe == nil) then return end

  local PlayerFrame = _G.PlayerFrame

  if db.playerunitframe and self:IsEnabled() then
    PlayerFrame:Hide()
    PlayerFrame.Show = dummy
  else
    PlayerFrame.Show = nil
    PlayerFrame:Show()

    db.playerunitframe = nil
  end
end

function Player:UpdatePowerBar()
  if (db.powerbar == nil) then return end

  if (not class == "PALADIN") then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local PaladinPowerBarFrame = _G.PaladinPowerBarFrame

  if db.powerbar and self:IsEnabled() then
    if (currentSpecName == "Retribution") then
      PaladinPowerBarFrame:Hide()
      PaladinPowerBarFrame.Show = dummy
    end
  else
    PaladinPowerBarFrame.Show = nil
    if (currentSpecName == "Retribution") then
      PaladinPowerBarFrame:Show()
    end
    db.powerbar = nil
  end
end

function Player:UpdatePriestBar()
  if (db.priestbar == nil) then return end

  if (not class == "PRIEST" ) then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local UnitLevel = UnitLevel
  local PriestBarFrame = _G.PriestBarFrame

  if db.priestbar and self:IsEnabled() then
    if (currentSpecName == "Shadow") and (UnitLevel("player") > 10) then
      PriestBarFrame:Hide()
      PriestBarFrame.Show = dummy
    end
  else
    if (currentSpecName == "Shadow") and (UnitLevel("player") > 10) then
      PriestBarFrame.Show = nil
      PriestBar_Update()
    end
    db.priestbar = nil
  end
end

function Player:UpdateRuneFrame()
  if (db.runeframe == nil) then return end

  if (not class == "DEATHKNIGHT") then return end

  local RuneFrame = _G.RuneFrame

  if db.runeframe and self:IsEnabled() then
    RuneFrame:Hide()
    RuneFrame.Show = dummy
  else
    RuneFrame.Show = nil
    RuneFrame:Show()

    db.runeframe = nil
  end
end

function Player:UpdateShardFrame()
  if (db.shardframe == nil) then return end

  if (not class == "WARLOCK") then return end

  local WarlockPowerFrame = _G.WarlockPowerFrame

  if db.shardframe and self:IsEnabled() then
    WarlockPowerFrame:Hide()
    WarlockPowerFrame.Show = dummy
  else
    WarlockPowerFrame.Show = nil
    WarlockPowerFrame:Show()

    db.shardframe = nil
  end
end

function Player:UpdateStaggerBar()
  if (db.staggerbar == nil) then return end

  if (not class == "MONK") then return end

  local GetSpecialization = GetSpecialization
  local GetSpecializationInfo = GetSpecializationInfo
  local currentSpec = GetSpecialization()
  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
  local MonkStaggerBar = _G.MonkStaggerBar

  if db.staggerbar and self:IsEnabled() then
    if (currentSpecName == "Brewmaster") then
      MonkStaggerBar:Hide()
      MonkStaggerBar.Show = dummy
    end
  else
    MonkStaggerBar.Show = nil
    if (currentSpecName == "Brewmaster") then
      MonkStaggerBar:Show()
    end
    db.staggerbar = nil
  end
end

function Player:UpdateTargetUnitFrame()
  if (db.targetunitframe == nil) then return end

  local UnitExists = UnitExists
  local TargetFrame = _G.TargetFrame

  if db.targetunitframe and self:IsEnabled() then
    TargetFrame:Hide()
    TargetFrame.Show = dummy
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

  local GetTotemInfo = GetTotemInfo
  local MAX_TOTEMS = MAX_TOTEMS
  local TotemFrame = _G.TotemFrame

  if db.totemframe and self:IsEnabled() then
    for i=1, MAX_TOTEMS do
      local haveTotem = GetTotemInfo(i)
      if haveTotem then
        TotemFrame:Hide()
        TotemFrame.Show = dummy
      end
    end
  else
    for i=1, MAX_TOTEMS do
      local haveTotem = GetTotemInfo(i)
      if haveTotem then
        TotemFrame.Show = nil
        TotemFrame:Show()
      end
    end
    db.totemframe = nil
  end
end
