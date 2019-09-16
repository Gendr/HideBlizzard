local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local ActionBar = HideBlizzard:NewModule("ActionBar")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local level = UnitLevel("player")
local dummy = function() end

local db
local defaults = {
  profile = {
    ["gryphons"] = nil,
    ["hotkey"] = nil,
    ["macro"] = nil,
    ["mainmenubar"] = nil,
    ["reputationbar"] = nil,
    ["stancebar"] = nil,
    ["vehicleleave"] = nil,
    ["xpbar"] = nil,
  },
}

function ActionBar:getOptions()
return {
  type = "group",
  name = L["ActionBar"],
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
      name = format("|cffFFFF55%s|r",L["Enable Action Bar"]),
      desc = format("|cffFFFF55%s|r", L["Hides frames connected to the action bar"]), descStyle = "inline",
      get = function() return HideBlizzard:GetModuleEnabled("ActionBar") end,
      set = function(info, value) HideBlizzard:SetModuleEnabled("ActionBar", value) end,
    },
    spacer = {
      order = 1.5, type = "description",
      name = "",
    },
    gryphons = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 2, type = "toggle",
      name = L["Gryphons"], desc = L["Hides the art (gryphons) at each ends of the action bar"],
      set = function(info, v)
        db.gryphons = v
        self:UpdateGryphons()
      end,
    },
    hotkey = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 3, type = "toggle",
      name = L["Hotkey"], desc = L["Hides the hotkey text on the action bar buttons"],
      set = function(info, v)
        db.hotkey = v
        self:UpdateHotkey()
      end,
    },
    macro = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 4, type = "toggle",
      name = L["Macro"], desc = L["Hides the macro text on the action bar buttons"],
      set = function(info, v)
        db.macro = v
        self:UpdateMacro()
      end,
    },
    mainmenubar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 5, type = "toggle",
      name = L["Main Menu Bar"], desc = format("%s\n|cffFF0000%s|r", L["Hides the action bar frame"], L["Note: All options will be disabled"]),
      set = function(info, v)
        db.mainmenubar = v
        self:UpdateMainMenuBar()
      end,
    },
    reputationbar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 6, type = "toggle",
      name = L["Reputation Bar"], desc = L["Hides the reputation bar"],
      set = function(info, v)
        db.reputationbar = v
        self:UpdateReputationBar()
      end,
    },
    stancebar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 7, type = "toggle",
      name = L["Stance Bar"], desc = L["Hides the stance / shapeshift bar"],
      set = function(info, v)
        db.stancebar = v
        self:UpdateStanceBar()
      end,
    },
    vehicleleave = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 8, type = "toggle",
      name = L["Vehicle Leave"], desc = L["Hides the vehicle leave button above the action bar"],
      set = function(info, v)
        db.vehicleleave = v
        self:UpdateVehicleLeave()
      end,
    },
    xpbar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 9, type = "toggle",
      name = L["Experience Bar"], desc = L["Hides the experience bar"],
      set = function(info, v)
        db.xpbar = v
        self:UpdateXPBar()
      end,
    },
  },
}
end

function ActionBar:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("ActionBar"))

  self.db = HideBlizzard.db:RegisterNamespace("ActionBar", defaults)
  db = self.db.profile

  local options = self:getOptions()
  HideBlizzard:RegisterModuleOptions("ActionBar", options, "ActionBar")
end

function ActionBar:OnEnable()
  self:UpdateView()
end

function ActionBar:OnDisable()
  self:UpdateView()
end

function ActionBar:UpdateView()
  self:UpdateGryphons()
  self:UpdateHotkey()
  self:UpdateMacro()
  self:UpdateMainMenuBar()
  self:UpdateReputationBar()
  self:UpdateStanceBar()
  self:UpdateVehicleLeave()
  self:UpdateXPBar()
end

function ActionBar:UpdateGryphons()
  if (db.gryphons == nil) then return end

  local MainMenuBarLeftEndCap = _G.MainMenuBarLeftEndCap
  local MainMenuBarRightEndCap = _G.MainMenuBarRightEndCap

  if db.gryphons and self:IsEnabled() then
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
  else
    MainMenuBarLeftEndCap:Show()
    MainMenuBarRightEndCap:Show()

    db.gryphons = nil
  end
end

function ActionBar:UpdateHotkey()
  if (db.hotkey == nil) then return end

  local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

  if db.hotkey and self:IsEnabled() then
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
    db.hotkey = nil
  end
end

function ActionBar:UpdateMacro()
  if (db.macro == nil) then return end

  local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

  if db.macro and self:IsEnabled() then
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
    db.macro = nil
  end
end

function ActionBar:UpdateMainMenuBar()
  if (db.mainmenubar == nil) then return end

  local MainMenuBar = _G.MainMenuBar

  if db.mainmenubar and self:IsEnabled() then
    MainMenuBar:Hide()
    MainMenuBar.Show = dummy
  else
    MainMenuBar.Show = nil
    MainMenuBar:Show()

    db.mainmenubar = nil
  end
end

function ActionBar:UpdateReputationBar()
  if (db.reputationbar == nil) then return end

  local GetWatchedFactionInfo = GetWatchedFactionInfo
  local ReputationWatchBar = _G.ReputationWatchBar

  if db.reputationbar and self:IsEnabled() then
    if ReputationWatchBar then
      ReputationWatchBar:Hide()
	  ReputationWatchBar.Show = dummy
    else
      ReputationWatchBar.Show = dummy
    end
  else
	ReputationWatchBar.Show = nil
    local name, _, _, _, _ = GetWatchedFactionInfo()
	if name then
	  ReputationWatchBar:Show()
    end
    db.reputationbar = nil
  end
end

function ActionBar:UpdateStanceBar()
  if (db.stancebar == nil) then return end

  local GetNumShapeshiftForms = GetNumShapeshiftForms
  local numForms = GetNumShapeshiftForms()
  local StanceBarFrame = _G.StanceBarFrame

  if db.stancebar and self:IsEnabled() then
    if (numForms > 0) then
      StanceBarFrame:Hide()
      StanceBarFrame.Show = dummy
    end
  else
    if (numForms > 0) then
      StanceBarFrame.Show = nil
      StanceBar_Update()
    end
    db.stancebar = nil
  end
end

function ActionBar:UpdateVehicleLeave()
  if (db.vehicleleave == nil) then return end

  local UnitOnTaxi = UnitOnTaxi
  local MainMenuBarVehicleLeaveButton = _G.MainMenuBarVehicleLeaveButton

  if db.vehicleleave and self:IsEnabled() then
    if UnitOnTaxi("player") then
      MainMenuBarVehicleLeaveButton:Hide()
      MainMenuBarVehicleLeaveButton.Show = dummy
    else
      MainMenuBarVehicleLeaveButton.Show = dummy
    end
  else
    MainMenuBarVehicleLeaveButton.Show = nil
	if UnitOnTaxi("player") then
	  MainMenuBarVehicleLeaveButton:Show()
    end
    db.vehicleleave = nil
  end
end

function ActionBar:UpdateXPBar()
  if (db.xpbar == nil) then return end

  local MainMenuExpBar = _G.MainMenuExpBar

  if db.xpbar and self:IsEnabled() then
    if MainMenuExpBar then
      MainMenuExpBar:Hide()
	  MainMenuExpBar.Show = dummy
    else
      MainMenuExpBar.Show = dummy
    end
  else
	MainMenuExpBar.Show = nil
    MainMenuExpBar:Show()

    db.xpbar = nil
  end
end
