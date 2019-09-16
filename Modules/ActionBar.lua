local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local ActionBar = HideBlizzard:NewModule("ActionBar")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local dummy = function() end

local db
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

function ActionBar:GetOptions()
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
    bagbar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 2, type = "toggle",
      name = L["Bag Bar"], desc = L["Hides the bag bar frame"],
      set = function(info, v)
        db.bagbar = v
        self:UpdateBagBar()
      end,
    },
    gryphons = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 3, type = "toggle",
      name = L["Gryphons"], desc = L["Hides the art (gryphons) at each ends of the action bar"],
      set = function(info, v)
        db.gryphons = v
        self:UpdateGryphons()
      end,
    },
    hotkey = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 4, type = "toggle",
      name = L["Hotkey"], desc = L["Hides the hotkey text on the action bar buttons"],
      set = function(info, v)
        db.hotkey = v
        self:UpdateHotkey()
      end,
    },
    macro = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 5, type = "toggle",
      name = L["Macro"], desc = L["Hides the macro text on the action bar buttons"],
      set = function(info, v)
        db.macro = v
        self:UpdateMacro()
      end,
    },
    mainmenubar = {
      disabled = function() return not self:IsEnabled() end,
      order = 6, type = "toggle",
      name = L["Main Menu Bar"], desc = format("%s\n|cffFF0000%s|r", L["Hides the action bar frame"], L["Note: Most options will be disabled"]),
      set = function(info, v)
        db.mainmenubar = v
        self:UpdateMainMenuBar()
      end,
    },
    microbar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 7, type = "toggle",
      name = L["Micro Bar"], desc = L["Hides the micro bar buttons located at the bottom-right of the screen"],
      set = function(info, v)
        db.microbar = v
        self:UpdateMicroBar()
      end,
    },
    stancebar = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 8, type = "toggle",
      name = L["Stance Bar"], desc = L["Hides the stance / shapeshift bar"],
      set = function(info, v)
        db.stancebar = v
        self:UpdateStanceBar()
      end,
    },
    status = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 9, type = "toggle",
      name = L["Status Tracking Bar"], desc = L["Hides all status tracking bars (artifact/faction/honor/level)"],
      set = function(info, v)
        db.status = v
        self:UpdateStatus()
      end,
    },
    vehicleleave = {
      disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
      order = 10, type = "toggle",
      name = L["Vehicle Leave"], desc = L["Hides the vehicle leave button above the action bar"],
      set = function(info, v)
        db.vehicleleave = v
        ActionBar:UpdateVehicleLeave()
      end,
    },
    vehiclemenubar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 11, type = "toggle",
      name = L["Vehicle Menu Bar"], desc = L["Hides the vehicle action bar"],
      set = function(info, v)
        db.vehiclemenubar = v
        self:UpdateVehicleMenuBar()
      end,
    },
    alerts = {
      order = 12, type = "group", inline = true,
      name = L["Alert Frames"],
      args = {
        azerite = {
          disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
          order = 1, type = "toggle",
          name = L["Azerite Alert"], desc = L["Hides the azerite alert window"],
          set = function(info, v)
            db.azerite = v
            self:UpdateAzerite()
          end,
        },
        collection = {
          disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
          order = 2, type = "toggle",
          name = L["Collection Alert"], desc = L["Hides the collection alert window"],
          set = function(info, v)
            db.collection = v
            self:UpdateCollection()
          end,
        },
        talent = {
          disabled = function() return (not self:IsEnabled() or db.mainmenubar) end,
          order = 3, type = "toggle",
          name = L["Talent Alert"], desc = L["Hides the talent alert window"],
          set = function(info, v)
            db.talent = v
            self:UpdateTalent()
          end,
        },
      },
    },
  },
}
end

function ActionBar:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("ActionBar"))

  self.db = HideBlizzard.db:RegisterNamespace("ActionBar", defaults)
  db = self.db.profile

  local options = self:GetOptions()
  HideBlizzard:RegisterModuleOptions("ActionBar", options, "ActionBar")
end

function ActionBar:OnEnable()
  self:UpdateView()
end

function ActionBar:OnDisable()
  self:UpdateView()
end

function ActionBar:UpdateView()
  self:UpdateBagBar()
  self:UpdateGryphons()
  self:UpdateHotkey()
  self:UpdateMacro()
  self:UpdateMainMenuBar()
  self:UpdateMicroBar()
  self:UpdateStatus()
  self:UpdateStanceBar()
  self:UpdateVehicleLeave()
  self:UpdateVehicleMenuBar()

  self:UpdateAzerite()
  self:UpdateCollection()
  self:UpdateTalent()
end

function ActionBar:UpdateAzerite()
  if (db.azerite == nil) then return end

  local CharacterMicroButtonAlert = _G.CharacterMicroButtonAlert

  if db.azerite and ActionBar:IsEnabled() then
    if CharacterMicroButtonAlert then
      CharacterMicroButtonAlert:Hide()
      CharacterMicroButtonAlert.Show = dummy
    end
  else
    CharacterMicroButtonAlert.Show = nil

    db.azerite = nil
  end
end

function ActionBar:UpdateBagBar()
  if (db.bagbar == nil) then return end

  local MicroButtonAndBagsBar = _G.MicroButtonAndBagsBar

  if db.bagbar and ActionBar:IsEnabled() then
    MicroButtonAndBagsBar:Hide()
  else
    MicroButtonAndBagsBar:Show()

    db.bagbar = nil
  end
end

function ActionBar:UpdateCollection()
  if (db.collection == nil) then return end

  local CollectionsMicroButtonAlert = _G.CollectionsMicroButtonAlert

  if db.collection and ActionBar:IsEnabled() then
    CollectionsMicroButtonAlert:Hide()
    CollectionsMicroButtonAlert.Show = dummy
  else
    CollectionsMicroButtonAlert.Show = nil

    db.collection = nil
  end
end

function ActionBar:UpdateGryphons()
  if (db.gryphons == nil) then return end

  if (db.gryphons and ActionBar:IsEnabled()) then
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.RightEndCap:Hide()
  else
    MainMenuBarArtFrame.LeftEndCap:Show()
    MainMenuBarArtFrame.RightEndCap:Show()

    db.gryphons = nil
  end
end

function ActionBar:UpdateHotkey()
  if (db.hotkey == nil) then return end

  local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

  if db.hotkey and ActionBar:IsEnabled() then
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

  if db.macro and ActionBar:IsEnabled() then
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
  if ( db.mainmenubar == nil ) then return end

  local UnitHasVehicleUI = UnitHasVehicleUI
  local MainMenuBar = _G.MainMenuBar

  if db.mainmenubar and ActionBar:IsEnabled() then
    MainMenuBar:Hide()
    MainMenuBar.Show = dummy
  else
    MainMenuBar.Show = nil
    if (not UnitHasVehicleUI("player")) then
      MainMenuBar:Show()
    end
    db.mainmenubar = nil
  end
end

function ActionBar:UpdateMicroBar()
  if ( db.microbar == nil ) then return end

  if db.microbar and ActionBar:IsEnabled() then
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
      if _G[button] then
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
      if _G[button] then
        _G[button].Show = nil
        _G[button]:Show()
      end
    end
    db.microbar = nil
  end
end

function ActionBar:UpdateStanceBar()
  if (db.stancebar == nil) then return end

  local GetNumShapeshiftForms = GetNumShapeshiftForms
  local StanceBarFrame = _G.StanceBarFrame

  if db.stancebar and ActionBar:IsEnabled() then
    if (GetNumShapeshiftForms() ~= 0) then
      StanceBarFrame:Hide()
      StanceBarFrame.Show = dummy
    end
  else
    if (GetNumShapeshiftForms() ~= 0) then
      StanceBarFrame.Show = nil
      StanceBar_Update()
    end
    db.stancebar = nil
  end
end

function ActionBar:UpdateStatus()
  if (db.status == nil) then return end

  local StatusTrackingBarManager = _G.StatusTrackingBarManager

  if db.status and ActionBar:IsEnabled() then
    if StatusTrackingBarManager then
      StatusTrackingBarManager:Hide()
      StatusTrackingBarManager.Show = function() end
    end
  else
    StatusTrackingBarManager.Show = nil
    if StatusTrackingBarManager then
      StatusTrackingBarManager:Show()
    end
    db.status = nil
  end
end

function ActionBar:UpdateTalent()
  if (db.talent == nil) then return end

  local TalentMicroButtonAlert = _G.TalentMicroButtonAlert

  if db.talent and ActionBar:IsEnabled() then
    if TalentMicroButtonAlert then
      TalentMicroButtonAlert:Hide()
      TalentMicroButtonAlert.Show = dummy
    end
  else
    TalentMicroButtonAlert.Show = nil

    db.talent = nil
  end
end

function ActionBar:UpdateVehicleLeave()
  if (db.vehicleleave == nil) then return end

  local CanExitVehicle = CanExitVehicle
  local MainMenuBarVehicleLeaveButton = _G.MainMenuBarVehicleLeaveButton

  if db.vehicleleave and ActionBar:IsEnabled() then
    if CanExitVehicle() then
      MainMenuBarVehicleLeaveButton:Hide()
      MainMenuBarVehicleLeaveButton.Show = dummy
    end
  else
    MainMenuBarVehicleLeaveButton.Show = nil
    if CanExitVehicle() then
      MainMenuBarVehicleLeaveButton:Show()
    end
    db.vehicleleave = nil
  end
end

function ActionBar:UpdateVehicleMenuBar()
  if (db.vehiclemenubar == nil) then return end

  local UnitInVehicle = UnitInVehicle
  local UnitHasVehicleUI = UnitHasVehicleUI
  local OverrideActionBar = _G.OverrideActionBar

  if db.vehiclemenubar and ActionBar:IsEnabled() then
    if UnitInVehicle("player") and UnitHasVehicleUI("player") then
      OverrideActionBar:Hide()
      OverrideActionBar.Show = dummy
    else
      OverrideActionBar.Show = dummy
    end
  else
    OverrideActionBar.Show = nil
    if UnitInVehicle("player") and UnitHasVehicleUI("player") then
      OverrideActionBar:Show()
    end
    db.vehiclemenubar = nil
  end
end
