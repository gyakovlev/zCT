--[[
Big Thanks to ALZA and his awesome LightCT, this addon is heavily based on it.
Thanks to Shestak for showing me LightCT and inspiring me to make this mod.
]]
local zCT_Frames = {}
local zCT_Font
local zCT_Damage = CreateFrame("ScrollingMessageFrame", "zCT_Damage", UIParent)
zCT_Damage:SetFont("Fonts\\hooge.ttf", 16, "OUTLINE")
zCT_Damage:SetShadowColor(0, 0, 0, 0)
zCT_Damage:SetFadeDuration(0.2)
zCT_Damage:SetInsertMode"TOP"
zCT_Damage:SetTimeVisible(3)
zCT_Damage:SetMaxLines(150)
zCT_Damage:SetSpacing(1)
zCT_Damage:SetWidth(150)
zCT_Damage:SetHeight(150)
zCT_Damage:SetJustifyH("LEFT")
zCT_Damage:SetPoint("CENTER", 0, 90)
zCT_Frames[1] = zCT_Damage

local zCT_Heal = CreateFrame("ScrollingMessageFrame", "zCT_Heal", UIParent)
zCT_Heal:SetFont("Fonts\\hooge.ttf", 16, "OUTLINE")
zCT_Heal:SetShadowColor(0, 0, 0, 0)
zCT_Heal:SetFadeDuration(0.2)
zCT_Heal:SetInsertMode"TOP"
zCT_Heal:SetTimeVisible(3)
zCT_Heal:SetMaxLines(150)
zCT_Heal:SetSpacing(1)
zCT_Heal:SetWidth(150)
zCT_Heal:SetHeight(150)
zCT_Heal:SetJustifyH("LEFT")
zCT_Heal:SetPoint("CENTER", 0, -90)
zCT_Frames[2] = zCT_Heal

local zCT_Text = CreateFrame("ScrollingMessageFrame", "zCT_Text", UIParent)
zCT_Text:SetFont("Fonts\\hooge.ttf", 16, "OUTLINE")
zCT_Text:SetShadowColor(0, 0, 0, 0)
zCT_Text:SetFadeDuration(0.2)
zCT_Text:SetInsertMode"TOP"
zCT_Text:SetTimeVisible(3)
zCT_Text:SetMaxLines(150)
zCT_Text:SetSpacing(1)
zCT_Text:SetWidth(400)
zCT_Text:SetHeight(140)
zCT_Text:SetJustifyH("CENTER")
zCT_Text:SetPoint("CENTER", 0, 0)
zCT_Frames[3] = zCT_Text

local tbl = {
	["DAMAGE"] = 		{frame = 1, prefix =  "-",	arg2 = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 	{frame = 1, prefix = "c-",	arg2 = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 	{frame = 1, prefix =  "-",	arg2 = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "c-",	arg2 = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["MISS"] = 		{frame = 1, prefix = "Miss", 				r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 	{frame = 1, prefix = "Miss", 				r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = 1, prefix = "Reflect", 			r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 		{frame = 1, prefix = "Dodge", 				r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 		{frame = 1, prefix = "Parry", 				r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 		{frame = 1, prefix = "Block", 	spec = true,		r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 		{frame = 1, prefix = "Resist", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 	{frame = 1, prefix = "Resist", 	spec = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 		{frame = 1, prefix = "Absorb", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = 1, prefix = "Absorb", 	spec = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 		{frame = 2, prefix =  "+",	arg3 = true, 		r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 	{frame = 2, prefix = "c+",	arg3 = true, 		r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = 2, prefix =  "+",	arg3 = true, 		r = 0.1, 	g = 1, 		b = 0.1},

	["SPELL_AURA_START"] =	{frame = 3, prefix = "+", 	arg2 = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_AURA_END"] =	{frame = 3, prefix = "-", 	arg2 = true, 		r = 0.79, 	g = 0.3, 	b = 0.85},
}

local info
local template = "-%s (%s)"
Blizzard_CombatText_OnEvent = CombatText_OnEvent

local function zCT_OnEvent(self, event, subev, arg2, arg3)
	info = tbl[subev]
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

Blizzard_CombatText_AddMessage = CombatText_AddMessage

-- Override of Blizz CT fuction to redirect messages from other addons to zCT_Text frame.

function CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
zCT_Text:AddMessage(message,r,g,b)
end

CombatText:SetScript("OnEvent",zCT_OnEvent)
