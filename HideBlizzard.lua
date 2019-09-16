local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):NewAddon(addonName)
HideBlizzard:SetDefaultModuleState(false)
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard", "enUS")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

local moduleOptions = {}
local options = nil
local defaults = {
  profile = {
    modules = {
      ["*"] = false,
    },
  },
}

local function SetupOptions()
  if (not options) then
    options = {
      type = "group",
      name = "HideBlizzard",
      args = {
        info = {
          order = 1, type = "group", inline = true,
          name = L["Info"],
          args = {
            version = {
              order = 1, type = "description",
              name = format("v%.2f", GetAddOnMetadata(addonName, "Version")),
            },
            reset = {
              order = 2, type = "execute", func = function() wipe(HideBlizzardDB); ReloadUI() end, confirm = true,
              name = L["Reset"], desc = format("|cffff0000%s|r", L["This will wipe all settings and reload the user interface"]),
            },
            spacer = {
              order = 2.5, type = "description",
              name = "",
            },
            feedback = {
              order = 3, type = "input", width = "double",
              name = L["Feedback"],
              get = function() return "https://github.com/Gendr/HideBlizzard/issues" end,
            },
          },
        },
      },
    }
    for k,v in pairs(moduleOptions) do
      options.args[k] = type(v) == "function" and v() or v
    end
  end
  return options
end

function HideBlizzard:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("HideBlizzardDB", defaults)

  ACR:RegisterOptionsTable(addonName, SetupOptions)
  ACD:AddToBlizOptions("HideBlizzard", "HideBlizzard")

  SLASH_HideBlizzard1 = "/hideblizz"
  SlashCmdList["HideBlizzard"] = function()
    if InCombatLockdown() then return end
    InterfaceOptionsFrame_OpenToCategory(addonName)
    InterfaceOptionsFrame_OpenToCategory(addonName)
  end
end

function HideBlizzard:OnEnable()
  self:UpdateModules()
end

function HideBlizzard:OnDisable()
end

function HideBlizzard:RegisterModuleOptions(name, optionTbl, displayName)
  moduleOptions[name] = optionTbl
end

function HideBlizzard:GetModuleEnabled(module)
  return self.db.profile.modules[module]
end

function HideBlizzard:SetModuleEnabled(module, value)
  local old = self.db.profile.modules[module]
  self.db.profile.modules[module] = value

  if (old ~= value) then
    if value then
      self:EnableModule(module)
    else
      self:DisableModule(module)
    end
  end
end

function HideBlizzard:UpdateModules()
  for k,v in self:IterateModules() do
    if self:GetModuleEnabled(k) and (not v:IsEnabled()) then
      self:EnableModule(k)
    elseif (not self:GetModuleEnabled(k)) and v:IsEnabled() then
      self:DisableModule(k)
    end
  end
end
