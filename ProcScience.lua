local VERSION = "1.0"
local COMMIT_HASH = "f90c97f28d146b1ad7781d13ece3860d28f7b3db"
local SHORT_COMMIT_HASH = "f90c97f"
local ProcScience = CreateFrame("Frame")
local L = ProcScience_L

local INVSLOT_FIRST_EQUIPPED = 1
local INVSLOT_LAST_EQUIPPED = 18

ProcScienceStats = ProcScienceStats or { version = VERSION, items = {} }

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
	DEFAULT_CHAT_FRAME:AddMessage("|cffF0E68C[ProcScience]|cffFFFFFF: "..string)
end

function ProcScience:Dump()
	self:Print("version = "..SHORT_COMMIT_HASH)
	self:Print("player = "..dump(self.player))
	self:Print("sources = "..dump(self.sources))
	self:Print("procs = "..dump(self.tracked))
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

function ProcScience:DetectItemProc(detected, itemID, slotID)
	if not L.Procs[itemID] then
		return
	end

	local procInfo = L.Procs[itemID]

	if ProcScienceStats.items[itemID] == nil then
		ProcScienceStats.items[itemID] = { hits = 0, procs = 0, gcdHits = 0, gcdProcs = 0 }
	end

	local procStats = ProcScienceStats.items[itemID]
	procStats.itemLink = GetInventoryItemLink("player", slotID)
	procStats.attackSpeed = procInfo.attackSpeed
	procStats.spellName = procInfo.spellName
	procStats.spellID = procInfo.spellID

	if detected[procInfo.spellName] ~= nil then
		local proc = detected[procInfo.spellName]
		if proc.filter then
			if (proc.filter == "main hand" and slotID == 17) or (proc.filter == "off-hand" and slotID == 16) then
				proc.filter = nil
			end
		end
	else
		local proc = { itemID = itemID, info = procInfo, stats = procStats }
		if slotID == 16 then
			proc.filter = "main hand"
		elseif slotID == 17 then
			proc.filter = "off-hand"
		end
		detected[procInfo.spellName] = proc
	end
end

function ProcScience:GetItemIDFromLink(itemLink)
	if not itemLink then
		return
	end

	local foundID, _ , itemID = string.find(itemLink, "item:(%d+)")
	if not foundID then
		return
	end

	return tonumber(itemID)
end

function ProcScience:GetInventoryItemID(unit, slotID)
	local itemLink = GetInventoryItemLink(unit, slotID)
	return self:GetItemIDFromLink(itemLink)
end

function ProcScience:DetectItems()
	local detected = {}

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemID = self:GetInventoryItemID("player", slotID)
		if itemID then
			self:DetectItemProc(detected, itemID, slotID)
		end
	end

	if self.tracked ~= nil then
		for spellName, proc in pairs(detected) do
			if self.tracked[spellName] == nil or self.tracked[spellName].filter ~= proc.filter then
				self:Print("Tracking "..proc.stats.itemLink.." in "..(proc.filter or "both hands"))
			end
		end
	end

	self.tracked = detected
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
	for spellName, proc in pairs(self.tracked) do
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

function ProcScience:CheckProcEvent(timestamp, event, unit, spellName)
	--self:Print(string.format("%s %s %s", event, spellName, unit))
	--self:Print(string.format("%s %s", self.player.name, self.player.guid))
	--self:Print(string.format("%s %s", self.player.target, self.player.targetGuid))

	local proc = self.tracked[spellName]
	if proc == nil then
		return
	end

	local events = proc.info.events
	if self.superWowActive and proc.info.superWowEvents then
		events = proc.info.superWowEvents
	end

	if not events[event] then
		return
	end

	local procOnSelf = events.target == L.TARGET_SELF and (unit == self.player.name or unit == self.player.guid)
	local procOnTarget = events.target == L.TARGET_ENEMY and (unit == self.player.target or unit == self.player.targetGuid)
	if procOnSelf or procOnTarget then
		local isGCD = self:IsGCD()
		local procMessage = proc.stats.itemLink.." proced "..proc.stats.spellName

		self:Print(procMessage)
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
	self.pendingAE = {}
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
	if next(self.tracked) == nil then
		return
	end

	local casterGuid = arg1
	local targetGuid = arg2
	local eventType = arg3
	local spellID = arg4
	local castDuration = arg5

	--if spellID ~= 6603 then
	--	local spellName = SpellInfo(spellID)
	--	self:Print(format("caster: %s target: %s eventType: %s spell: %s (%s) castDuration: %s", casterGuid, targetGuid, eventType, spellName, spellID, castDuration))
	--end

	if casterGuid ~= self.player.guid then
		return
	end

	if eventType ~= "CAST" and eventType ~= "CHANNEL" then
		return
	end

	local spellName = SpellInfo(spellID)
	if not self.tracked[spellName] or not self.tracked[spellName].spellID == spellID then
		return
	end

	return self:CheckProcEvent(timestamp, event, targetGuid, spellName)
end

function ProcScience:OnCombatLogEvent(timestamp)
	if next(self.tracked) == nil then
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
		spellName = spellName or spellMiss or spellDodge or spellParry or spellResist
		unit = unit or unitMiss or unitDodge or unitParry or unitResist
		return self:CheckProcEvent(timestamp, event, unit, spellName)
	end

	if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
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
		local _, _, unit, spellName = string.find(arg1, "(You) gain %d extra attacks? through (.+)%.")
		return self:CheckProcEvent(timestamp, event, self.player.name, spellName)
	end

	if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		local _, _, unit, spellName, stacks = string.find(arg1, "(You) gain (.+) %((%d+)%)%.")
		if not unit and not spellName then
			_, _, unit, spellName = string.find(arg1, "(You) gain (.+)%.")
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
	if next(ProcScienceStats.items) == nil then
		return self:Print("No data")
	end

	for itemID, stats in pairs(ProcScienceStats.items) do
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

function ProcScience:ResetAll()
	self:Print("Resetting all proc stats")
	for spellName, stats in pairs(ProcScienceStats.items) do
		stats.hits = 0
		stats.procs = 0
		stats.gcdHits = 0
		stats.gcdProcs = 0
	end
end

function ProcScience:ResetTracked()
	self:Print("Resetting currently tracked proc stats")
	for spellName, proc in pairs(self.tracked) do
		local stats = ProcScienceStats.items[proc.itemID]
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

	if event == "PLAYER_ENTERING_WORLD" then
		ProcScience:SetGlobalCooldownSpellSlot()
		return ProcScience:DetectItems()
	end

	if event == "PLAYER_TARGET_CHANGED" then
		return ProcScience:OnTargetChanged()
	end

	if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		return ProcScience:DetectItems()
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
		if arg1 ~= "CHAT_MSG_COMBAT_SELF_HITS" and arg1 ~= "CHAT_MSG_COMBAT_SELF_MISSES" then
			return ProcScience:Print(format("%s %s", arg1, arg2))
		end
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