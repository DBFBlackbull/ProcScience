ProcScience_L = {}
local L = ProcScience_L

L.TARGET_SELF = 1
L.TARGET_ENEMY = 2
L.TARGET_AREA_EFFECT = 3

L.TRIGGER_ON_CAST = 1
L.TRIGGER_ON_HIT = 2

L.Events = {
	ExtraAttacks = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_CAST,
		CHAT_MSG_SPELL_SELF_BUFF = true,
	},
	SelfAura = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS = true,
	},
	SelfStackingAura = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS = true,
	},
	TargetAura = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = true,
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = true,
		CHAT_MSG_SPELL_SELF_DAMAGE = true,
	},
	TargetStackingAura = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = true,
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = true,
		CHAT_MSG_SPELL_SELF_DAMAGE = true,
	},
	Damage = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_SELF_DAMAGE = true,
	},
	Summon = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_CAST,
		-- does not work on native 1.12
	},
	SuperWowSelf = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		UNIT_CASTEVENT = true
	},
	SuperWowEnemy = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		UNIT_CASTEVENT = true
	}
}

L.SCHOOL = {
	Physical = "Physical",
	Arcane = "Arcane",
	Fire = "Fire",
	Frost = "Frost",
	Nature = "Nature",
	Shadow = "Shadow",
	Holy = "Holy",
}

L.Procs = {
	-- Phantom Strike source: Classic WoW Armaments discord:

	--region ==== Daggers ====
	[14555] = { itemName = "Alcor's Sunrazor",           attackSpeed = 1.3, spellID = 18833, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[12791] = { itemName = "Barman Shanker",             attackSpeed = 2.0, spellID = 13318, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[6904]  = { itemName = "Bite of Serra'kis",          attackSpeed = 1.3, spellID = 8313,  spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[19166] = { itemName = "Black Amnesty",              attackSpeed = 1.6, spellID = 23604, spellName = "Reduce Threat",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6831]  = { itemName = "Black Menace",               attackSpeed = 1.5, spellID = 13440, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[4446]  = { itemName = "Blackvenom Blade",           attackSpeed = 1.6, spellID = 13518, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[10761] = { itemName = "Coldrage Dagger",            attackSpeed = 1.5, spellID = 13439, spellName = "Frostbolt",                  school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[2912]  = { itemName = "Claw of the Shadowmancer",   attackSpeed = 1.9, spellID = 16409, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13984] = { itemName = "Darrowspike",                attackSpeed = 1.5, spellID = 18276, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[19100] = { itemName = "Electrified Dagger",         attackSpeed = 1.8, spellID = 23592, spellName = "Lightning Bolt",             school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[20578] = { itemName = "Emerald Dragonfang",         attackSpeed = 1.8, spellID = 24993, spellName = "Acid Blast",                 school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13218] = { itemName = "Fang of the Crystal Spider", attackSpeed = 1.6, spellID = 17331, spellName = "Fang of the Crystal Spider", school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12590] = { itemName = "Felstriker",                 attackSpeed = 1.7, spellID = 16551, spellName = "Felstriker",                 school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy },
	[3336]  = { itemName = "Flesh Piercer",              attackSpeed = 2.0, spellID = 18078, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[14024] = { itemName = "Frightalon",                 attackSpeed = 1.4, spellID = 19755, spellName = "Frightalon",                 school = L.SCHOOL.Shadow,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9467]  = { itemName = "Gahz'rilla Fang",            attackSpeed = 1.8, spellID = 3742,  spellName = "Static Electricity",         school = L.SCHOOL.Nature,   events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[19099] = { itemName = "Glacial Blade",              attackSpeed = 1.8, spellID = 18398, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[2164]  = { itemName = "Gut Ripper",                 attackSpeed = 1.8, spellID = 18107, spellName = "Wound",                      school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[17071] = { itemName = "Gutgore Ripper",             attackSpeed = 1.8, spellID = 21151, spellName = "Gutgore Ripper",             school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[5616]  = { itemName = "Gutwrencher",                attackSpeed = 1.6, spellID = 16406, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[11635] = { itemName = "Hookfang Shanker",           attackSpeed = 1.4, spellID = 13526, spellName = "Corrosive Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6331]  = { itemName = "Howling Blade",              attackSpeed = 1.4, spellID = 13490, spellName = "Howling Blade",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6660]  = { itemName = "Julie's Dagger",             attackSpeed = 1.3, spellID = 8348,  spellName = "Julie's Blessing",           school = L.SCHOOL.Holy,     events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12582] = { itemName = "Keris of Zul'Serak",         attackSpeed = 1.8, spellID = 16528, spellName = "Numbing Pain",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6220]  = { itemName = "Meteor Shard",               attackSpeed = 1.8, spellID = 13442, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[4449]  = { itemName = "Naraxis' Fang",              attackSpeed = 1.6, spellID = 16400, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[18816] = { itemName = "Perdition's Blade",          attackSpeed = 1.8, spellID = 23267, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[17752] = { itemName = "Satyr's Lash",               attackSpeed = 1.7, spellID = 18205, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12531] = { itemName = "Searing Needle",             attackSpeed = 1.8, spellID = 16454, spellName = "Searing Blast",              school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[2163]  = { itemName = "Shadowblade",                attackSpeed = 1.4, spellID = 18138, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[5756]  = { itemName = "Sliverblade",                attackSpeed = 1.4, spellID = 18398, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[10625] = { itemName = "Stealthblade",               attackSpeed = 1.4, spellID = 12685, spellName = "Fade",                       school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[19324] = { itemName = "The Lobotomizer",            attackSpeed = 1.8, spellID = 24388, spellName = "Brain Damage",               school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[8006]  = { itemName = "The Ziggler",                attackSpeed = 1.7, spellID = 13482, spellName = "Lightning Bolt",             school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9453]  = { itemName = "Toxic Revenger",             attackSpeed = 1.9, spellID = 11790, spellName = "Poison Cloud",               school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[899]   = { itemName = "Venom Web Fang",             attackSpeed = 1.5, spellID = 18077, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[5752]  = { itemName = "Wyvern Tailspike",           attackSpeed = 1.8, spellID = 16400, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	-- [12791] = { itemName = "Blade of Eternal Darkness", attackSpeed = 2.0, spellID = 13318, spellName = "Rend", school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- No way of tracking spell casts yet
	--endregion

	--region ==== Fist weapons ====
	[19910] = { itemName = "Arlokk's Grasp",           attackSpeed = 1.5, spellID = 18205, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11744] = { itemName = "Bloodfist",                attackSpeed = 1.8, spellID = 16433, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[17738] = { itemName = "Claw of Celebras",         attackSpeed = 1.8, spellID = 21952, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[18202] = { itemName = "Eskhandar's Left Claw",    attackSpeed = 1.5, spellID = 22639, spellName = "Eskhandar's Rage", school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[18203] = { itemName = "Eskhandar's Right Claw",   attackSpeed = 1.5, spellID = 22640, spellName = "Eskhandar's Rage", school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13399] = { itemName = "Gargoyle Shredder Talons", attackSpeed = 1.8, spellID = 18202, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[13198] = { itemName = "Hurd Smasher",             attackSpeed = 1.8, spellID = 17308, spellName = "Stun",             school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[2942]  = { itemName = "Iron Knuckles",            attackSpeed = 1.7, spellID = 13491, spellName = "Pummel",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[11603] = { itemName = "Vilerend Slicer",          attackSpeed = 1.4, spellID = 16405, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	--endregion

	--region ==== Axes ====
	--endregion

	-- Maces

	-- Swords

	-- Polearms

	-- Staves

	-- Two-handed Axes

	-- Two-handed Maces

	-- Two-handed Swords

	-- Self-applied events
	[647]   = { itemName = "Destiny", attackSpeed = 2.6, spellID = 17152, spellName = "Destiny", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },
	[871]   = { itemName = "Flurry Axe", attackSpeed = 1.5, spellID = 18797, spellName = "Flurry Axe", events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowEnemy },
	[7717]  = { itemName = "Ravager", attackSpeed = 3.5, spellID = 9632, spellName = "Bladestorm", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[7960]  = { itemName = "Truesilver Champion", attackSpeed = 3.0, spellID = 9800, spellName = "Holy Shield", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },
	[11684] = { itemName = "Ironfoe", attackSpeed = 2.4, spellID = 15494, spellName = "Fury of Forgewright", events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowEnemy },
	[11815] = { itemName = "Hand of Justice", spellID = 15601, spellName = "Hand of Justice", events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowSelf },
	[17076] = { itemName = "Bonereaver's Edge", attackSpeed = 3.4, spellID = 21153, spellName = "Bonereaver's Edge", events = L.Events.SelfStackingAura, superWowEvents = L.Events.SuperWowEnemy },
	[17112] = { itemName = "Empyrean Demolisher", attackSpeed = 2.8, spellID = 21165, spellName = "Haste", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },
	[17705] = { itemName = "Thrash Blade", attackSpeed = 2.7, spellID = 21919, spellName = "Thrash", events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowEnemy },
	[18348] = { itemName = "Quel'Serrar", attackSpeed = 2.0, spellID = 22850, spellName = "Sanctuary", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },

	-- Target-applied events
	[811]    = { itemName = "Axe of the Deep Woods", attackSpeed = 2.7, spellID = 18104, spellName = "Wrath", school = L.SCHOOL.Nature, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[5756]   = { itemName = "Sliverblade", attackSpeed = 1.4, spellID = 18398, spellName = "Frost Blast", school = L.SCHOOL.Frost, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[7959]   = { itemName = "Blight", attackSpeed = 2.7, spellID = 9796, spellName = "Blight", school = L.SCHOOL.Nature, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[11607]  = { itemName = "Dark Iron Sunderer", attackSpeed = 2.6, spellID = 15280, spellName = "Cleave Armor", school = L.SCHOOL.Physical, events = L.Events.TargetAura }, -- Does not trigger UNIT_CASTEVENT
	[12592]  = { itemName = "Blackblade of Shahram", attackSpeed = 3.5, spellID = 16602, spellName = "Shahram", school = "Arcane", events = L.Events.Summon, superWowEvents = L.Events.SuperWowEnemy },
	[12798]  = { itemName = "Annihilator", attackSpeed = 1.7, spellID = 16928, spellName = "Armor Shatter", school = L.SCHOOL.Shadow, events = L.Events.TargetStackingAura }, -- Does not trigger UNIT_CASTEVENT
	[13204]  = { itemName = "Bashguuder", attackSpeed = 1.8, spellID = 17315, spellName = "Puncture Armor", school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[13285]  = { itemName = "The Blackrock Slicer", attackSpeed = 4.0, spellID = 17407, spellName = "Wound", school = L.SCHOOL.Physical, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[13286]  = { itemName = "Rivenspike", attackSpeed = 2.9, spellID = 17315, spellName = "Puncture Armor", school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[13348]  = { itemName = "Demonshear", attackSpeed = 3.8, spellID = 17483, spellName = "Shadow Bolt", school = L.SCHOOL.Shadow, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[13393]  = { itemName = "Malown's Slam", attackSpeed = 3.8, spellID = 17500, spellName = "Malown's Slam", events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- This weapon has both a 2 sec enemy debuff and a 30 sec self buff.
	[14024]  = { itemName = "Frightalon", attackSpeed = 1.4, spellID = 19755, spellName = "Frightalon", school = L.SCHOOL.Shadow, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy },
	[14487]  = { itemName = "Bonechill Hammer", attackSpeed = 2.4, spellID = 18276, spellName = "Frost Blast", school = L.SCHOOL.Frost, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[15853]  = { itemName = "Windreaper", attackSpeed = 2.3, spellID = 20586, spellName = "Windreaper", school = L.SCHOOL.Nature, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy },
	[17073]  = { itemName = "Earthshaker", attackSpeed = 3.5, spellID = 21152, spellName = "Earthshaker", school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy },
	[17075]  = { itemName = "Vis'kag the Bloodletter", attackSpeed = 2.6, spellID = 21140, spellName = "Fatal Wound", L.SCHOOL.Physical, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[17068]  = { itemName = "Deathbringer", attackSpeed = 2.9, spellID = 18138, spellName = "Shadow Bolt", school = L.SCHOOL.Shadow, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[17182]  = { itemName = "Sulfuras, Hand of Ragnaros", attackSpeed = 3.7, spellID = 21162, spellName = "Fireball", school = L.SCHOOL.Fire, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[19169]  = { itemName = "Nightfall", attackSpeed = 3.5, spellID = 23605, spellName = "Spell Vulnerability", school = L.SCHOOL.Physical, events = L.Events.TargetAura }, -- Does not trigger UNIT_CASTEVENT
	[19353]  = { itemName = "Drake Talon Cleaver", attackSpeed = 3.4, spellID = 21140, spellName = "Fatal Wound", school = L.SCHOOL.Physical, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
}
