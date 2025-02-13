L = {}

L.TARGET_SELF = 1
L.TARGET_ENEMY = 2
L.TARGET_AREA_EFFECT = 3

L.TRIGGER_ON_CAST = 1
L.TRIGGER_ON_HIT = 2

L.Events = {
	ExtraAttacks = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_CAST,
		SPELL_EXTRA_ATTACKS = true
	},
	SelfAura = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_REFRESH = true
	},
	SelfStackingAura = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true
	},
	TargetAura = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_REFRESH = true,
		SPELL_MISSED = true
	},
	TargetStackingAura = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true,
		SPELL_MISSED = true
	},
	Damage = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		SPELL_DAMAGE = true,
		SPELL_MISSED = true
	},
	Summon = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_CAST,
		SPELL_SUMMON = true
	}
}

L.Procs = {
	-- Self-applied events
	[647]   = { itemName = "Destiny", attackSpeed = 2.6, spellID = 17152, spellName = "Destiny", events = L.Events.SelfAura },
	[871]   = { itemName = "Flurry Axe", attackSpeed = 1.5, spellID = 18797, spellName = "Flurry Axe", events = L.Events.ExtraAttacks },
	[7717]  = { itemName = "Ravager", attackSpeed = 3.5, spellID = 9632, spellName = "Bladestorm", events = L.Events.SelfAura },
	[11684] = { itemName = "Ironfoe", attackSpeed = 2.4, spellID = 15494, spellName = "Fury of Forgewright", events = L.Events.ExtraAttacks },
	[11815] = { itemName = "Hand of Justice", spellID = 15601, spellName = "Hand of Justice", events = L.Events.ExtraAttacks },
	[12590] = { itemName = "Felstriker", attackSpeed = 1.7, spellID = 16551, spellName = "Felstriker", events = L.Events.SelfAura },
	[13393] = { itemName = "Malown's Slam", attackSpeed = 3.8, spellID = 17499, spellName = "Surge of Strength", events = L.Events.SelfAura },
	[17076] = { itemName = "Bonereaver's Edge", attackSpeed = 3.4, spellID = 21153, spellName = "Bonereaver's Edge", events = L.Events.SelfStackingAura },
	[17112] = { itemName = "Empyrean Demolisher", attackSpeed = 2.8, spellID = 21165, spellName = "Haste", events = L.Events.SelfAura },
	[17705] = { itemName = "Thrash Blade", attackSpeed = 2.7, spellID = 21919, spellName = "Thrash", events = L.Events.ExtraAttacks },
	[18203] = { itemName = "Eskhandar's Right Claw", attackSpeed = 1.5, spellID = 22640, spellName = "Eskhandar's Rage", events = L.Events.SelfAura },
	[18348] = { itemName = "Quel'Serrar", attackSpeed = 2.0, spellID = 22850, spellName = "Sanctuary", events = L.Events.SelfAura },

	-- Target-applied events
	[811]    = { itemName = "Axe of the Deep Woods", attackSpeed = 2.7, spellID = 18104, spellName = "Wrath", school = "Nature", events = L.Events.Damage },
	[5756]   = { itemName = "Sliverblade", attackSpeed = 1.4, spellID = 18398, spellName = "Frost Blast", school = "Frost", events = L.Events.Damage },
	[10761]  = { itemName = "Coldrage Dagger", attackSpeed = 1.5, spellID = 13439, spellName = "Frostbolt", school = "Frost", events = L.Events.Damage },
	[12592]  = { itemName = "Blackblade of Shahram", attackSpeed = 3.5, spellID = 16602, spellName = "Shahram", school = "Arcane", events = L.Events.Summon },
	[12798]  = { itemName = "Annihilator", attackSpeed = 1.7, spellID = 16928, spellName = "Armor Shatter", school = "Shadow", events = L.Events.TargetStackingAura },
	[13204]  = { itemName = "Bashguuder", attackSpeed = 1.8, spellID = 17315, spellName = "Puncture Armor", school = "Physical", events = L.Events.TargetStackingAura },
	[13285]  = { itemName = "The Blackrock Slicer", attackSpeed = 4.0, spellID = 17407, spellName = "Wound", school = "Physical", events = L.Events.Damage },
	[13286]  = { itemName = "Rivenspike", attackSpeed = 2.9, spellID = 17315, spellName = "Puncture Armor", school = "Physical", events = L.Events.TargetStackingAura },
	[13348]  = { itemName = "Demonshear", attackSpeed = 3.8, spellID = 17483, spellName = "Shadow Bolt", school = "Shadow", events = L.Events.Damage },
	[13984]  = { itemName = "Darrowspike", attackSpeed = 1.5, spellID = 18276, spellName = "Frost Blast", school = "Frost", events = L.Events.Damage },
	[14024]  = { itemName = "Frightalon", attackSpeed = 1.4, spellID = 19755, spellName = "Frightalon", school = "Shadow", events = L.Events.TargetAura },
	[14487]  = { itemName = "Bonechill Hammer", attackSpeed = 2.4, spellID = 18276, spellName = "Frost Blast", school = "Frost", events = L.Events.Damage },
	[14555]  = { itemName = "Alcor's Sunrazor", attackSpeed = 1.3, spellID = 18833, spellName = "Firebolt", school = "Fire", events = L.Events.Damage },
	[15853]  = { itemName = "Windreaper", attackSpeed = 2.3, spellID = 20586, spellName = "Windreaper", school = "Nature", events = L.Events.TargetAura },
	[17073]  = { itemName = "Earthshaker", attackSpeed = 3.5, spellID = 21152, spellName = "Earthshaker", school = "Physical", events = L.Events.TargetAura, target = L.TARGET_AREA_EFFECT, trigger = L.TRIGGER_ON_CAST },
	[17075]  = { itemName = "Vis'kag the Bloodletter", attackSpeed = 2.6, spellID = 21140, spellName = "Fatal Wound", "Physical", events = L.Events.Damage },
	[17068]  = { itemName = "Deathbringer", attackSpeed = 2.9, spellID = 18138, spellName = "Shadow Bolt", school = "Shadow", events = L.Events.Damage },
	[17182]  = { itemName = "Sulfuras, Hand of Ragnaros", attackSpeed = 3.7, spellID = 21162, spellName = "Fireball", school = "Fire", events = L.Events.Damage },
	[18816]  = { itemName = "Perdition's Blade", attackSpeed = 1.8, spellID = 23267, spellName = "Firebolt", school = "Fire", events = L.Events.Damage },
	[19099]  = { itemName = "Glacial Blade", attackSpeed = 1.8, spellID = 18398, spellName = "Frost Blast", school = "Frost", events = L.Events.Damage },
	[19169]  = { itemName = "Nightfall", attackSpeed = 3.5, spellID = 23605, spellName = "Spell Vulnerability", school = "Physical", events = L.Events.TargetAura },
	[19353]  = { itemName = "Drake Talon Cleaver", attackSpeed = 3.4, spellID = 21140, spellName = "Fatal Wound", school = "Physical", events = L.Events.Damage },
}
