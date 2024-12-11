local A, L = ...
local VERSION = "1.0"
local COMMIT_HASH = "f90c97f28d146b1ad7781d13ece3860d28f7b3db"
local SHORT_COMMIT_HASH = "f90c97f"
local ProcScience = CreateFrame("Frame")

ProcScienceStats = ProcScienceStats or { version = VERSION, items = {} }

local function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		local idx = 0
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			if idx > 0 then
				s = s .. ', '
			end
			s = s .. '['..k..'] = ' .. dump(v)
			idx = idx + 1
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function ProcScience:Print(...)
	print("|cffF0E68C[ProcScience]|cffFFFFFF:", ...)
end

function ProcScience:SpellName(spellID)
    local name = GetSpellInfo(spellID)
    if name then
    	return name
    else
      self:Print("|cffff0000WARNING: Spell ID ["..tostring(spellID).."] does not exist!|r")
    end
end

function ProcScience:PopulateSources()
	self.sources = { Damage = {}, AreaEffect = {}, Aura = {} }
	for k, v in pairs(L[self.player.class]) do
		for i, spellID in ipairs(v) do
			self.sources[k][self:SpellName(spellID)] = true
		end
	end
end

function ProcScience:DetectItemProc(detected, itemID, slotID)
	if itemID and L.Procs[itemID] then
		local procInfo = L.Procs[itemID]
		local spellID = procInfo.spellID
		local spellName = self:SpellName(spellID)
		local procStats

		if ProcScienceStats.items[itemID] == nil then
			ProcScienceStats.items[itemID] = { hits = 0, procs = 0 }
		end

		procStats = ProcScienceStats.items[itemID]
		procStats.itemName = select(1, GetItemInfo(itemID)) or procInfo.itemName
		procStats.spellName = spellName
		procStats.spellID = spellID

		if detected[spellName] ~= nil then
			local proc = detected[spellName]
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
			detected[spellName] = proc
		end
	end
end

function ProcScience:DetectItems()
	local detected = {}

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemID = GetInventoryItemID("player", slotID)
		self:DetectItemProc(detected, itemID, slotID)
	end
	
	if self.tracked ~= nil then
		for k, v in pairs(detected) do
			if self.tracked[k] == nil or self.tracked[k].filter ~= v.filter then
				local itemName = select(1, GetItemInfo(v.itemID)) or v.info.itemName
				self:Print("Tracking "..itemName.." in "..(v.filter or "both hands"))
			end
		end
	end

	self.tracked = detected
end

function ProcScience:UpdateProcHits(source, isOffHand, amount)
	isOffHand = isOffHand or false
	amount = amount or 1
	for k, v in pairs(self.tracked) do
		if v.filter == nil or (v.filter == "main hand" and not isOffHand and not self.player.disarmed) or (v.filter == "off-hand" and isOffHand) then
			local trigger = v.info.trigger or v.info.events.trigger
			if trigger == L.TRIGGER_ON_HIT or not self.sources.AreaEffect[source] or self.pendingAE[source] then
				v.stats.hits = v.stats.hits + amount
			end
		end
	end
end

function ProcScience:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
	local proc = self.tracked[spellName]
	if proc ~= nil and proc.info.events[subEvent] ~= nil then
		local target = proc.info.target or proc.info.events.target
		if (destGUID == self.player.guid or target ~= L.TARGET_SELF) and 
			(target ~= L.TARGET_AREA_EFFECT or not proc.timestamp or proc.timestamp ~= timestamp) then
			local stats = proc.stats
			stats.procs = stats.procs + 1
			proc.timestamp = timestamp
		end
	end
end

function ProcScience:OnAddonLoaded()
	self.player = { 
		name = UnitName("player"),
		guid = UnitGUID("player"),
		level = UnitLevel("player"),
		class = select(2, UnitClass("player")),
		disarmed = false
	}

	self.tracked = {}
	self.pendingAE = {}
	self:PopulateSources()

	self:Print("Loaded ("..SHORT_COMMIT_HASH..")")
	self:MigrateOldStats()
end

function ProcScience:OnEquipmentChanged()
	self:DetectItems()
end

function ProcScience:OnCombatLogEvent()
	if next(self.tracked) ~= nil then
		local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID = CombatLogGetCurrentEventInfo()
		if sourceGUID == self.player.guid then
			if subEvent == "SWING_DAMAGE" then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
				self:UpdateProcHits("Melee", isOffHand)
			elseif subEvent:find("^SPELL") ~= nil then
				local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
				if subEvent == "SPELL_CAST_SUCCESS" then
					if self.sources.Aura[spellName] then
						self:UpdateProcHits(spellName)
					elseif self.sources.AreaEffect[spellName] then
						self.pendingAE[spellName] = true
					end
				elseif subEvent == "SPELL_DAMAGE" then
					if self.sources.Damage[spellName] then
						self:UpdateProcHits(spellName)
					elseif self.sources.AreaEffect[spellName] then
						self:UpdateProcHits(spellName)
						self.pendingAE[spellName] = false
					else
						self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
					end 
				elseif subEvent == "SPELL_MISSED" then
					if self.sources.Aura[spellName] then
						self:UpdateProcHits(spellName, false, -1)
					else
						self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
					end
				else
					self:CheckProcEvent(timestamp, subEvent, destGUID, spellName)
				end
			end
		end
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

function ProcScience:MigrateOldStats()
	if not ProcScienceStats.items then
		local items = {}
		for k, v in pairs(ProcScienceStats) do
			if k ~= 'version' then
				if tonumber(k) == nil then
					local itemID = v.itemID
					local procInfo = L.Procs[itemID]
					if procInfo ~= nil and ProcScienceStats[itemID] == nil then
						v.spellID = procInfo.spellID
						v.spellName = self:SpellName(procInfo.spellID)
						v.itemID = nil
						items[itemID] = v
						ProcScienceStats[k] = nil
						self:Print("Migrated data for "..v.itemName.." to new format")
					end
				else
					items[k] = v
				end
			end
		end
		ProcScienceStats = { version = VERSION, items = items }
	end
end

function ProcScience:PrintStats()
	self:Print("Proc stats ("..SHORT_COMMIT_HASH.."):")
	if next(ProcScienceStats.items) ~= nil then
		for k, v in pairs(ProcScienceStats.items) do
			local itemID = k
			local itemName
				
			if GetItemInfo(itemID) ~= nil then
				itemName = select(2, GetItemInfo(itemID))
			else
				itemName = "["..v.itemName.."]"
			end

			if v.hits > 0 then
				local chance = v.procs / v.hits
				local confidence = 1.96 * math.sqrt(chance * (1 - chance) / v.hits)
				local attackSpeed = 0
				local output
				
				if GetItemInfo(itemID) ~= nil then
					GameTooltip:SetOwner(UIParent,"ANCHOR_NONE")
					GameTooltip:SetHyperlink(select(2, GetItemInfo(itemID)))
					for k=GameTooltip:NumLines(),2,-1 do
						local speed = (_G["GameTooltipTextRight"..k]:GetText() or ""):match(SPEED.." %d"..DECIMAL_SEPERATOR.."%d%d")
						if speed then
							speed = speed:gsub(SPEED.." ","")
							if DECIMAL_SEPERATOR ~= "." then
								speed = speed:gsub(DECIMAL_SEPERATOR, ".")
							end
							attackSpeed = tonumber(speed) or 0
							break
						end					
					end
					GameTooltip:Hide()
				end
				
				output = format("%s Hits: %d Procs: %d Chance: %.2f%% ±%.2f%%", 
					itemName, v.hits, v.procs, chance * 100, confidence * 100)
				
				if attackSpeed > 0 then
					output = output..format(" PPM: %.3f ±%.3f", 
						chance * 60 / attackSpeed, confidence * 60 / attackSpeed)
				end
				
				self:Print(output)
			else
				self:Print(format("%s No hits", itemName))
			end
		end
	else
		self:Print("No data")
	end
end

function ProcScience:ResetAll()
	self:Print("Resetting all proc stats")
	for k, v in pairs(ProcScienceStats.items) do
		v.hits = 0
		v.procs = 0
	end
end

function ProcScience:ResetTracked()
	self:Print("Resetting currently tracked proc stats")
	for k, v in pairs(self.tracked) do
		local stats = ProcScienceStats.items[v.itemID]
		stats.hits = 0
		stats.procs = 0
	end
end

function ProcScience:Reset(item)
	local itemID = GetItemInfoInstant(item)
	if itemID ~= nil then
		local stats = ProcScienceStats.items[itemID]
		if stats ~= nil then
			self:Print("Resetting proc stats for "..stats.itemName)
			stats.hits = 0
			stats.procs = 0
		else
			self:Print(item.." is not tracked by ProcScience")
		end
	else
		self:Print("Could not find item ID for "..item)
	end
end

function ProcScience:Dump()
	self:Print("version = "..SHORT_COMMIT_HASH)
	self:Print("player = "..dump(self.player))
	self:Print("sources = "..dump(self.sources))
	self:Print("procs = "..dump(self.tracked))
end

ProcScience:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and ... == "ProcScience" then
		self:OnAddonLoaded()
	elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_EQUIPMENT_CHANGED" then
		self:OnEquipmentChanged()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:OnCombatLogEvent()
	elseif event == "LOSS_OF_CONTROL_ADDED" or event == "LOSS_OF_CONTROL_UPDATE" then
		self:OnLossOfControlEvent()
	end
end)

ProcScience:RegisterEvent("ADDON_LOADED")
ProcScience:RegisterEvent("PLAYER_ENTERING_WORLD")
ProcScience:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ProcScience:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ProcScience:RegisterEvent("LOSS_OF_CONTROL_ADDED")
ProcScience:RegisterEvent("LOSS_OF_CONTROL_UPDATE")

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
