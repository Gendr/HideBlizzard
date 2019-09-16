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
    ["clock"] = nil,
    ["garrison"] = nil,
    ["instance"] = nil,
    ["lfg"] = nil,
    ["mail"] = nil,
    ["tracking"] = nil,
    ["voice"] = nil,
    ["world"] = nil,
    ["zoom"] = nil,
    -- chat
    ["channel"] = nil,
    ["menu"] = nil,
    ["quickjoin"] = nil,
    ["chatvoice"] = nil,
    ["scrollbar"] = nil,
  },
}

function Buttons:GetOptions()
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
      order = 1, type = "toggle",  width = "full",
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
        clock = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Clock"], desc = L["Hides the clock"],
          set = function(info, v)
            db.clock = v
            self:UpdateClock()
          end,
        },
        garrison = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["Garrison"], desc = L["Hides the garrison button"],
          set = function(info, v)
            db.garrison = v
            self:UpdateGarrison()
          end,
        },
        instance = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 4, type = "toggle",
          name = L["Instance"], desc = L["Hides the instance difficulty button"],
          set = function(info, v)
            db.instance = v
            self:UpdateInstance()
          end,
        },
        lfg = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 5, type = "toggle",
          name = L["Looking For Group"], desc = L["Hides the looking for group (LFG) button"],
          set = function(info, v)
            db.lfg = v
            self:UpdateLFG()
          end,
        },
        mail = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 6, type = "toggle",
          name = L["Mail"], desc = L["Hides the mail button"],
          set = function(info, v)
            db.mail = v
            self:UpdateMail()
          end,
        },
        tracking = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 7, type = "toggle",
          name = L["Tracking"], desc = L["Hides the tracking button"],
          set = function(info, v)
            db.tracking = v
            self:UpdateTracking()
          end,
        },
        voice = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 8, type = "toggle",
          name = L["Voice"], desc = L["Hides the voice chat button"],
          set = function(info, v)
            db.voice = v
            self:UpdateVoice()
          end,
        },
        world = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 9, type = "toggle",
          name = L["World Map"], desc = L["Hides the world map button"],
          set = function(info, v)
            db.world = v
            self:UpdateWorld()
          end,
        },
        zoom = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 10, type = "toggle",
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
          name = L["Channel"], desc = L["Hides the channel button"],
          set = function(info, v)
            db.channel = v
            self:UpdateChannel()
          end,
        },
        menu = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 2, type = "toggle",
          name = L["Menu"],  desc = L["Hides the menu button"],
          set = function(info, v)
            db.menu = v
            self:UpdateMenu()
          end,
        },
        quickjoin = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 3, type = "toggle",
          name = L["Quick Join"], desc = L["Hides the quick join toast button"],
          set = function(info, v)
            db.quickjoin = v
            self:UpdateQuickjoin()
          end,
        },
        chatvoice = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 4, type = "toggle",
          name = L["Voice"], desc = L["Hides the voice button"],
          set = function(info, v)
            db.chatvoice = v
            self:UpdateChatVoice()
          end,
        },
        scrollbar = {
          disabled = function() return (not self:IsEnabled()) end,
          order = 5, type = "toggle",
          name = L["Scroll Bar"], desc = L["Hides the scroll bar"],
          set = function(info, v)
            db.scrollbar = v
            Buttons:UpdateScrollBar()
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

  local options = self:GetOptions()
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
  self:UpdateClock()
  self:UpdateGarrison()
  self:UpdateInstance()
  self:UpdateLFG()
  self:UpdateMail()
  self:UpdateTracking()
  self:UpdateVoice()
  self:UpdateWorld()
  self:UpdateZoom()

  self:UpdateChannel()
  self:UpdateMenu()
  self:UpdateQuickjoin()
  self:UpdateChatVoice()
  self:UpdateScrollBar()
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

function Buttons:UpdateClock()
  if (db.clock == nil) then return end

  local TimeManagerClockButton = _G.TimeManagerClockButton

  if db.clock and Buttons:IsEnabled() then
    TimeManagerClockButton:Hide()
    TimeManagerClockButton.Show = dummy
  else
    TimeManagerClockButton.Show = nil
    TimeManagerClockButton:Show()

    db.clock = nil
  end
end

function Buttons:UpdateGarrison()
  if (db.garrison == nil) then return end

  local GarrisonLandingPageMinimapButton = _G.GarrisonLandingPageMinimapButton

  if db.garrison and Buttons:IsEnabled() then
    GarrisonLandingPageMinimapButton:Hide()
    GarrisonLandingPageMinimapButton.Show = dummy
  else
    GarrisonLandingPageMinimapButton.Show = nil

    db.garrison = nil
  end
end

function Buttons:UpdateInstance()
  if (db.instance == nil) then return end

  local IsInInstance = IsInInstance
  local MiniMapInstanceDifficulty = _G.MiniMapInstanceDifficulty

  if db.instance and Buttons:IsEnabled() then
    MiniMapInstanceDifficulty:Hide()
    MiniMapInstanceDifficulty.Show = dummy
  else
    MiniMapInstanceDifficulty.Show = nil
    local inInstance, _ = IsInInstance()
    if inInstance then
      MiniMapInstanceDifficulty:Show()
    end
    db.instance = nil
  end
end

function Buttons:UpdateLFG()
  if (db.lfg == nil) then return end

  local GetLFGMode = GetLFGMode
  local NUM_LE_LFG_CATEGORYS = NUM_LE_LFG_CATEGORYS
  local QueueStatusMinimapButton = _G.QueueStatusMinimapButton

  if db.lfg and Buttons:IsEnabled() then
    for i=1, NUM_LE_LFG_CATEGORYS do
      local mode, submode = GetLFGMode(i)
      if (mode == "queued") then
        QueueStatusMinimapButton:Hide()
        QueueStatusMinimapButton.Show = dummy
      end
    end
  else
    for i=1, NUM_LE_LFG_CATEGORYS do
      local mode, submode = GetLFGMode(i)
      if (mode == "queued") then
        QueueStatusMinimapButton.Show = nil
        QueueStatusMinimapButton:Show()
      end
    end
    db.lfg = nil
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
    end
  else
    if HasNewMail() then
      MiniMapMailFrame.Show = nil
      MiniMapMailFrame:Show()
    end
    db.mail = nil
  end
end

function Buttons:UpdateTracking()
  if (db.tracking == nil) then return end

  local MiniMapTracking = _G.MiniMapTracking

  if db.tracking and Buttons:IsEnabled() then
    MiniMapTracking:Hide()
    MiniMapTracking.Show = dummy
  else
    MiniMapTracking.Show = nil
    MiniMapTracking:Show()

    db.tracking = nil
  end
end

function Buttons:UpdateVoice()
  if (db.voice == nil) then return end

  local MiniMapVoiceChatFrame = _G.MiniMapVoiceChatFrame

  if db.voice and Buttons:IsEnabled() then
    if MiniMapVoiceChatFrame then
      MiniMapVoiceChatFrame:Hide()
      MiniMapVoiceChatFrame.Show = dummy
    end
  else
    if MiniMapVoiceChatFrame then
      MiniMapVoiceChatFrame.Show = nil
      MiniMapVoiceChatFrame:Show()
    end
    db.voice = nil
  end
end

function Buttons:UpdateWorld()
  if (db.world == nil) then return end

  local MiniMapWorldMapButton = _G.MiniMapWorldMapButton

  if db.world and Buttons:IsEnabled() then
    MiniMapWorldMapButton:Hide()
    MiniMapWorldMapButton.Show = dummy
  else
    MiniMapWorldMapButton.Show = nil
    MiniMapWorldMapButton:Show()

    db.world = nil
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

function Buttons:UpdateQuickjoin()
  if (db.quickjoin == nil) then return end

  local QuickJoinToastButton = _G.QuickJoinToastButton

  if db.quickjoin and Buttons:IsEnabled() then
    if QuickJoinToastButton then
      QuickJoinToastButton:Hide()
      QuickJoinToastButton.Show = dummy
    end
  else
    if QuickJoinToastButton then
      QuickJoinToastButton.Show = nil
      QuickJoinToastButton:Show()
    end
    db.quickjoin = nil
  end
end

function Buttons:UpdateChatVoice()
  if (db.chatvoice == nil) then return end

  local ChatFrameToggleVoiceDeafenButton = _G.ChatFrameToggleVoiceDeafenButton

  if db.chatvoice and Buttons:IsEnabled() then
    if ChatFrameToggleVoiceDeafenButton then
      ChatFrameToggleVoiceDeafenButton:Hide()
      ChatFrameToggleVoiceDeafenButton.Show = dummy
    end
  else
    ChatFrameToggleVoiceDeafenButton.Show = nil

    db.chatvoice = nil
  end
end

function Buttons:UpdateScrollBar()
  if (db.scrollbar == nil) then return end

  if db.scrollbar and Buttons:IsEnabled() then
    hooksecurefunc('FCF_FadeInScrollbar', function(chatFrame)
      if chatFrame.ScrollBar and chatFrame.ScrollBar:IsShown() then
        UIFrameFadeIn(chatFrame.ScrollBar, CHAT_FRAME_FADE_TIME, chatFrame.ScrollBar:GetAlpha(), 0)
        if chatFrame.ScrollToBottomButton then
          UIFrameFadeIn(chatFrame.ScrollToBottomButton, .1, chatFrame.ScrollToBottomButton:GetAlpha(), 1)
        end
      end
    end)

    hooksecurefunc('FCF_FadeOutScrollbar', function(chatFrame)
      if chatFrame.ScrollBar and chatFrame.ScrollBar:IsShown() then
        UIFrameFadeOut(chatFrame.ScrollBar, CHAT_FRAME_FADE_OUT_TIME, chatFrame.ScrollBar:GetAlpha(), 0)
        if chatFrame.ScrollToBottomButton then
          if UIFrameIsFlashing(chatFrame.ScrollToBottomButton.Flash) then
            UIFrameFadeRemoveFrame(chatFrame.ScrollToBottomButton)
            chatFrame.ScrollToBottomButton:SetAlpha(1);
          else
            UIFrameFadeOut(chatFrame.ScrollToBottomButton, CHAT_FRAME_FADE_OUT_TIME, chatFrame.ScrollToBottomButton:GetAlpha(), 0)
          end
        end
      end
    end)
  else
    hooksecurefunc('FCF_FadeInScrollbar', function(chatFrame)
      if chatFrame.ScrollBar and chatFrame.ScrollBar:IsShown() then
        UIFrameFadeIn(chatFrame.ScrollBar, CHAT_FRAME_FADE_TIME, chatFrame.ScrollBar:GetAlpha(), 0.6)
        if chatFrame.ScrollToBottomButton then
          UIFrameFadeIn(chatFrame.ScrollToBottomButton, .1, chatFrame.ScrollToBottomButton:GetAlpha(), 1)
        end
      end
    end)

    hooksecurefunc('FCF_FadeOutScrollbar', function(chatFrame)
      if chatFrame.ScrollBar and chatFrame.ScrollBar:IsShown() then
        UIFrameFadeOut(chatFrame.ScrollBar, CHAT_FRAME_FADE_OUT_TIME, chatFrame.ScrollBar:GetAlpha(), 0)
        if chatFrame.ScrollToBottomButton then
          if UIFrameIsFlashing(chatFrame.ScrollToBottomButton.Flash) then
            UIFrameFadeRemoveFrame(chatFrame.ScrollToBottomButton)
            chatFrame.ScrollToBottomButton:SetAlpha(1);
          else
            UIFrameFadeOut(chatFrame.ScrollToBottomButton, CHAT_FRAME_FADE_OUT_TIME, chatFrame.ScrollToBottomButton:GetAlpha(), 0)
          end
        end
      end
    end)
    db.scrollbar = nil
  end
end
