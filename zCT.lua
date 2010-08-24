--[[
Big Thanks to ALZA and his awesome LightCT, this addon is based on it.
Thanks to Shestak for showing me LightCT and inspiring me to make this mod.
]]

--Hide options we do not support for now.
InterfaceOptionsCombatTextPanelFriendlyHealerNames:Hide()

local zCT_Frames = {}
local zCT_Font = "Interface\\AddOns\\zCT\\font.ttf"
local zCT_DamageFontHeight = 25 --This number just inreases font quality.

--Set unit damage and healing font
local function zCT_SetDamageFont()
	DAMAGE_TEXT_FONT = zCT_Font
	COMBAT_TEXT_HEIGHT = zCT_DamageFontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = zCT_DamageFontHeight + 20
	COMBAT_TEXT_CRIT_MINHEIGHT = zCT_DamageFontHeight - 20
--	CombatTextFont:SetFont(zCT_Font, zCT_DamageFontHeight,"OUTLINE")
end
--zCT_SetDamageFont()

--[[My fancy debugging printer, feel free to remove.
local debugprint = function(msg)
    print("|cffC495DDz|rCT debug:", tostring(msg))
end]]


local zCT_Damage = CreateFrame("ScrollingMessageFrame", "zCT_Damage", UIParent)
zCT_Damage:SetFont(zCT_Font, 18, "OUTLINE")
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
zCT_Heal:SetFont(zCT_Font, 18, "OUTLINE")
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
zCT_Text:SetFont(zCT_Font, 20, "OUTLINE")
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

local zCT_Events = {}
local function zCT_OnLoad()
	if tonumber(_G["SHOW_COMBAT_TEXT"]) == 1 then
		--debugprint("Enabling basic CT (damage/heal/procs)")
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
		--debugprint("enabling auras")
		zCT_Events["SPELL_AURA_START"] = {frame = 3, prefix = "+", arg2 = true, r = 1, g = .5, b = .5}
		zCT_Events["SPELL_AURA_END"] = {frame = 3, prefix = "-", arg2 = true, r = .5, g = .5, b = .5}
		zCT_Events["SPELL_AURA_START_HARMFUL"] = {frame = 1, prefix = "+", arg2 = true, r = 1, g = .1, b = .1}
		zCT_Events["SPELL_AURA_END_HARMFUL"] = {frame = 1, prefix = "-", arg2 = true, r = .1, g = 1, b = .1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_DODGE_PARRY_MISS"]) == 1 then
		--debugprint("enabling dodge,parry,miss")
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
		--debugprint("Enabling resists")
		zCT_Events["RESIST"] = {frame = 1, prefix = "Resist", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["BLOCK"] = {frame = 1, prefix = "Block", 	spec = true,		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["ABSORB"] = {frame = 1, prefix = "Absorb", 	spec = true, 		r = 1, 		g = 0.1, 	b = 0.1}
		zCT_Events["SPELL_RESIST"] = {frame = 1, prefix = "Resist", spec = true, r = 0.79, g = 0.3, b = 0.85}
		--Spell Block
		zCT_Events["SPELL_ABSORB"] = {frame = 1, prefix = "Absorb", spec = true, r = 0.79, g = 0.3, b = 0.85}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_ENERGIZE"]) == 1 then
		--debugprint("Enabling energize")
		zCT_Events["ENERGIZE"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE"]) == 1 then
		--debugprint("Enabling periodic energize")
		zCT_Events["PERIODIC_ENERGIZE"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_HONOR_GAINED"]) == 1 then
		--debugprint("Enabling honor display")
		zCT_Events["HONOR_GAINED"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_REPUTATION"]) == 1 then
		--debugprint("Enabling rep display")
		zCT_Events["FACTION"] = {frame = 3, prefix = "+", arg2 = true, r = .1, g = .1, b = 1}
	end
	if tonumber(_G["COMBAT_TEXT_SHOW_REACTIVES"]) == 1 then
		--debugprint("Enabling reactive abilities")
		zCT_Events["SPELL_ACTIVE"] = {frame = 3, prefix = "+", arg2 = true, r = 1, g = .82, b = 0}
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


CombatText:SetScript("OnEvent", zCT_OnEvent)
--Register shit and some events that don't fire in COMBAT_TEXT_UPDATE
local frame, events = CreateFrame("Frame"), {};
function events:PLAYER_ENTERING_WORLD(...)
	zCT_OnLoad()
end
function events:PLAYER_REGEN_ENABLED(...)
	if tonumber(_G["COMBAT_TEXT_SHOW_COMBAT_STATE"]) == 1 then
		zCT_Text:AddMessage("-"..LEAVING_COMBAT,.1,1,.1)
	end
end
function events:PLAYER_REGEN_DISABLED(...)
	if tonumber(_G["COMBAT_TEXT_SHOW_COMBAT_STATE"]) == 1 then
		zCT_Text:AddMessage("+"..ENTERING_COMBAT,1,.1,.1)
	end
end
function events:UNIT_COMBO_POINTS(...)
	if tonumber(_G["COMBAT_TEXT_SHOW_COMBO_POINTS"]) == 1 then
		local unit = ...;
		if ( unit == "player" ) then
			local comboPoints = GetComboPoints("player", "target");
			if ( comboPoints > 0 ) then
				messageType = "COMBO_POINTS";
				data = comboPoints;
				r, g, b = 1, .82, .0
				
				-- Show message as a crit if max combo points
				if ( comboPoints == MAX_COMBO_POINTS ) then
					r, g, b = 0, .82, 1
				end
				zCT_Text:AddMessage(format(COMBAT_TEXT_COMBO_POINTS,data),r ,g ,b)
			else
				return;
			end
		else
			return;
		end
	end
end
function events:UNIT_MANA(...)
	if tonumber(_G["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"]) == 1 then
		if ( arg1 == "player" ) then
			local powerType, powerToken = UnitPowerType("player");
			if ( powerToken == "MANA" and (UnitPower("player") / UnitPowerMax("player")) <= COMBAT_TEXT_LOW_MANA_THRESHOLD ) then
				if ( not CombatText.lowMana ) then
					messageType = "MANA_LOW";
					zCT_Text:AddMessage(MANA_LOW,1,.1,.1);
					CombatText.lowMana = 1;
				end
			else
				CombatText.lowMana = nil;
			end
			if ( not messageType ) then
				return;
			end
			
		end
	end
end
function events:UNIT_HEALTH(...)
	if tonumber(_G["COMBAT_TEXT_SHOW_LOW_HEALTH_MANA"]) == 1 then
		if ( arg1 == "player" ) then
			if ( UnitHealth("player")/UnitHealthMax("player") <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD ) then
				if ( not CombatText.lowHealth ) then
					messageType = "HEALTH_LOW";
					zCT_Text:AddMessage(HEALTH_LOW,1,.1,.1);
					CombatText.lowHealth = 1;
				end
			else
				CombatText.lowHealth = nil;
			end
		end
		if ( not messageType ) then
			return;
		end
	end
end		
frame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);
for k, v in pairs(events) do
	frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end


