--[[	HideBlizzard	]]

local format = string.format
local pairs = pairs
local tonumber = tonumber
local type = type
local wipe = table.wipe

----------------------

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetAddOnMetadata = GetAddOnMetadata
local InCombatLockdown = InCombatLockdown

----------------------

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):NewAddon(addonName)
HideBlizzard:SetDefaultModuleState(false)
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard", "enUS", true)
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

local addon = HideBlizzard
local addon_debug = false
local addon_prefix = "|cffAEAEE0"..addonName..":|r"
local addon_version = GetAddOnMetadata(addonName, "Version")

----------------------

local moduleOptions = {}
local options = nil
local settings
local defaults = {
	profile = {
		modules = {
			["*"] = false,
		},
	},
}

----------------------

local function debug_out(...)
	if (addon_debug) then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", addon_prefix, ...), 1, 0, 0)
	end
end

local function out(...)
	DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", addon_prefix, ...))
end

----------------------

local function SetupOptions()
	debug_out("SetupOptions")

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
							order = 1, type = "description", fontSize = "medium",
							width = "half",
							name = format("%s %.2f", L["Version:"], addon_version),
						},
						reset = {
							order = 2, type = "execute", func = function() wipe(HideBlizzardDB); ReloadUI() end, confirm = true,
							width = "half",
							name = L["Reset"],
							desc = format("|cffff0000%s|r", L["This will wipe all settings and reload the user interface."]),
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

----------------------

function addon:OpenOptions()
	debug_out("OpenOptions")

	if (not InCombatLockdown()) then
		ACD:SetDefaultSize("HideBlizzard", 825, 575)
		ACD:Open("HideBlizzard")
	else
		ACD:Close("HideBlizzard")
		out(format("|cffFF6666%s", L["Cannot open options while in combat."]))
	end
end

----------------------

function addon:OnInitialize()
	debug_out("OnInitialize")

	addon.db = LibStub("AceDB-3.0"):New(addonName.."DB", defaults)
	settings = addon.db.profile

	self:Updater()

	ACR:RegisterOptionsTable(addonName, SetupOptions)

	SlashCmdList[addonName] = function()
		self:OpenOptions()
	end
	SLASH_HideBlizzard1 = "/hideblizz"
end

----------------------

function addon:OnEnable()
	debug_out("OnEnable")

	self:UpdateModules()
end

----------------------

function addon:OnDisable()
	debug_out("OnDisable")
end

----------------------

function addon:Updater()
	debug_out("Updater")

	if (not HideBlizzardDB.version) then
		out(L["Welcome! Type /hideblizz to configure."])
		HideBlizzardDB.version = tonumber(addon_version)
	elseif (HideBlizzardDB.version ~= tonumber(addon_version)) then
		HideBlizzardDB.version = tonumber(addon_version)
		out(L["Updated to latest version"])
	end
end

----------------------

function addon:RegisterModuleOptions(name, optionTbl, displayName)
	debug_out("RegisterModuleOptions")

	moduleOptions[name] = optionTbl
end

----------------------

function addon:GetModuleEnabled(module)
	debug_out("GetModuleEnabled")

	return settings.modules[module]
end

----------------------

function addon:SetModuleEnabled(module, value)
	debug_out("SetModuleEnabled")

	local old = settings.modules[module]
	settings.modules[module] = value

	if (old ~= value) then
		if (value) then
			self:EnableModule(module)
		else
			self:DisableModule(module)
		end
	end
end

----------------------

function addon:UpdateModules()
	debug_out("UpdateModules")

	for k,v in self:IterateModules() do
		if (self:GetModuleEnabled(k) and not v:IsEnabled()) then
			self:EnableModule(k)
		elseif (not self:GetModuleEnabled(k) and v:IsEnabled()) then
			self:DisableModule(k)
		end
	end
end
