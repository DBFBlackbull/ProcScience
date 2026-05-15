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

ProcScienceStats = ProcScienceStats or { version = VERSION, log = LOG_LEVEL.TRACKING, items = {}, enchants = {}, tempEnchants = {}, buffs = {} }

function ProcScience:NewStats()
	return { hits = 0, phantomHits = 0, procs = 0, gcdHits = 0, gcdProcs = 0 }
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

function ProcScience:GetAttackSpeed(slotID)
	ProcScience_Tooltip:ClearLines()
	ProcScience_Tooltip:SetInventoryItem("player", slotID)
	for i = 1, ProcScience_Tooltip:NumLines() do
		local line = getglobal(ProcScience_Prefix.."TextRight"..i)
		local text = line:GetText()
		if text then
			local _, _, speed = string.find(text, "Speed (%d%.%d%d)")
			if speed then
				return tonumber(speed)
			end
		end
	end
end

function ProcScience:GetItemTempEnchantProc(slotID)
	ProcScience_Tooltip:ClearLines()
	ProcScience_Tooltip:SetInventoryItem("player", slotID)
	for i = 1, ProcScience_Tooltip:NumLines() do
		local line = getglobal(ProcScience_Prefix.."TextLeft"..i)
		local text = line:GetText()
		if text then
			for tempEnchantName, proc in pairs(L.TemporaryEnchants) do
				local pattern = "^" .. tempEnchantName .. " %(%d+ min%)$"
				local found = string.find(text, pattern)
				if found then
					return tempEnchantName, proc
				end
			end
		end
	end
end

function ProcScience:GetItemIDFromLink(itemLink)
	local foundID, _ , itemID = string.find(itemLink, "item:(%d+)")
	if not foundID then
		return
	end

	return tonumber(itemID)
end

function ProcScience:GetItemEnchantIDFromLink(itemLink)
	local foundID, _ , itemEnchantID = string.find(itemLink, "item:%d+:(%d+)")
	if not foundID then
		return
	end

	return tonumber(itemEnchantID)
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
	if IsWeaponSlot(slotID) then
		procStats.attackSpeed = ProcScience:GetAttackSpeed(slotID)
	end
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
		local proc = { itemID = procID, info = procInfo, stats = procStats }
		if slotID == INVSLOT_MAIN_HAND then
			proc.filter = "main hand"
		elseif slotID == INVSLOT_OFF_HAND then
			proc.filter = "off-hand"
		end
		detected[detectedKey] = proc
	end
end

function ProcScience:DetectTempEnchantProc(detected, itemLink, slotID)
	local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
	local hasTempEnchant = slotID == INVSLOT_MAIN_HAND and hasMainHandEnchant or
							slotID == INVSLOT_OFF_HAND and hasOffHandEnchant
	if not hasTempEnchant then
		return
	end

	local itemTempEnchantName, procInfo = self:GetItemTempEnchantProc(slotID)
	if not itemTempEnchantName then
		return
	end

	if ProcScienceStats.tempEnchants[itemTempEnchantName] == nil then
		ProcScienceStats.tempEnchants[itemTempEnchantName] = self:NewStats()
	end

	local procStats = ProcScienceStats.tempEnchants[itemTempEnchantName]
	local link = self:GetItemLink(procInfo.itemID)
	self:DetectProc(detected, procInfo, procStats, link, itemTempEnchantName, slotID)
end


function ProcScience:DetectEnchantProc(detected, itemLink, slotID)
	local itemEnchantID = self:GetItemEnchantIDFromLink(itemLink)
	local procInfo = L.Enchants[itemEnchantID]
	if not procInfo then
		return
	end

	if ProcScienceStats.enchants[itemEnchantID] == nil then
		ProcScienceStats.enchants[itemEnchantID] = self:NewStats()
	end

	local procStats = ProcScienceStats.enchants[itemEnchantID]
	local enchantLink = string.format("%s|Henchant:%s|h[%s Enchant]|h%s", HIGHLIGHT_FONT_COLOR_CODE, procInfo.enchantID, procInfo.enchantName, FONT_COLOR_CODE_CLOSE)
	self:DetectProc(detected, procInfo, procStats, enchantLink, itemEnchantID, slotID)
end

function ProcScience:DetectItemProc(detected, itemLink, slotID)
	local itemID = self:GetItemIDFromLink(itemLink)
	local procInfo = L.Procs[itemID]
	if not procInfo then
		return
	end

	if ProcScienceStats.items[itemID] == nil then
		ProcScienceStats.items[itemID] = self:NewStats()
	end

	local procStats = ProcScienceStats.items[itemID]
	self:DetectProc(detected, procInfo, procStats, itemLink, itemID, slotID)
end

function ProcScience:DetectItems()
	local detected = {}

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then
			self:DetectItemProc(detected, itemLink, slotID)
			if IsMeleeWeaponSlot(slotID) then
				self:DetectEnchantProc(detected, itemLink, slotID)
				self:DetectTempEnchantProc(detected, itemLink, slotID)
			end
		end
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

function ProcScience:GetBuffProcByName(buffName)
	for buffID, buffInfo in pairs(L.Buffs) do
		if buffInfo.buffName == buffName then
			return buffInfo
		end
	end
end

function ProcScience:DetectBuffProc(detected, buffIndex, buffID)
	local buffName = self:GetBuffName(buffIndex)
	local procInfo = L.Buffs[buffID] or self:GetBuffProcByName(buffName)
	if not procInfo then
		return
	end

	if ProcScienceStats.buffs[buffName] == nil then
		ProcScienceStats.buffs[buffName] = self:NewStats()
	end

	local procStats = ProcScienceStats.buffs[buffName]
	local link = self:GetItemLink(procInfo.itemID)
	self:DetectProc(detected, procInfo, procStats, link, buffName, nil)
end

function ProcScience:DetectBuffs()
	local detected = {}

	local buffIndex = 1
	local icon = "someIcon"
	local _, spellID
	while icon do
		icon, _, spellID = UnitBuff("player", buffIndex)
		if icon then
			self:DetectBuffProc(detected, buffIndex, spellID)
		end

		buffIndex = buffIndex + 1
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

function ProcScience:UpdateProcHits(source, isOffHand, amount)
	isOffHand = isOffHand or false
	amount = amount or 1
	local isGCD = self:IsGCD()
	for _, tracked in ipairs({self.tracked, self.trackedBuffs}) do
		for spellName, proc in pairs(tracked) do
			if proc.filter == nil or (proc.filter == "main hand" and not isOffHand and not self.player.disarmed) or (proc.filter == "off-hand" and isOffHand) then
				local trigger = proc.info.events.trigger
				if trigger == L.TRIGGER_ON_HIT or not self.sources.AreaEffect[source] or self.pendingAE[source] then
					proc.stats.hits = proc.stats.hits + amount
					if isGCD then
						proc.stats.gcdHits = proc.stats.gcdHits + amount
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
		local isGCD = self:IsGCD()
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
		if isGCD then
			proc.stats.gcdProcs = proc.stats.gcdProcs + 1
		end
		return
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

	local _, unitClass = UnitClass("player")
	local _, guid = UnitExists("player") -- superwow
	local _, targetGuid = UnitExists("target") -- superwow
	self.player = {
		name = UnitName("player"),
		guid = guid,
		level = UnitLevel("player"), -- fluff. Never used
		class = unitClass,
		disarmed = false,
		targetName = UnitName("target"),
		targetGuid = targetGuid,
	}

	self.tracked = {}
	self.trackedBuffs = {}
	self.pendingAE = {}
	self.log = ProcScienceStats.log or LOG_LEVEL.TRACKING
	self:PopulateSources()

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
		return self:UpdateProcHits("Melee", false)
	end

	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		local _, _, spellHit, unitHit = string.find(arg1, "Your (.+) hits (.+) for")
		local _, _, spellCrit, unitCrit = string.find(arg1, "Your (.+) crits (.+) for ")
		local spellName = spellHit or spellCrit
		local unit = unitHit or unitCrit
		if self.sources.Damage[spellName] then
			return self:UpdateProcHits(spellName)
		end

		-- handle phantom hits

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
		if self.sources.Damage[spellName] then
			return self:UpdateProcHits(spellName)
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

function ProcScience:PrintStats()
	self:Print("Proc stats ("..SHORT_COMMIT_HASH.."):")
	if not next(ProcScienceStats.items) and
			not next(ProcScienceStats.enchants) and
			not next(ProcScienceStats.tempEnchants) and
			not next(ProcScienceStats.buffs) then
		return self:Print("No data")
	end

	for _, procStats in ipairs( {ProcScienceStats.items, ProcScienceStats.enchants, ProcScienceStats.tempEnchants, ProcScienceStats.buffs}) do
		for itemID, stats in pairs(procStats) do
			if stats.hits > 0 then
				local chance = stats.procs / stats.hits
				local confidence = 1.96 * math.sqrt(chance * (1 - chance) / stats.hits)
				local output = format("%s Hits: %d Procs: %d Chance: %.2f%% ±%.2f%%",
						stats.itemLink, stats.hits, stats.procs, chance * 100, confidence * 100)

				if stats.attackSpeed and stats.attackSpeed > 0 then
					output = output..format(" PPM: %.3f ±%.3f",
							chance * 60 / stats.attackSpeed, confidence * 60 / stats.attackSpeed)
				end

				self:Print(output)
			else
				self:Print(format("%s No hits", stats.itemLink))
			end
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
	for _, procStats in ipairs( {ProcScienceStats.items, ProcScienceStats.enchants, ProcScienceStats.tempEnchants, ProcScienceStats.buffs}) do
		for id, stats in pairs(procStats) do
			stats.hits = 0
			stats.procs = 0
			stats.gcdHits = 0
			stats.gcdProcs = 0
		end
	end
end

function ProcScience:ResetTracked()
	self:Print("Resetting currently tracked proc stats")
	-- TODO fix this resetting
	for spellName, proc in pairs(self.tracked) do
		local stats = ProcScienceStats.items[proc.itemID]
		stats.hits = 0
		stats.procs = 0
		stats.gcdHits = 0
		stats.gcdProcs = 0
	end

	for spellName, proc in pairs(self.trackedBuffs) do
		local stats = ProcScienceStats.buffs[proc.itemID]
		stats.hits = 0
		stats.procs = 0
		stats.gcdHits = 0
		stats.gcdProcs = 0
	end
end

function ProcScience:Reset(item)
	local itemID = GetItemInfoInstant(item)
	if itemID ~= nil then
		local stats = ProcScienceStats.items[itemID]
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
		ProcScience:SetGlobalCooldownSpellSlot()
		return ProcScience:DetectItems()
	end

	if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		return ProcScience:DetectItems()
	end

	if event == "UNIT_AURA" and arg1 == "player" then
		return ProcScience:Print(string.format("%s %s %s %s", event, tostring(arg1), tostring(arg2), tostring(arg3)))
		--return ProcScience:DetectBuffs()
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
	self:RegisterEvent("UNIT_AURASTATE")

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