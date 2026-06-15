local VERSION = "1.0"
local COMMIT_HASH = "f90c97f28d146b1ad7781d13ece3860d28f7b3db"
local SHORT_COMMIT_HASH = "f90c97f"
local ProcScience = CreateFrame("Frame")
local L = ProcScience_L
local LOG_LEVEL = {
	NONE = 0,
	TRACKING = 1,
	DEBUG = 2,
	SELF = 3,
	SAY = 4,
	GROUP = 5,
}

local INVSLOT_FIRST_EQUIPPED = 1
local INVSLOT_LAST_EQUIPPED = 18

local INVSLOT_MAIN_HAND = 16
local INVSLOT_OFF_HAND = 17
local INVSLOT_RANGED = 18

local function IsWeaponSlot(slotID)
	return slotID == INVSLOT_MAIN_HAND or slotID == INVSLOT_OFF_HAND or slotID == INVSLOT_RANGED
end

local function IsMeleeWeaponSlot(slotID)
	return slotID == INVSLOT_MAIN_HAND or slotID == INVSLOT_OFF_HAND
end

function ProcScience:NewStats(attackSpeed)
	return { hits = 0, phantomHits = 0, procs = 0, gcdProc = false, attackSpeed = attackSpeed }
end

function ProcScience:ResetStats(stats)
	if not stats then
		return
	end

	stats.hits = 0
	stats.phantomHits = 0
	stats.procs = 0
	stats.gcdProc = false
end

local function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		local idx = 0
		for k,v in pairs(o) do
			local key = k
			if type(k) ~= 'number' then
				key = '"'..key..'"'
			end

			if idx > 0 then
				s = s .. ', '
			end
			s = s .. '['..key..'] = ' .. dump(v)
			idx = idx + 1
		end
		return s .. '} '
	end

	return tostring(o)
end

function ProcScience:Print(string)
	DEFAULT_CHAT_FRAME:AddMessage("|cffF0E68C[ProcScience]|cffFFFFFF: "..tostring(string))
end

function ProcScience:Dump()
	self:Print("version = "..SHORT_COMMIT_HASH)
	self:Print("player = "..dump(self.player))
	self:Print("sources = "..dump(self.sources))
	self:Print("procs = "..dump(self.tracked))
	self:Print("buff procs = "..dump(self.trackedBuffs))
end

function ProcScience:PopulateSources()
	self.sources = { Damage = {}, AreaEffect = {}, Aura = {} }
	if L[self.player.class] == nil then
		return
	end
	for k, v in pairs(L[self.player.class]) do
		if type(v) == 'table' then
			for spellName, spellID in pairs(v) do
				self.sources[k][spellName] = true
			end
		end
	end
end

local ProcScience_Prefix = "ProcScienceTooltip"
local ProcScience_Tooltip = getglobal(ProcScience_Prefix) or CreateFrame("GameTooltip", ProcScience_Prefix, nil, "GameTooltipTemplate")
ProcScience_Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

function ProcScience:GetItemTempEnchantFunc(itemInfo, slotID)
	local itemTempEnchantIDFunc = function(leftText) return end
	if IsMeleeWeaponSlot(slotID) then
		local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
		local hasTempEnchant = slotID == INVSLOT_MAIN_HAND and hasMainHandEnchant or
				slotID == INVSLOT_OFF_HAND and hasOffHandEnchant
		if hasTempEnchant then
			itemTempEnchantIDFunc = function(leftText)
				for itemTempEnchantID, procInfo in pairs(L.TemporaryEnchants) do
					local pattern = "^".. procInfo.enchantName .. " %(%d+ (%a%a%a)%)$"
					if string.find(leftText, pattern) then
						itemInfo.itemTempEnchantID = itemTempEnchantID
					end
				end
			end
		end
	end

	return itemTempEnchantIDFunc
end

function ProcScience:GetWeaponSpeedFunc(itemInfo, slotID)
	local getWeaponSpeedFunc = function(rightText) return end
	if IsWeaponSlot(slotID) then
		getWeaponSpeedFunc = function(rightText)
			local _, _, speed = string.find(rightText, "Speed (%d%.%d%d)")
			if speed then
				itemInfo.speed = tonumber(speed)
			end
		end
	end

	return getWeaponSpeedFunc
end

function ProcScience:DetectSetBonusProcs(setBonus, leftText, itemInfo)
	-- Set names are listed before bonuses
	local _,_, setName = string.find(leftText, "(.+) %(%d/%d%)")
	if setName then
		itemInfo.setName = setName
		return
	end

	for setBonusID, procInfo in pairs(L.SetBonus) do
		if string.find(leftText, "^Set: " .. procInfo.description) then
			if not setBonus[setBonusID] then
				setBonus[setBonusID] = {
					setName = itemInfo.setName or procInfo.setName,
					quality = 0,
					hex = nil,
				}
			end

			if setBonus[setBonusID].quality < itemInfo.itemQuality then
				setBonus[setBonusID].quality = itemInfo.itemQuality
				setBonus[setBonusID].hex = itemInfo.itemColorHex
			end
		end
	end
end

function ProcScience:GetItemInfo(setBonus, itemLink, slotID)
	local itemInfo = {}
	local itemID, itemEnchantID = self:GetItemIDsFromLink(itemLink)
	itemInfo.itemLink = itemLink
	itemInfo.itemID = itemID
	itemInfo.itemEnchantID = itemEnchantID
	itemInfo.slotID = slotID
	itemInfo.setName = nil

	local _, _, itemQuality = GetItemInfo(itemID)
	itemInfo.itemQuality = tonumber(itemQuality)
	local _, _, _, hex = GetItemQualityColor(itemInfo.itemQuality)
	itemInfo.itemColorHex = hex


	local setItemTempEnchantID = self:GetItemTempEnchantFunc(itemInfo, slotID)
	local setWeaponSpeed = self:GetWeaponSpeedFunc(itemInfo, slotID)

	ProcScience_Tooltip:ClearLines()
	ProcScience_Tooltip:SetInventoryItem("player", slotID)
	for i = 1, ProcScience_Tooltip:NumLines() do
		local leftText = getglobal(ProcScience_Prefix.."TextLeft"..i):GetText()
		if leftText then
			setItemTempEnchantID(leftText)
			self:DetectSetBonusProcs(setBonus, leftText, itemInfo)
		end

		-- Find weapon speed
		local rightText = getglobal(ProcScience_Prefix.."TextRight"..i):GetText()
		if rightText then
			setWeaponSpeed(rightText)
		end
	end

	return itemInfo
end

function ProcScience:GetItemIDsFromLink(itemLink)
	local foundID, _ , itemID, itemEnchantID = string.find(itemLink, "item:(%d+):(%d+)")
	if not foundID then
		return
	end

	return tonumber(itemID), tonumber(itemEnchantID)
end

function ProcScience:GetItemLink(itemID)
	local itemName, itemLink, itemQuality = GetItemInfo(itemID)
	if itemName and itemLink and itemQuality then
		local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
		local hyperLink = hex.. "|H".. itemLink .."|h["..itemName.."]|h" .. FONT_COLOR_CODE_CLOSE
		return hyperLink
	end
end

function ProcScience:DetectProc(detected, procInfo, procStats, link, procID, slotID)
	procStats.itemLink = link
	procStats.spellName = procInfo.spellName
	procStats.spellID = procInfo.spellID

	local detectedKey = procInfo.spellName
	if self.superWowActive and procInfo.superWowEvents then
		detectedKey = procInfo.spellID
	end

	if detected[detectedKey] ~= nil then
		local proc = detected[detectedKey]
		if proc.filter then
			if (proc.filter == "main hand" and slotID == INVSLOT_OFF_HAND) or (proc.filter == "off-hand" and slotID == INVSLOT_MAIN_HAND) then
				proc.filter = nil
			end
		end
	else
		local proc = { procID = procID, info = procInfo, stats = procStats }
		if slotID == INVSLOT_MAIN_HAND then
			proc.filter = "main hand"
		elseif slotID == INVSLOT_OFF_HAND then
			proc.filter = "off-hand"
		end
		detected[detectedKey] = proc
	end
end

function ProcScience:DetectTempEnchantProc(detected, itemInfo)
	local procInfo = L.TemporaryEnchants[itemInfo.itemTempEnchantID]
	if not procInfo then
		return
	end

	local procID = "tempEnchant:" .. itemInfo.itemTempEnchantID
	if ProcScienceStats.procs[procID] == nil then
		ProcScienceStats.procs[procID] = self:NewStats(itemInfo.attackSpeed)
	end

	local procStats = ProcScienceStats.procs[procID]
	local link = self:GetItemLink(procInfo.itemID)
	self:DetectProc(detected, procInfo, procStats, link, procID, itemInfo.slotID)
end


function ProcScience:DetectEnchantProc(detected, itemInfo)
	local procInfo = L.Enchants[itemInfo.itemEnchantID]
	if not procInfo then
		return
	end

	local procID = "enchant:"..itemInfo.itemEnchantID
	if ProcScienceStats.procs[procID] == nil then
		ProcScienceStats.procs[procID] = self:NewStats(itemInfo.attackSpeed)
	end

	local procStats = ProcScienceStats.procs[procID]
	local enchantLink = string.format("%s|Henchant:%s|h[%s Enchant]|h%s", HIGHLIGHT_FONT_COLOR_CODE, procInfo.enchantID, procInfo.enchantName, FONT_COLOR_CODE_CLOSE)
	self:DetectProc(detected, procInfo, procStats, enchantLink, procID, itemInfo.slotID)
end

function ProcScience:DetectItemProc(detected, itemInfo)
	local procInfo = L.Procs[itemInfo.itemID]
	if not procInfo then
		return
	end

	local procID = "item:" .. itemInfo.itemID
	if ProcScienceStats.procs[procID] == nil then
		ProcScienceStats.procs[procID] = self:NewStats(itemInfo.attackSpeed)
	end

	local procStats = ProcScienceStats.procs[procID]
	self:DetectProc(detected, procInfo, procStats, itemInfo.itemLink, procID, itemInfo.slotID)
end

function ProcScience:DetectSetBonusProc(detected, setBonusID, setBonusInfo)
	local procInfo = L.SetBonus[setBonusID]
	if not procInfo then
		return
	end

	local procID = "setBonus:" .. setBonusID
	if ProcScienceStats.procs[procID] == nil then
		ProcScienceStats.procs[procID] = self:NewStats()
	end

	local procStats = ProcScienceStats.procs[procID]
	local link = string.format("%s[%s]%s", setBonusInfo.hex, setBonusInfo.setName, FONT_COLOR_CODE_CLOSE)
	self:DetectProc(detected, procInfo, procStats, link, procID, nil)
end

function ProcScience:DetectItems()
	local detected = {}
	local setBonus = {}

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then
			local itemInfo = self:GetItemInfo(setBonus, itemLink, slotID)
			self:DetectItemProc(detected, itemInfo)
			self:DetectEnchantProc(detected, itemInfo)
			self:DetectTempEnchantProc(detected, itemInfo)
		end
	end

	for setBonusID, setBonusInfo in pairs(setBonus) do
		self:DetectSetBonusProc(detected, setBonusID, setBonusInfo)
	end

	if self.log >= LOG_LEVEL.TRACKING then
		if self.tracked ~= nil then
			for spellName, proc in pairs(detected) do
				if self.tracked[spellName] == nil or self.tracked[spellName].filter ~= proc.filter then
					self:Print("Tracking "..proc.stats.itemLink.." in "..(proc.filter or "both hands"))
				end
			end
		end
	end

	self.tracked = detected
end

function ProcScience:GetBuffName(buffIndex)
	ProcScience_Tooltip:ClearLines()
	ProcScience_Tooltip:SetPlayerBuff(buffIndex)
	local line = getglobal(ProcScience_Tooltip:GetName().."TextLeft1")
	return line:GetText()
end

function ProcScience:GetBuffProc(buffIndex)
	local buffID = GetPlayerBuffID and GetPlayerBuffID(buffIndex)
	local procInfo = L.Buffs[buffID]
	if procInfo then
		return buffID, procInfo
	end

	local buffName = self:GetBuffName(buffIndex)
	for buffID, procInfo in pairs(L.Buffs) do
		if procInfo.buffName == buffName then
			return buffID, procInfo
		end
	end
end

function ProcScience:DetectBuffProc(detected, buffIndex)
	local buffID, procInfo = self:GetBuffProc(buffIndex)
	if not procInfo then
		return
	end

	local procID = "buff:"..buffID
	if ProcScienceStats.procs[procID] == nil then
		ProcScienceStats.procs[procID] = self:NewStats()
	end

	local procStats = ProcScienceStats.procs[procID]
	local link = self:GetItemLink(procInfo.itemID)
	self:DetectProc(detected, procInfo, procStats, link, procID, nil)
end

function ProcScience:DetectBuffs()
	local detected = {}

	local buffIndex = 0
	while buffIndex > -1 do
		buffIndex = GetPlayerBuff(buffIndex, "HELPFUL")
		if buffIndex > -1 then
			self:DetectBuffProc(detected, buffIndex)
			buffIndex = buffIndex + 1
		end
	end

	if self.log >= LOG_LEVEL.TRACKING then
		if self.trackedBuffs ~= nil then
			for spellName, proc in pairs(detected) do
				if self.trackedBuffs[spellName] == nil or self.trackedBuffs[spellName].filter ~= proc.filter then
					self:Print("Tracking "..proc.stats.itemLink.." in "..(proc.filter or "both hands"))
				end
			end
		end
	end

	self.trackedBuffs = detected
end

function ProcScience:IsGCD()
	if not self.player.gcdSpellSlot then
		return false
	end

	local _, duration = GetSpellCooldown(self.player.gcdSpellSlot,0)
	return duration == 1.5
end

function ProcScience:UpdateProcHits(source, isOffHand, isPhantomStrike, amount)
	isOffHand = isOffHand or false
	amount = amount or 1
	for _, tracked in ipairs({self.tracked, self.trackedBuffs}) do
		for spellName, proc in pairs(tracked) do
			if proc.filter == nil or (proc.filter == "main hand" and not isOffHand and not self.player.disarmed) or (proc.filter == "off-hand" and isOffHand) then
				local trigger = proc.info.events.trigger
				if trigger == L.TRIGGER_ON_HIT or not self.sources.AreaEffect[source] or self.pendingAE[source] then
					if isPhantomStrike then
						proc.stats.phantomHits = proc.stats.phantomHits + 1
					else
						proc.stats.hits = proc.stats.hits + amount
					end
				end
			end
		end
	end
end

function ProcScience:CheckProcEvent(timestamp, event, unit, spellName, spellID)
	if self.log == LOG_LEVEL.DEBUG and event ~= "UNIT_CASTEVENT" then
		local target = ""
		if unit == self.player.name then
			target = "self"
		elseif unit == self.player.target then
			target = "target"
		end
		self:Print(string.format("%s %s %s unit == %s", event, tostring(spellName), tostring(unit), target))
	end

	local trackKey = spellID or spellName
	local proc = self.tracked[trackKey] or self.trackedBuffs[trackKey]
	if not proc then
		return
	end

	local events = self.superWowActive and proc.info.superWowEvents or proc.info.events
	if not events[event] then
		return
	end

	local procOnSelf = events.target == L.TARGET_SELF and (unit == self.player.name or unit == self.player.guid)
	local procOnTarget = events.target == L.TARGET_ENEMY and (unit == self.player.target or unit == self.player.targetGuid)
	if procOnSelf or procOnTarget then
		local procMessage = proc.stats.itemLink.." proced "..proc.stats.spellName

		if self.log == LOG_LEVEL.SELF then
			self:Print(procMessage)
		elseif self.log == LOG_LEVEL.SAY then
			SendChatMessage(procMessage, "SAY")
		elseif self.log == LOG_LEVEL.GROUP then
			if GetNumRaidMembers() > 0 then
				SendChatMessage(procMessage, "RAID")
			elseif GetNumPartyMembers() > 0 then
				SendChatMessage(procMessage, "PARTY")
			else
				SendChatMessage(procMessage, "SAY")
			end
		end
		proc.stats.procs = proc.stats.procs + 1
		proc.timestamp = timestamp
		if self:IsGCD() then
			proc.stats.gcdProc = true
		end

		return proc
	end

	--if (destGUID == self.player.guid or target ~= L.TARGET_SELF) and
	--		(target ~= L.TARGET_AREA_EFFECT or not proc.timestamp or proc.timestamp ~= timestamp) then
	--	local stats = proc.stats
	--	stats.procs = stats.procs + 1
	--	proc.timestamp = timestamp
	--end
end

function ProcScience:OnAddonLoaded()
	self.superWowActive = true
	if not GetPlayerBuffID or not CombatLogAdd or not SpellInfo then -- super wow specific functions
		self.superWowActive = false
	end

	self.player = {
		name = nil,
		guid = nil,
		level = 0, -- fluff. Never used
		class = nil,
		disarmed = false,
		targetName = nil,
		targetGuid = nil,
		isOffhand = false
	}

	self.tracked = {}
	self.trackedBuffs = {}
	self.pendingAE = {}

	ProcScienceStats = ProcScienceStats or { version = VERSION, log = LOG_LEVEL.TRACKING, procs = {} }
	self.log = ProcScienceStats.log or LOG_LEVEL.TRACKING

	self:Print("Loaded ("..SHORT_COMMIT_HASH..")")

	self:RegisterEvents()
end

function ProcScience:SetGlobalCooldownSpellSlot()
	if not L[self.player.class] then
		return
	end
	local gcdSpell = L[self.player.class].GCDSpell
	for i = 1, 200 do
		local spellName, _ = GetSpellName(i,0)
		if spellName == gcdSpell then
			self.player.gcdSpellSlot = i
			return
		end
	end
end

function ProcScience:OnPlayerEnteringWorld()
	local _, guid = UnitExists("player") -- superwow
	local _, unitClass = UnitClass("player")
	self.player.name = UnitName("player")
	self.player.guid = guid
	self.player.class = unitClass
	self.player.level = UnitLevel("player")
	self:PopulateSources()
	self:SetGlobalCooldownSpellSlot()
end

function ProcScience:OnTargetChanged()
	local _, targetGuid = UnitExists("target") -- superwow
	self.player.target = UnitName("target")
	self.player.targetGuid = targetGuid
end

--function ProcScience:OnCombatLogEventOrg()
--	if next(self.tracked) ~= nil then
--		local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID = CombatLogGetCurrentEventInfo()
--		if sourceGUID == self.player.guid then
--			if subEvent == "SWING_DAMAGE" then
--				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
--				self:UpdateProcHits("Melee", isOffHand)
--			elseif subEvent:find("^SPELL") ~= nil then
--				local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
--				if subEvent == "SPELL_CAST_SUCCESS" then
--					if self.sources.Aura[spellName] then
--						self:UpdateProcHits(spellName)
--					elseif self.sources.AreaEffect[spellName] then
--						self.pendingAE[spellName] = true
--					end
--				elseif subEvent == "SPELL_DAMAGE" then
--					if self.sources.Damage[spellName] then
--						self:UpdateProcHits(spellName)
--					elseif self.sources.AreaEffect[spellName] then
--						self:UpdateProcHits(spellName)
--						self.pendingAE[spellName] = false
--					else
--						self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
--					end
--				elseif subEvent == "SPELL_MISSED" then
--					if self.sources.Aura[spellName] then
--						self:UpdateProcHits(spellName, false, -1)
--					else
--						self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
--					end
--				else
--					self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
--				end
--			end
--		end
--	end
--end

function ProcScience:OnUnitCastEvent(timestamp)
	if next(self.tracked) == nil and next(self.trackedBuffs) == nil then
		return
	end

	local casterGuid = arg1
	local targetGuid = arg2
	local eventType = arg3
	local spellID = arg4
	local castDuration = arg5
	local spellName = SpellInfo(spellID)

	-- filter out auto attack spells
	if self.log == LOG_LEVEL.DEBUG and spellID ~= 6603 then
		local target = ""
		if targetGuid == self.player.guid then
			target = "self"
		elseif targetGuid == self.player.targetGuid then
			target = "target"
		end
		self:Print(string.format("%s %s %s %s unit == %s", event, spellID, spellName, targetGuid, target))
		--self:Print(format("caster: %s target: %s eventType: %s spell: %s (%s) castDuration: %s", casterGuid, targetGuid, eventType, spellName, spellID, castDuration))
	end

	if casterGuid ~= self.player.guid then
		return
	end

	if spellID == 6603 then
		self.player.isOffhand = eventType == "OFFHAND"
		return
	end

	if eventType ~= "CAST" and eventType ~= "CHANNEL" then
		return
	end

	return self:CheckProcEvent(timestamp, event, targetGuid, spellName, spellID)
end

function ProcScience:OnCombatLogEvent(timestamp)
	if next(self.tracked) == nil and next(self.trackedBuffs) == nil then
		return
	end

	-- Tracks auto attacks
	if event == "CHAT_MSG_COMBAT_SELF_HITS" then
		return self:UpdateProcHits("Melee", self.player.isOffhand)
	end

	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		local _, _, spellHit, unitHit = string.find(arg1, "Your (.+) hits (.+) for")
		local _, _, spellCrit, unitCrit = string.find(arg1, "Your (.+) crits (.+) for ")
		local spellName = spellHit or spellCrit
		local unit = unitHit or unitCrit
		if self.sources.Damage[spellName] then
			return self:UpdateProcHits(spellName, false)
		end

		local _, _, spellMiss, unitMiss = string.find(arg1, "Your (.+) missed (.+)%.")
		local _, _, spellDodge, unitDodge = string.find(arg1, "Your (.+) was dodged by (.+)%.")
		local _, _, spellParry, unitParry = string.find(arg1, "Your (.+) is parried by (.+)%.")
		local _, _, spellResist, unitResist = string.find(arg1, "Your (.+) was resisted by (.+)%.")
		local _, _, spellImmune, unitImmune = string.find(arg1, "Your (.+) failed. (.+) is immune%.")
		spellName = spellName or spellMiss or spellDodge or spellParry or spellResist or spellImmune
		unit = unit or unitMiss or unitDodge or unitParry or unitResist or unitImmune
		return self:CheckProcEvent(timestamp, event, unit, spellName)
	end

	if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
		-- Must check for stacks first to avoid adding the stack number to the spellName
		local _, _, unit, spellName, stacks = string.find(arg1, "(.+) is afflicted by (.+) %((%d+)%)%.")
		if not unit and not spellName then
			_, _, unit, spellName = string.find(arg1, "(.+) is afflicted by (.+)%.")
		end

		-- Track instant attack spells
		if self.sources.Aura[spellName] then
			return self:UpdateProcHits(spellName, false)
		end

		-- NEEDS TESTING
		--if self.sources.AreaEffect[spellName] then
		--	return self:UpdateProcHits(spellName)
		--end

		self:CheckProcEvent(timestamp, event, unit, spellName)
	end

	-- Track extra attacks from Hand of Justice or Ironfoe
	if event == "CHAT_MSG_SPELL_SELF_BUFF" then
		local _, _, spellExtraAttack = string.find(arg1, "You gain %d extra attacks? through (.+)%.")
		local _, _, spellHeal = string.find(arg1, "Your (.+) heals you for %d+")
		local _, _, spellMana = string.find(arg1, "You gain %d+ Mana from (.+)%.")
		-- Add energy

		local spellName = spellExtraAttack or spellHeal or spellMana
		return self:CheckProcEvent(timestamp, event, self.player.name, spellName)
	end

	if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		-- Must check for stacks first to avoid adding the stack number to the spellName
		local _, _, spellName, stacks = string.find(arg1, "You gain (.+) %((%d+)%)%.")
		if not spellName then
			_, _, spellName = string.find(arg1, "You gain (.+)%.")
		end
		return self:CheckProcEvent(timestamp, event, self.player.name, spellName)
	end
end


function ProcScience:OnLossOfControlEvent()
	local numEvents = C_LossOfControl.GetNumEvents()
	local locType, isDisarmed

	for i = 1, numEvents do
		locType = C_LossOfControl.GetEventInfo(i)
		if locType == "DISARM" then
			isDisarmed = true
			break
		end
	end

	if isDisarmed then
		if not self.player.disarmed and next(self.tracked) ~= nil then
			self:Print("Disarmed! stopped tracking main hand swings")
		end
		self.player.disarmed = true
	else
		if self.player.disarmed and next(self.tracked) ~= nil then
			self:Print("Resumed tracking main hand swings")
		end
		self.player.disarmed = false
	end
end

function ProcScience:CalculateProcChance(stats, hits, label)
	local chance = stats.procs / hits
	local confidence = 1.96 * math.sqrt(chance * (1 - chance) / hits)
	local output = string.format("%s %s: %d Procs: %d Chance: %.2f%% ±%.2f%%",
			stats.itemLink, label, hits, stats.procs, chance * 100, confidence * 100)

	if stats.attackSpeed and stats.attackSpeed > 0 then
		output = output..string.format(" PPM: %.3f ±%.3f",
				chance * 60 / stats.attackSpeed, confidence * 60 / stats.attackSpeed)
	end

	return output
end

function ProcScience:PrintStats(isVerbose)
	self:Print("Proc stats ("..SHORT_COMMIT_HASH.."):")
	if not next(ProcScienceStats.procs) then
		return self:Print("No data")
	end

	for procID, stats in pairs(ProcScienceStats.procs) do
		if stats.hits > 0 then
			self:Print(self:CalculateProcChance(stats, "Hits", stats.hits + stats.phantomHits))
			if isVerbose then
				self:Print(self:CalculateProcChance(stats, "True hits", stats.hits))
				self:Print(self:CalculateProcChance(stats, "Phantom hits", stats.phantomHits))
			end
		else
			return 	self:Print(string.format("%s No hits", stats.itemLink))
		end
	end
end

function ProcScience:ChangeLogLevel(msg)
	local _, _, logLevel = string.find(msg, "log (.+)")
	if logLevel == "none" then
		ProcScienceStats.log = LOG_LEVEL.NONE
		ProcScience:Print("Logging nothing")
	elseif logLevel == "debug" then
		ProcScienceStats.log = LOG_LEVEL.DEBUG
		ProcScience:Print("Logging all tracked events")
	elseif logLevel == "tracking" then
		ProcScienceStats.log = LOG_LEVEL.TRACKING
		ProcScience:Print("Logging equipping items with procs")
	elseif logLevel == "self" then
		ProcScienceStats.log = LOG_LEVEL.SELF
		ProcScience:Print("Logging each time a proc occurs privately")
	elseif logLevel == "say" then
		ProcScienceStats.log = LOG_LEVEL.SAY
		ProcScience:Print("Logging each time a proc occurs in /say")
	elseif logLevel == "group" then
		ProcScienceStats.log = LOG_LEVEL.GROUP
		ProcScience:Print("Logging each time a proc occurs in /party or /raid")
	else
		ProcScience:Print("Missing argument for log level. Usage: /procs log <none|debug|tracking|self|say|group>")
	end

	self.log = ProcScienceStats.log
end

function ProcScience:ResetAll()
	self:Print("Resetting all proc stats")
	for _, stats in pairs(ProcScienceStats.procs) do
		self:ResetStats(stats)
	end
end

function ProcScience:ResetTracked()
	self:Print("Resetting currently tracked proc stats")
	-- TODO fix this resetting
	for _, proc in pairs(self.tracked) do
		local stats = ProcScienceStats.procs[proc.procID]
		self:ResetStats(stats)
	end

	for _, proc in pairs(self.trackedBuffs) do
		local stats = ProcScienceStats.procs[proc.procID]
		self:ResetStats(stats)
	end
end

function ProcScience:Reset(item)
	local itemID = GetItemInfoInstant(item)
	if itemID ~= nil then
		local stats = ProcScienceStats.procs[itemID]
		if stats ~= nil then
			self:Print("Resetting proc stats for "..stats.itemLink)
			stats.hits = 0
			stats.procs = 0
		else
			self:Print(item.." is not tracked by ProcScience")
		end
	else
		self:Print("Could not find item ID for "..item)
	end
end

function ProcScience:OnEvent()
	local timestamp = GetTime()

	if event == "ADDON_LOADED" and arg1 == "ProcScience" then
		ProcScience:UnregisterEvent("ADDON_LOADED")
		return ProcScience:OnAddonLoaded()
	end

	if event == "PLAYER_TARGET_CHANGED" then
		return ProcScience:OnTargetChanged()
	end

	if event == "PLAYER_ENTERING_WORLD" then
		ProcScience:OnPlayerEnteringWorld()
		return ProcScience:DetectItems()
	end

	if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		return ProcScience:DetectItems()
	end

	if event == "PLAYER_AURAS_CHANGED" then
		return ProcScience:DetectBuffs()
	end

	if event == "CHAT_MSG_COMBAT_SELF_HITS" or
			event == "CHAT_MSG_SPELL_SELF_DAMAGE" or
			event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" or
			event == "CHAT_MSG_SPELL_SELF_BUFF" or
			event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		return ProcScience:OnCombatLogEvent(timestamp)
	end

	if event == "UNIT_CASTEVENT" then
		return ProcScience:OnUnitCastEvent(timestamp)
	end

	if event == "RAW_COMBATLOG" then
		--return ProcScience:Print(string.format("%s %s %s %s", event, tostring(arg1), tostring(arg2), tostring(arg3)))
	end

	if event == "LOSS_OF_CONTROL_ADDED" or event == "LOSS_OF_CONTROL_UPDATE" then
		return ProcScience:OnLossOfControlEvent()
	end
end

ProcScience:SetScript("OnEvent", ProcScience.OnEvent)
ProcScience:RegisterEvent("ADDON_LOADED")

function ProcScience:RegisterEvents()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS") -- detect my hits
	--self:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES") -- detect misses

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") -- detect spell hit, crit and resist, i.e. Fireball
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") -- detect debuff application, i.e. nightfall
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") -- detect debuff application, i.e. nightfall

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
	-- track windfury "You gain 2 extra attacks through Windfury Weapon". This one comes first
	-- track "You gain 1 extra attack through Hand of Justice."
	-- track "Your Holy Strength heals you for 116" crusader heal

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
	-- track windfury "You gain Windfury weapon" attack power buff
	-- track "You gain Holy Strength" crusader strength buff

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_AURAS_CHANGED")

	if self.superWowActive then
		self:RegisterEvent("UNIT_CASTEVENT")
		--self:RegisterEvent("RAW_COMBATLOG")
	end

	-- 1.14 events
	self:RegisterEvent("LOSS_OF_CONTROL_ADDED")
	self:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
end



SLASH_PROCS1 = "/procs"
SlashCmdList["PROCS"] = function(msg)
	if msg == "reset all" then
		ProcScience:ResetAll()
	elseif msg == "reset" then
		ProcScience:ResetTracked()
	elseif msg == "debug" then
		ProcScience:Dump()
	elseif msg == "verbose" then
		ProcScience:PrintStats(true)
	elseif msg == "" then
		ProcScience:PrintStats()
	elseif string.find(msg, "log (.+)") then
		ProcScience:ChangeLogLevel(msg)
	else
		local _, _, cmd, arg = string.find(msg, "%s?(%w+)%s?(.*)")
		if cmd == "reset" and arg ~= "" then
			ProcScience:Reset(arg)
		end
	end
end

SLASH_ReloadUI1 = "/reloadui"
SLASH_ReloadUI2 = "/reload"
SlashCmdList["ReloadUI"] = function(msg, editbox)
	ConsoleExec("reloadui")
end