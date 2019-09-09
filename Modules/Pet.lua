--[[	Pet	]]--

local format = string.format
local tostring = tostring

----------------------

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetCVarBool = GetCVarBool
local GetNumSubgroupMembers = GetNumSubgroupMembers
local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS
local UnitExists = UnitExists

----------------------

local addonName, ns = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Pet = HideBlizzard:NewModule("Pet")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local mod = Pet
local mod_debug = false
local mod_prefix = "|cffAEAEE0"..tostring(mod)..":|r"

local dummy = function() end

----------------------
local settings
local defaults = {
	profile = {
		["petactionbar"] = nil,
		["petcastbar"] = nil,
		["partypet"] = nil,
		["petunitframe"] = nil,
	},
}

----------------------

local function debug_out(...)
	if (mod_debug) then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", mod_prefix, ...), 1, 0, 0)
	end
end

----------------------

function mod:getOptions()
debug_out("Pet getOptions")
return {
	name = L["Pet"],
	type = "group",
	arg = "Pet",
	get = function(info)

		local key = info[#info]
		local v = settings[key]

		return v

	end,
	set = function(info, value)

		local key = info[#info]

		settings[key] = value

	end,
	args = {
		enabled = {
			name = format("|cffFFFF55%s|r", L["Enable Pet"]),
			desc = format("|cffFFFF55%s|r", L["Hides pet related frames."]),
			descStyle = "inline",
			type = "toggle",
			order = 1,
			width = "full",
			get = function() return HideBlizzard:GetModuleEnabled("Pet") end,
			set = function(info, value) HideBlizzard:SetModuleEnabled("Pet", value) end,
		},
		spacer = {
			name = "",
			type = "description",
			order = 1.5,
		},
		petactionbar = {
			disabled = function() return not Pet:IsEnabled() end,
			name = L["Pet Action Bar"],
			desc = L["Hides the pet action bar."],
			type = "toggle",
			order = 2,
			set = function(info, v)
				settings.petactionbar = v
				mod:UpdatePetActionBar()
			end,
		},
		petcastbar = {
			disabled = function() return not Pet:IsEnabled() end,
			name = L["Pet Cast Bar"],
			desc = L["Hides the pet casting bar."],
			type = "toggle",
			order = 3,
			set = function(info, v)
				settings.petcastbar = v
				mod:UpdatePetCastBar()
			end,
		},
		partypet = {
			disabled = function() return not Pet:IsEnabled() end,
			name = L["Party Pet Unit Frame"],
			desc = L["Hides the party pet unit frame."],
			type = "toggle",
			order = 4,
			set = function(info, v)
				settings.partypet = v
				mod:UpdatePartyPet()
			end,
		},
		petunitframe = {
			disabled = function() return not Pet:IsEnabled() end,
			name = L["Pet Unit Frame"],
			desc = L["Hides the pet unit frame."],
			type = "toggle",
			order = 5,
			set = function(info, v)
				settings.petunitframe = v
				mod:UpdatePetUnitFrame()
			end,
		},
	},
}
end

----------------------

function mod:OnInitialize()
	debug_out("Pet OnInitialize")

	mod:SetEnabledState(HideBlizzard:GetModuleEnabled("Pet"))
	
	mod.db = HideBlizzard.db:RegisterNamespace("Pet", defaults)
	settings = mod.db.profile

	local options = mod:getOptions()
	HideBlizzard:RegisterModuleOptions("Pet", options, "Pet")
end

----------------------

function mod:OnEnable()
	debug_out("Pet OnEnable")

	mod:UpdateView()
end

----------------------

function mod:OnDisable()
	debug_out("Pet OnDisable")

	mod:UpdateView()
end

----------------------

function mod:UpdateView()
	debug_out("Pet UpdateView")

	mod:UpdatePetActionBar()
	mod:UpdatePetCastBar()
	mod:UpdatePartyPet()
	mod:UpdatePetUnitFrame()
end

----------------------

function mod:UpdatePetActionBar()
	if (settings.petactionbar == nil) then return end
	debug_out("UpdatePetActionBar")

	local PetActionBarFrame = _G.PetActionBarFrame
	if (settings.petactionbar and mod:IsEnabled()) then
		if (UnitExists("pet")) then
			PetActionBarFrame:Hide()
			PetActionBarFrame.Show = dummy
		end
	else
		PetActionBarFrame.Show = nil
		if (UnitExists("pet")) then
			PetActionBarFrame:Show()
		end
		settings.petactionbar = nil
	end
end

----------------------

function mod:UpdatePetCastBar()
	if ( settings.petcastbar == nil ) then return end
	debug_out("UpdatePetCastBar")

	local PetCastingBarFrame = _G.PetCastingBarFrame
	if (settings.petcastbar and mod:IsEnabled()) then
		if (UnitExists("pet")) then
			PetCastingBarFrame:Hide()
			PetCastingBarFrame.Show = dummy
		end
	else
		PetCastingBarFrame.Show = nil

		settings.petcastbar = nil
	end
end

----------------------

function mod:UpdatePartyPet()
	if ( settings.partypet == nil ) then return end
	debug_out("UpdatePartyPet")

	local isCompact = GetCVarBool("useCompactPartyFrames")
	if (settings.partypet and mod:IsEnabled()) then
		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i) and not isCompact) then
				local pp = _G["PartyMemberFrame"..i.."PetFrame"]
				pp:Hide()
				pp.Show = dummy
			else
				local pp = _G["PartyMemberFrame"..i.."PetFrame"]
				pp:Hide()
				pp.Show = dummy
			end
		end
	else

		for i=1, MAX_PARTY_MEMBERS do
			if (GetNumSubgroupMembers(i) and not isCompact) then
				local pp = _G["PartyMemberFrame"..i.."PetFrame"]
				pp.Show = nil
				if (UnitExists("partypet"..i)) then
					pp:Show()
				end
			else
				local pp = _G["PartyMemberFrame"..i.."PetFrame"]
				pp.Show = nil
				if (UnitExists("partypet"..i) and not isCompact) then
					pp:Show()
				end
			end
		end
		settings.partypet = nil
	end
end

----------------------

function mod:UpdatePetUnitFrame()
	if (settings.petunitframe == nil) then return end
	debug_out("UpdatePetUnitFrame")

	local PetFrame = _G.PetFrame
	if (settings.petunitframe and mod:IsEnabled()) then
		if (UnitExists("pet")) then
			PetFrame:Hide()
			PetFrame.Show = dummy
		end
	else
		PetFrame.Show = nil
		if (UnitExists("pet")) then
			PetFrame:Show()
		end
		settings.petunitframe = nil
	end
end
