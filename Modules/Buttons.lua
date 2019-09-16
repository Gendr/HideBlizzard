local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Buttons = HideBlizzard:NewModule("Buttons")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local dummy = function() end

local db
local defaults = {
  profile = {
    -- minimap
    ["calendar"] = nil,
    ["mail"] = nil,
    ["worldmap"] = nil,
    ["zonetext"] = nil,
    ["zonetextborder"] = nil,
    ["zoom"] = nil,
    -- chat
    ["channel"] = nil,
    ["menu"] = nil,
  },
}

function Buttons:getOptions()
return {
  type = "group",
  name = L["Buttons"],
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
      name = format("|cffFFFF55%s|r", L["Enable Buttons"]),
      desc = format("|cffFFFF55%s|r", L["Hides buttons connected to the chat and minimap frame"]), descStyle = "inline",
      get = function() return HideBlizzard:GetModuleEnabled("Buttons") end,
      set = function(info, value) HideBlizzard:SetModuleEnabled("Buttons", value) end,
    },
    spacer = {
      order = 1.5, type = "description",
      name = "",
    },
    minimap = {
      order = 2, type = "group", inline = true,
      name = L["Minimap Buttons"],
      args = {
        calendar = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Calendar"], desc = L["Hides the calendar button"],
          set = function(info, v)
            db.calendar = v
            self:UpdateCalendar()
          end,
        },
        mail = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Mail"], desc = L["Hides the mail button"],
          set = function(info, v)
            db.mail = v
            self:UpdateMail()
          end,
        },
        worldmap = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["World Map"], desc = L["Hides the world map button"],
          set = function(info, v)
            db.worldmap = v
            self:UpdateWorldMap()
          end,
        },
        zonetext = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 4, type = "toggle",
          name = L["Zone Text"], desc = L["Hide the zone text"],
          set = function(info, v)
            db.zonetext = v
			self:UpdateZoneText()
          end,
        },
        zonetextborder = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 5, type = "toggle",
          name = L["Zone Text Border"], desc = L["Hide the zone text border"],
          set = function(info, v)
            db.zonetextborder = v
			self:UpdateZoneTextBorder()
          end,
        },
        zoom = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 6, type = "toggle",
          name = L["Zoom"], desc = L["Hides both the zoom buttons"],
          set = function(info, v)
            db.zoom = v
            self:UpdateZoom()
          end,
        },
      },
    },
    chat = {
      order = 3, type = "group", inline = true,
      name = L["Chat Buttons"],
      args = {
        channel = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 1, type = "toggle",
          name = L["Channel"], desc = L["Hides the chat channel button on the chat frame"],
          set = function(info, v)
            db.channel = v
            self:UpdateChannel()
          end,
        },
        menu = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Menu"], desc = L["Hides the chat menu button on the chat frame"],
          set = function(info, v)
            db.menu = v
            self:UpdateMenu()
          end,
        },
      },
    },
  },
}
end

function Buttons:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("Buttons"))

  self.db = HideBlizzard.db:RegisterNamespace("Buttons", defaults)
  db = self.db.profile

  local options = self:getOptions()
  HideBlizzard:RegisterModuleOptions("Buttons", options, "Buttons")
end

function Buttons:OnEnable()
  self:UpdateView()
end

function Buttons:OnDisable()
  self:UpdateView()
end

function Buttons:UpdateView()
  self:UpdateCalendar()
  self:UpdateMail()
  self:UpdateWorldMap()
  self:UpdateZoneText()
  self:UpdateZoneTextBorder()
  self:UpdateZoom()

  self:UpdateChannel()
  self:UpdateMenu()
end

function Buttons:UpdateCalendar()
  if (db.calendar == nil) then return end

  local GameTimeFrame = _G.GameTimeFrame

  if db.calendar and Buttons:IsEnabled() then
    GameTimeFrame:Hide()
    GameTimeFrame.Show = dummy
  else
    GameTimeFrame.Show = nil
    GameTimeFrame:Show()

    db.calendar = nil
  end
end

function Buttons:UpdateMail()
  if (db.mail == nil) then return end

  local HasNewMail = HasNewMail
  local MiniMapMailFrame = _G.MiniMapMailFrame

  if db.mail and Buttons:IsEnabled() then
    if HasNewMail() then
      MiniMapMailFrame:Hide()
      MiniMapMailFrame.Show = dummy
    else
	  MiniMapMailFrame.Show = dummy
    end
  else
    MiniMapMailFrame.Show = nil
    if HasNewMail() then
      MiniMapMailFrame:Show()
    end
    db.mail = nil
  end
end

function Buttons:UpdateWorldMap()
  if (db.worldmap == nil) then return end

  local MiniMapWorldMapButton = _G.MiniMapWorldMapButton

  if db.worldmap and Buttons:IsEnabled() then
    MiniMapWorldMapButton:Hide()
    MiniMapWorldMapButton.Show = dummy
  else
    MiniMapWorldMapButton.Show = nil
	MiniMapWorldMapButton:Show()

    db.worldmap = nil
  end
end

function Buttons:UpdateZoneText()
  if (db.zonetext == nil) then return end

  local MinimapZoneTextButton = _G.MinimapZoneTextButton

  if db.zonetext and Buttons:IsEnabled() then
    MinimapZoneTextButton:Hide()
	MinimapZoneTextButton.Show = dummy
  else
    MinimapZoneTextButton.Show = nil
	MinimapZoneTextButton:Show()

    db.zonetext = nil
  end
end

function Buttons:UpdateZoneTextBorder()
  if (db.zonetextborder == nil) then return end

  local MinimapBorderTop = _G.MinimapBorderTop
  local MinimapToggleButton = _G.MinimapToggleButton

  if db.zonetextborder and Buttons:IsEnabled() then
    MinimapBorderTop:Hide()
    MinimapBorderTop.Show = dummy

    MinimapToggleButton.Show = dummy
    MinimapToggleButton:Hide()
  else
    MinimapBorderTop.Show = nil
    MinimapBorderTop:Show()

    MinimapToggleButton.Show = nil
    MinimapToggleButton:Show()

    db.zonetextborder = nil
  end
end


function Buttons:UpdateZoom()
  if (db.zoom == nil) then return end

  local MinimapZoomIn = _G.MinimapZoomIn
  local MinimapZoomOut = _G.MinimapZoomOut

  if db.zoom and Buttons:IsEnabled() then
    MinimapZoomIn:Hide()
    MinimapZoomIn.Show = dummy

    MinimapZoomOut:Hide()
    MinimapZoomOut.Show = dummy
  else
    MinimapZoomIn.Show = nil
    MinimapZoomIn:Show()

    MinimapZoomOut.Show = nil
    MinimapZoomOut:Show()

    db.zoom = nil
  end
end

function Buttons:UpdateChannel()
  if (db.channel == nil) then return end

  local ChatFrameChannelButton = _G.ChatFrameChannelButton

  if db.channel and Buttons:IsEnabled() then
    ChatFrameChannelButton:Hide()
    ChatFrameChannelButton.Show = dummy
  else
    ChatFrameChannelButton.Show = nil
    ChatFrameChannelButton:Show()

    db.channel = nil
  end
end

function Buttons:UpdateMenu()
  if (db.menu == nil) then return end

  local ChatFrameMenuButton = _G.ChatFrameMenuButton

  if db.menu and Buttons:IsEnabled() then
    ChatFrameMenuButton:Hide()
    ChatFrameMenuButton.Show = dummy
  else
    ChatFrameMenuButton.Show = nil
    ChatFrameMenuButton:Show()

    db.menu = nil
  end
end
