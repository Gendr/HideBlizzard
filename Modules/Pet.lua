local addonName, namespace = ...

local HideBlizzard = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Pet = HideBlizzard:NewModule("Pet")
local L = LibStub("AceLocale-3.0"):GetLocale("HideBlizzard")

local dummy = function() end

local db
local defaults = {
  profile = {
    ["petactionbar"] = nil,
    ["petcastbar"] = nil,
    ["pethappiness"] = nil,
    ["partypet"] = nil,
    ["petunitframe"] = nil,
  },
}

function Pet:getOptions()
return {
  type = "group",
  name = L["Pet"],
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
      name = format("|cffFFFF55%s|r", L["Enable Pet"]),
      desc = format("|cffFFFF55%s|r", L["Hides pet related frames"]), descStyle = "inline",
      get = function() return HideBlizzard:GetModuleEnabled("Pet") end,
      set = function(info, value) HideBlizzard:SetModuleEnabled("Pet", value) end,
    },
    spacer = {
      order = 1.5, type = "description",
      name = "",
    },
    petactionbar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 2, type = "toggle",
      name = L["Pet Action Bar"], desc = L["Hides the pet action bar"],
      set = function(info, v)
        db.petactionbar = v
        self:UpdatePetActionBar()
      end,
    },
    petcastbar = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 3, type = "toggle",
      name = L["Pet Cast Bar"], desc = L["Hides the pet casting bar"],
      set = function(info, v)
        db.petcastbar = v
        self:UpdatePetCastBar()
      end,
    },
    pethappiness = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 4, type = "toggle",
      name = L["Pet Happiness Frame"], desc = L["Hides the pet happiness frame"],
      set = function(info, v)
        db.pethappiness = v
        self:UpdatePetHappiness()
      end,
    },
    partypet = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 5, type = "toggle",
      name = L["Party Pet Unit Frame"], desc = L["Hides the party pet unit frame"],
      set = function(info, v)
        db.partypet = v
        self:UpdatePartyPet()
      end,
    },
    petunitframe = {
      disabled = function() return (not self:IsEnabled()) end,
      order = 6, type = "toggle",
      name = L["Pet Unit Frame"], desc = L["Hides the pet unit frame"],
      set = function(info, v)
        db.petunitframe = v
        self:UpdatePetUnitFrame()
      end,
    },
  },
}
end

function Pet:OnInitialize()
  self:SetEnabledState(HideBlizzard:GetModuleEnabled("Pet"))
  
  self.db = HideBlizzard.db:RegisterNamespace("Pet", defaults)
  db = self.db.profile

  local options = self:getOptions()
  HideBlizzard:RegisterModuleOptions("Pet", options, "Pet")
end

function Pet:OnEnable()
  self:UpdateView()
end

function Pet:OnDisable()
  self:UpdateView()
end

function Pet:UpdateView()
  self:UpdatePetActionBar()
  self:UpdatePetCastBar()
  self:UpdatePetHappiness()
  self:UpdatePartyPet()
  self:UpdatePetUnitFrame()
end

function Pet:UpdatePetActionBar()
  if (db.petactionbar == nil) then return end

  local UnitExists = UnitExists
  local PetActionBarFrame = _G.PetActionBarFrame

  if db.petactionbar and Pet:IsEnabled() then
    if UnitExists("pet") then
      PetActionBarFrame:Hide()
      PetActionBarFrame.Show = dummy
    end
  else
    PetActionBarFrame.Show = nil
    if UnitExists("pet") then
      PetActionBarFrame:Show()
    end
    db.petactionbar = nil
  end
end

function Pet:UpdatePetCastBar()
  if (db.petcastbar == nil) then return end

  local UnitExists = UnitExists
  local PetCastingBarFrame = _G.PetCastingBarFrame

  if db.petcastbar and Pet:IsEnabled() then
    if UnitExists("pet") then
      PetCastingBarFrame:Hide()
      PetCastingBarFrame.Show = dummy
    end
  else
    PetCastingBarFrame.Show = nil

    db.petcastbar = nil
  end
end

function Pet:UpdatePetHappiness()
  if (db.pethappiness == nil) then return end

  local GetPetHappiness = GetPetHappiness
  local PetFrameHappiness = _G.PetFrameHappiness

  if db.pethappiness and Pet:IsEnabled() then
    local happiness, _, _ = GetPetHappiness()
    if UnitExists("pet") and happiness then
      PetFrameHappiness:Hide()
      PetFrameHappiness.Show = dummy
    else
      PetFrameHappiness.Show = dummy
    end
  else
    PetFrameHappiness.Show = nil
    local happiness, _, _ = GetPetHappiness()
    if UnitExists("pet") and happiness then
      PetFrameHappiness:Show()
    end
    db.pethappiness = nil
  end
end

function Pet:UpdatePartyPet()
  if (db.partypet == nil) then return end

  local GetNumSubgroupMembers = GetNumSubgroupMembers
  local GetCVarBool = GetCVarBool
  local UnitExists = UnitExists
  local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS
  local isCompact = GetCVarBool("useCompactPartyFrames")

  if db.partypet and self:IsEnabled() then
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("partypet"..i) then
          local pp = _G["PartyMemberFrame"..i.."PetFrame"]
          pp:Hide()
          pp.Show = dummy
        end
      end
    end
  else
    for i=1, MAX_PARTY_MEMBERS do
      if GetNumSubgroupMembers(i) and (isCompact == 0) then
        if UnitExists("partypet"..i) then
          local pp = _G["PartyMemberFrame"..i.."PetFrame"]
          pp.Show = nil
          pp:Show()
        end
      end
    end
    db.partypet = nil
  end
end

function Pet:UpdatePetUnitFrame()
  if (db.petunitframe == nil) then return end

  local UnitExists = UnitExists
  local PetFrame = _G.PetFrame

  if db.petunitframe and Pet:IsEnabled() then
    if UnitExists("pet") then
      PetFrame:Hide()
      PetFrame.Show = dummy
    end
  else
    PetFrame.Show = nil
    if UnitExists("pet") then
      PetFrame:Show()
    end
    db.petunitframe = nil
  end
end
