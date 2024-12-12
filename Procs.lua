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
	[647]   = { itemName = "Destiny", spellID = 17152, events = L.Events.SelfAura },
	[871]   = { itemName = "Flurry Axe", spellID = 18797, events = L.Events.ExtraAttacks },
	[7717]  = { itemName = "Ravager", spellID = 9632, events = L.Events.SelfAura },
	[11684] = { itemName = "Ironfoe", spellID = 15494, events = L.Events.ExtraAttacks },
	[11815] = { itemName = "Hand of Justice", spellID = 15601, events = L.Events.ExtraAttacks },
	[12590] = { itemName = "Felstriker", spellID = 16551, events = L.Events.SelfAura },
	[13393] = { itemName = "Malown's Slam", spellID = 17499, events = L.Events.SelfAura },
	[17076] = { itemName = "Bonereaver's Edge", spellID = 21153, events = L.Events.SelfStackingAura },
	[17112] = { itemName = "Empyrean Demolisher", spellID = 21165, events = L.Events.SelfAura },
	[17705] = { itemName = "Thrash Blade", spellID = 21919, events = L.Events.ExtraAttacks },
	[18203] = { itemName = "Eskhandar's Right Claw", spellID = 22640, events = L.Events.SelfAura },
	[18348] = { itemName = "Quel'Serrar", spellID = 22850, events = L.Events.SelfAura },

	-- Target-applied events
	[811]    = { itemName = "Axe of the Deep Woods", spellID = 18104, school = "Nature", events = L.Events.Damage },
	[5756]   = { itemName = "Sliverblade", spellID = 18398, school = "Frost", events = L.Events.Damage },
	[10761]  = { itemName = "Coldrage Dagger", spellID = 13439, school = "Frost", events = L.Events.Damage },
	[12592]  = { itemName = "Blackblade of Shahram", spellID = 16602, school = "Arcane", events = L.Events.Summon },
	[12798]  = { itemName = "Annihilator", spellID = 16928, school = "Shadow", events = L.Events.TargetStackingAura },
	[13204]  = { itemName = "Bashguuder", spellID = 17315, school = "Physical", events = L.Events.TargetStackingAura },
	[13285]  = { itemName = "The Blackrock Slicer", spellID = 17407, school = "Physical", events = L.Events.Damage },
	[13286]  = { itemName = "Rivenspike", spellID = 17315, school = "Physical", events = L.Events.TargetStackingAura },
	[13348]  = { itemName = "Demonshear", spellID = 17483, school = "Shadow", events = L.Events.Damage },
	[13984]  = { itemName = "Darrowspike", spellID = 18276, school = "Frost", events = L.Events.Damage },
	[14024]  = { itemName = "Frightalon", spellID = 19755, school = "Shadow", events = L.Events.TargetAura },
	[14487]  = { itemName = "Bonechill Hammer", spellID = 18276, school = "Frost", events = L.Events.Damage },
	[14555]  = { itemName = "Alcor's Sunrazor", spellID = 18833, school = "Fire", events = L.Events.Damage },
	[15853]  = { itemName = "Windreaper", spellID = 20586, school = "Nature", events = L.Events.TargetAura },
	[17073]  = { itemName = "Earthshaker", spellID = 21152, school = "Physical", events = L.Events.TargetAura, target = L.TARGET_AREA_EFFECT, trigger = L.TRIGGER_ON_CAST },
	[17075]  = { itemName = "Vis'kag the Bloodletter", spellID = 21140, "Physical", events = L.Events.Damage },
	[17068]  = { itemName = "Deathbringer", spellID = 18138, school = "Shadow", events = L.Events.Damage },
	[17182]  = { itemName = "Sulfuras, Hand of Ragnaros", spellID = 21162, school = "Fire", events = L.Events.Damage },
	[18816]  = { itemName = "Perdition's Blade", spellID = 23267, school = "Fire", events = L.Events.Damage },
	[19099]  = { itemName = "Glacial Blade", spellID = 18398, school = "Frost", events = L.Events.Damage },
	[19169]  = { itemName = "Nightfall", spellID = 23605, school = "Physical", events = L.Events.TargetAura },
	[19353]  = { itemName = "Drake Talon Cleaver", spellID = 21140, school = "Physical", events = L.Events.Damage },
}
