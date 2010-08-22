--[[
Big Thanks to ALZA and his awesome LightCT, this addon is based on it.
Thanks to Shestak for showing me LightCT and inspiring me to make this mod.
]]

local zCT_Frames = {}
local zCT_Font = "Interface\\AddOns\\zCT\\font.ttf"
local zCT_Damage = CreateFrame("ScrollingMessageFrame", "zCT_Damage", UIParent)
zCT_Damage:SetFont(zCT_Font, 16, "OUTLINE")
zCT_Damage:SetShadowColor(0, 0, 0, 0)
zCT_Damage:SetFadeDuration(0.2)
zCT_Damage:SetInsertMode"TOP"
zCT_Damage:SetTimeVisible(3)
zCT_Damage:SetMaxLines(192)
zCT_Damage:SetSpacing(1)
zCT_Damage:SetWidth(128)
zCT_Damage:SetHeight(192)
zCT_Damage:SetJustifyH("LEFT")
zCT_Damage:SetPoint("CENTER", -384, -192)
zCT_Frames[1] = zCT_Damage

local zCT_Heal = CreateFrame("ScrollingMessageFrame", "zCT_Heal", UIParent)
zCT_Heal:SetFont(zCT_Font, 16, "OUTLINE")
zCT_Heal:SetShadowColor(0, 0, 0, 0)
zCT_Heal:SetFadeDuration(0.2)
zCT_Heal:SetInsertMode"TOP"
zCT_Heal:SetTimeVisible(3)
zCT_Heal:SetMaxLines(192)
zCT_Heal:SetSpacing(1)
zCT_Heal:SetWidth(128)
zCT_Heal:SetHeight(192)
zCT_Heal:SetJustifyH("RIGHT")
zCT_Heal:SetPoint("CENTER", -256, -192)
zCT_Frames[2] = zCT_Heal

local zCT_Text = CreateFrame("ScrollingMessageFrame", "zCT_Text", UIParent)
zCT_Text:SetFont(zCT_Font, 16, "OUTLINE")
zCT_Text:SetShadowColor(0, 0, 0, 0)
zCT_Text:SetFadeDuration(0.2)
zCT_Text:SetInsertMode"TOP"
zCT_Text:SetTimeVisible(3)
zCT_Text:SetMaxLines(256)
zCT_Text:SetSpacing(1)
zCT_Text:SetWidth(512)
zCT_Text:SetHeight(256)
zCT_Text:SetJustifyH("CENTER")
zCT_Text:SetPoint("CENTER", 0, 192)
zCT_Frames[3] = zCT_Text

zCT_Events = {
--[[	["ENTERING_COMBAT"] =	{frame = 3, prefix = "+", 	arg2 = true, 		r = 1,		g = .1,		b = .1},
	["LEAVING_COMBAT"] =	{frame = 3, prefix = "-", 	arg2 = true, 		r = 1,		g = .1,		b = .1},
	
	["HONOR_GAINED"] =	{frame = 3, prefix = "+", 	arg2 = true, 		r = .1,		g = .1,		b = 1},
	["FACTION"] =		{frame = 3, prefix = "+", 	arg2 = true, 		r = .1,		g = .1,		b = 1},]]
}
function zCT_OnLoad()
--	LoadAddOn("Blizzard_CombatText")
	if tonumber(_G["SHOW_COMBAT_TEXT"]) == 1 then
		print("Enabling basic combattext (damage/heal/reactive abilities)")
		zCT_Events["DAMAGE"] = {frame = 1, prefix =  "-", arg2 = true, r = 1, g = 0.1, b = 0.1}
		zCT_Events["DAMAGE_CRIT"] = {frame = 1, prefix = "c-", arg2 = true, r = 1, g = 0.1, b = 0.1}
		zCT_Events["SPELL_DAMAGE"] = {frame = 1, prefix =  "-",	arg2 = true, r = 0.79, g = 0.3, b = 0.85}
		zCT_Events["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "c-", arg2 = true, r = 0.79, g = 0.3, b = 0.85}
		zCT_Events["HEAL"] = {frame = 2, prefix =  "+",	arg3 = true, r = 0.1, g = 1, b = 0.1}
		zCT_Events["HEAL_CRIT"] = {frame = 2, prefix = "c+", arg3 = true, r = 0.1, g = 1, b = 0.1}
		zCT_Events["PERIODIC_HEAL"] = {frame = 2, prefix =  "+", arg3 = true, r = 0.1, g = 1, b = 0.1}
		zCT_Events["SPELL_CAST"] = {frame = 3, prefix = "+", arg2 = true, r = 1, g = .82, b = 0}

	end
	if tonumber(_G["COMBAT_TEXT_SHOW_AURAS"]) == 1 then
		print("enabling auras")
		zCT_Events["SPELL_AURA_START"] = {frame = 3, prefix = "+", arg2 = true, r = 1, g = .5, b = .5}
		zCT_Events["SPELL_AURA_END"] = {frame = 3, prefix = "-", arg2 = true, r = .5, g = .5, b = .5}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"]) == 1 then
		print("enabling dodge,parry,miss")
		zCT_Events["MISS"] = {frame = 1, prefix = "Miss", r = 1, g = .1, b = .1}
		zCT_Events["DODGE"] = {frame = 1, prefix = "Dodge", r = 1, g = .1, b = .1}
		zCT_Events["PARRY"] = {frame = 1, prefix = "Parry", r = 1, g = .1, b = .1}
		--Evade
		--Immune
		--Deflect
		--Reflect
		zCT_Events["SPELL_MISS"] = {frame = 1, prefix = "Miss", r = .79, g = .3, b = .85}
		--Spell Dodge
		--Spell Parry
		--Spell Evade
		--Spell Immune
		--Spell Deflect
		zCT_Events["SPELL_REFLECT"] = {frame = 1, prefix = "Reflect", r = 1, g = 1, b = 1}
	end
	if  tonumber(_G["COMBAT_TEXT_SHOW_RESISTANCES"]) == 1 then
		print("Enabling resists")
		zCT_Events["RESIST"] = {frame = 1, prefix = "Resist", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["BLOCK"] = {frame = 1, prefix = "Block", 	spec = true,		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["ABSORB"] = {frame = 1, prefix = "Absorb", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["SPELL_RESIST"] = {frame = 1, prefix = "Resist", spec = true, r = 0.79, g = 0.3, b = 0.85}
		--Spell Block
		zCT_Events["SPELL_ABSORBED"] = {frame = 1, prefix = "Absorb", spec = true, r = 0.79, g = 0.3, b = 0.85}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_ENERGIZE"]) == 1 then
		print("Enabling energize")
		zCT_Events["ENERGIZE"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"]) == 1 then
		print("Enabling periodic energize")
		zCT_Events["ENERGIZE"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end

end
local info
local template = "-%s (%s)"
Blizzard_CombatText_OnEvent = zCT_OnEvent
local function zCT_OnEvent(self, event, type, arg2, arg3)
	info = zCT_Events[type]
	if(info) then
		local msg = info.prefix or ""
		if(info.spec) then
			if(arg3) then
				msg = template:format(arg2, arg3)
			end
		else 
			if(info.arg2) then msg = msg..arg2 end
			if(info.arg3) then msg = msg..arg3 end
			
		end
		zCT_Frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end

-- Override Blizz CT fuction to redirect messages from other addons to zCT_Text frame.

Blizzard_CombatText_AddMessage = CombatText_AddMessage
function CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
zCT_Text:AddMessage(message,r,g,b)
end

local zCT = CreateFrame"Frame"
zCT:RegisterEvent"PLAYER_ENTERING_WORLD"
zCT:SetScript("OnEvent", zCT_OnLoad)
CombatText:SetScript("OnEvent", zCT_OnEvent)


