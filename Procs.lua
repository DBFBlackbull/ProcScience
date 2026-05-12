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
		CHAT_MSG_SPELL_SELF_DAMAGE = true, -- Used to find aura resists
	},
	TargetStackingAura = {
		target = L.TARGET_ENEMY,
		trigger = L.TRIGGER_ON_HIT,
		CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = true,
		CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = true,
		CHAT_MSG_SPELL_SELF_DAMAGE = true, -- Used to find aura resists
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
	[19852] = { itemName = "Ancient Hakkari Manslayer", attackSpeed = 2.0, spellID = 24585, spellName = "Drain Life",       school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12798] = { itemName = "Annihilator",               attackSpeed = 1.7, spellID = 16928, spellName = "Armor Shatter",    school = L.SCHOOL.Shadow,   events = L.Events.TargetStackingAura }, -- Does not trigger UNIT_CASTEVENT
	[811]   = { itemName = "Axe of the Deep Woods",     attackSpeed = 2.7, spellID = 18104, spellName = "Wrath",            school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy },
	[6738]  = { itemName = "Bleeding Crescent",         attackSpeed = 2.4, spellID = 16403, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17068] = { itemName = "Deathbringer",              attackSpeed = 2.9, spellID = 18138, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy },
	[12621] = { itemName = "Demonfork",                 attackSpeed = 2.8, spellID = 16603, spellName = "Demonfork",        school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9465]  = { itemName = "Digmaster 5000",            attackSpeed = 1.8, spellID = 11791, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[17704] = { itemName = "Edge of Winter",            attackSpeed = 2.1, spellID = 16407, spellName = "Frost Blast",      school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[871]   = { itemName = "Flurry Axe",                attackSpeed = 1.5, spellID = 18797, spellName = "Flurry Axe",       school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks,       superWowEvents = L.Events.SuperWowEnemy },
	[10772] = { itemName = "Glutton's Cleaver",         attackSpeed = 2.0, spellID = 18075, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[1481]  = { itemName = "Grimclaw",                  attackSpeed = 2.0, spellID = 13440, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17002] = { itemName = "Ichor Spitter",             attackSpeed = 2.4, spellID = 17511, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9478]  = { itemName = "Ripsaw",                    attackSpeed = 2.7, spellID = 16405, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- needs testing
	[13286] = { itemName = "Rivenspike",                attackSpeed = 2.9, spellID = 17315, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[5426]  = { itemName = "Serpent's Kiss",            attackSpeed = 2.5, spellID = 18197, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9608]  = { itemName = "Shoni's Disarming Tool",    attackSpeed = 1.9, spellID = 11879, spellName = "Disarm",           school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13408] = { itemName = "Soul Breaker",              attackSpeed = 1.6, spellID = 17506, spellName = "Soul Breaker",     school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[934]   = { itemName = "Stalvan's Reaper",          attackSpeed = 2.9, spellID = 13524, spellName = "Curse of Stalvan", school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9485]  = { itemName = "Vibroblade",                attackSpeed = 1.6, spellID = 11791, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[15853] = { itemName = "Windreaper",                attackSpeed = 2.3, spellID = 20586, spellName = "Windreaper",       school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11920] = { itemName = "Wraith Scythe",             attackSpeed = 2.2, spellID = 16414, spellName = "Drain Life",       school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	--endregion

	--region ==== Maces ====
	[18671] = { itemName = "Baron Charr's Sceptre",       attackSpeed = 2.6, spellID = 13442, spellName = "Firebolt",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13204] = { itemName = "Bashguuder",                  attackSpeed = 1.8, spellID = 17315, spellName = "Puncture Armor",      school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[14487] = { itemName = "Bonechill Hammer",            attackSpeed = 2.4, spellID = 18276, spellName = "Frost Blast",         school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[19170] = { itemName = "Ebon Hand",                   attackSpeed = 2.5, spellID = 18211, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17112] = { itemName = "Empyrean Demolisher",         attackSpeed = 2.8, spellID = 21165, spellName = "Haste",               school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.SuperWowEnemy },
	[9386]  = { itemName = "Excavator's Brand",           attackSpeed = 2.6, spellID = 13438, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17943] = { itemName = "Fist of Stone",               attackSpeed = 1.8, spellID = 21951, spellName = "Fist of Stone",       school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[10804] = { itemName = "Fist of the Damned",          attackSpeed = 1.9, spellID = 18084, spellName = "Drain Life",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9419]  = { itemName = "Galgann's Firehammer",        attackSpeed = 2.2, spellID = 18083, spellName = "Firebolt",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9651]  = { itemName = "Gryphon Rider's Stormhammer", attackSpeed = 2.7, spellID = 18081, spellName = "Lightning Bolt",      school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[810]   = { itemName = "Hammer of the Northern Wind", attackSpeed = 2.1, spellID = 13439, spellName = "Frostbolt",           school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[2243]  = { itemName = "Hand of Edward the Odd",      attackSpeed = 2.0, spellID = 18803, spellName = "Focus",               school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11684] = { itemName = "Ironfoe",                     attackSpeed = 2.4, spellID = 15494, spellName = "Fury of Forgewright", school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks,       superWowEvents = L.Events.SuperWowEnemy },
	[12794] = { itemName = "Masterwork Stormhammer",      attackSpeed = 2.0, spellID = 16921, spellName = "Chain Lightning",     school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[23221] = { itemName = "Misplaced Servo Arm",         attackSpeed = 2.8, spellID = 29150, spellName = "Electric Discharge",  school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[4090]  = { itemName = "Mug O' Hurt",                 attackSpeed = 1.7, spellID = 13496, spellName = "Dazed",               school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[19908] = { itemName = "Sceptre of Smiting",          attackSpeed = 2.6, spellID = 24254, spellName = "Serpent's Hiss",      school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12781] = { itemName = "Serenity",                    attackSpeed = 2.0, spellID = 16908, spellName = "Dispel Magic",        school = L.SCHOOL.Arcane,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[2256]  = { itemName = "Skeletal Club",               attackSpeed = 2.6, spellID = 13440, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6472]  = { itemName = "Stinging Viper",              attackSpeed = 2.8, spellID = 18197, spellName = "Poison",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13401] = { itemName = "The Cruel Hand of Timmy",     attackSpeed = 1.8, spellID = 17505, spellName = "Curse of Timmy",      school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9639]  = { itemName = "The Hand of Antu'sul",        attackSpeed = 2.7, spellID = 13532, spellName = "Thunder Clap",        school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[7954]  = { itemName = "The Shatterer",               attackSpeed = 2.4, spellID = 13534, spellName = "Disarm",              school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13183] = { itemName = "Venomspitter",                attackSpeed = 1.9, spellID = 18203, spellName = "Poison",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12792] = { itemName = "Volcanic Hammer",             attackSpeed = 2.5, spellID = 18082, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	--endregion

	--region ==== Swords ====
	[13246] = { itemName = "Argent Avenger",                               attackSpeed = 2.2, spellID = 17352, spellName = "Argent Avenger",       school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[8223]  = { itemName = "Blade of the Basilisk",                        attackSpeed = 1.9, spellID = 10351, spellName = "Basilisk Skin",        school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[10803] = { itemName = "Blade of the Wretched",                        attackSpeed = 2.1, spellID = 18088, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12777] = { itemName = "Blazing Rapier",                               attackSpeed = 1.7, spellID = 16898, spellName = "Blaze",                school = L.SCHOOL.Frost,    events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9511]  = { itemName = "Bloodletter Scalpel",                          attackSpeed = 1.8, spellID = 13486, spellName = "Wound",                school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[809]   = { itemName = "Bloodrazor",                                   attackSpeed = 2.7, spellID = 17504, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[14145] = { itemName = "Cursed Felblade",                              attackSpeed = 2.6, spellID = 18381, spellName = "Cripple",              school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[14576] = { itemName = "Ebon Hilt of Marduk",                          attackSpeed = 2.7, spellID = 18656, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11121] = { itemName = "Darkwater Talwar",                             attackSpeed = 2.2, spellID = 16408, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[869]   = { itemName = "Dazzling Longsword",                           attackSpeed = 1.7, spellID = 13752, spellName = "Faerie Fire",          school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[10847] = { itemName = "Dragon's Call",                                attackSpeed = 2.5, spellID = 13049, spellName = "Dragon's Call",        school = L.SCHOOL.Physical, events = L.Events.Summon,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9446]  = { itemName = "Electrocutioner Leg",                          attackSpeed = 1.7, spellID = 13482, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[10797] = { itemName = "Firebreather",                                 attackSpeed = 2.2, spellID = 16413, spellName = "Fireball",             school = L.SCHOOL.Fire,     events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12797] = { itemName = "Frostguard",                                   attackSpeed = 2.3, spellID = 16927, spellName = "Chilled",              school = L.SCHOOL.Frost,    events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[15814] = { itemName = "Hameya's Slayer",                              attackSpeed = 2.0, spellID = 16406, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[8190]  = { itemName = "Hanzo Sword",                                  attackSpeed = 1.5, spellID = 16405, spellName = "Wound",                school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[11086] = { itemName = "Jang'thraze the Protector",                    attackSpeed = 1.9, spellID = 11657, spellName = "Jang'thraze",          school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17054] = { itemName = "Joonho's Mercy",                               attackSpeed = 2.1, spellID = 20883, spellName = "Arcane Blast",         school = L.SCHOOL.Arcane,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11902] = { itemName = "Linken's Sword of Mastery",                    attackSpeed = 1.8, spellID = 18089, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[11817] = { itemName = "Lord General's Sword",                         attackSpeed = 2.6, spellID = 15602, spellName = "Lord General's Sword", school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[7961]  = { itemName = "Phantom Blade",                                attackSpeed = 2.6, spellID = 9806,  spellName = "Phantom Strike",       school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[2263]  = { itemName = "Phytoblade",                                   attackSpeed = 2.8, spellID = 14119, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[18348] = { itemName = "Quel'Serrar",                                  attackSpeed = 2.0, spellID = 22850, spellName = "Sanctuary",            school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy },
	[1265]  = { itemName = "Scorpion Sting",                               attackSpeed = 2.4, spellID = 18208, spellName = "Poison",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13035] = { itemName = "Serpent Slicer",                               attackSpeed = 2.5, spellID = 17511, spellName = "Poison",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[754]   = { itemName = "Shortsword of Vengeance",                      attackSpeed = 2.4, spellID = 13519, spellName = "Holy Smite",           school = L.SCHOOL.Holy,     events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[1482]  = { itemName = "Shadowfang",                                   attackSpeed = 2.7, spellID = 13440, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13953] = { itemName = "Silent Fang",                                  attackSpeed = 1.6, spellID = 18278, spellName = "Silence",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[8224]  = { itemName = "Silithid Ripper",                              attackSpeed = 2.3, spellID = 16403, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13361] = { itemName = "Skullforge Reaver",                            attackSpeed = 2.8, spellID = 17484, spellName = "Skullforge Brand",     school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13032] = { itemName = "Sword of Corruption",                          attackSpeed = 2.1, spellID = 17510, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[1727]  = { itemName = "Sword of Decay",                               attackSpeed = 2.7, spellID = 13528, spellName = "Decayed Strength",     school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[6622]  = { itemName = "Sword of Zeal",                                attackSpeed = 2.8, spellID = 8191,  spellName = "Zeal",                 school = L.SCHOOL.Holy,     events = L.Events.SelfAura,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[8225]  = { itemName = "Tainted Pierce",                               attackSpeed = 1.9, spellID = 13530, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[1728]  = { itemName = "Teebu's Blazing Longsword",                    attackSpeed = 2.9, spellID = 18086, spellName = "Firebolt",             school = L.SCHOOL.Fire,     events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12974] = { itemName = "The Black Knight",                             attackSpeed = 1.9, spellID = 14106, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17705] = { itemName = "Thrash Blade",                                 attackSpeed = 2.7, spellID = 21919, spellName = "Thrash",               school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowEnemy },
	[19019] = { itemName = "Thunderfury, Blessed Blade of the Windseeker", attackSpeed = 1.9, spellID = 21992, spellName = "Thunderfury",          school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17075] = { itemName = "Vis'kag the Bloodletter",                      attackSpeed = 2.6, spellID = 21140, spellName = "Fatal Wound",          school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[19901] = { itemName = "Zulian Slicer",                                attackSpeed = 2.5, spellID = 24251, spellName = "Zulian Slice",         school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	--endregion

	--region ==== Polearms ====
	[12583] = { itemName = "Blackhand Doomsaw",        attackSpeed = 3.5, spellID = 16549, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[7959]  = { itemName = "Blight",                   attackSpeed = 2.7, spellID = 9796,  spellName = "Blight",          school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy },
	[13057] = { itemName = "Bloodpike",                attackSpeed = 3.2, spellID = 18202, spellName = "Rend",            school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[13148] = { itemName = "Chillpike",                attackSpeed = 2.8, spellID = 19260, spellName = "Frost Blast",     school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[9475]  = { itemName = "Diabolic Skiver",          attackSpeed = 2.9, spellID = 18206, spellName = "Fatal Wound",     school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[11809] = { itemName = "Flame Wrath",              attackSpeed = 3.3, spellID = 16559, spellName = "Flame Wrath",     school = L.SCHOOL.Fire,     events = L.Events.SelfAura,   superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13054] = { itemName = "Grim Reaper",              attackSpeed = 3.1, spellID = 14126, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[19874] = { itemName = "Halberd of Smiting",       attackSpeed = 3.5, spellID = 25669, spellName = "Decapitate",      school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[1726]  = { itemName = "Poison-tipped Bone Spear", attackSpeed = 2.3, spellID = 16401, spellName = "Poison",          school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[17074] = { itemName = "Shadowstrike",             attackSpeed = 3.1, spellID = 21170, spellName = "Drain Life",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[12243] = { itemName = "Smoldering Claw",          attackSpeed = 2.9, spellID = 15662, spellName = "Fireball",        school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	[13060] = { itemName = "The Needler",              attackSpeed = 2.2, spellID = 16405, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true }, -- Needs testing
	[17223] = { itemName = "Thunderstrike",            attackSpeed = 3.1, spellID = 21179, spellName = "Chain Lightning", school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.SuperWowEnemy }, -- Needs testing
	--endregion

	-- Staves

	-- Two-handed Axes

	-- Two-handed Maces

	-- Two-handed Swords

	-- Self-applied events
	[647]   = { itemName = "Destiny", attackSpeed = 2.6, spellID = 17152, spellName = "Destiny", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },

	[7717]  = { itemName = "Ravager", attackSpeed = 3.5, spellID = 9632, spellName = "Bladestorm", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[7960]  = { itemName = "Truesilver Champion", attackSpeed = 3.0, spellID = 9800, spellName = "Holy Shield", events = L.Events.SelfAura, superWowEvents = L.Events.SuperWowEnemy },
	[11815] = { itemName = "Hand of Justice", spellID = 15601, spellName = "Hand of Justice", events = L.Events.ExtraAttacks, superWowEvents = L.Events.SuperWowSelf },
	[17076] = { itemName = "Bonereaver's Edge", attackSpeed = 3.4, spellID = 21153, spellName = "Bonereaver's Edge", events = L.Events.SelfStackingAura, superWowEvents = L.Events.SuperWowEnemy },



	-- Target-applied events

	[11607]  = { itemName = "Dark Iron Sunderer", attackSpeed = 2.6, spellID = 15280, spellName = "Cleave Armor", school = L.SCHOOL.Physical, events = L.Events.TargetAura }, -- Does not trigger UNIT_CASTEVENT
	[12592]  = { itemName = "Blackblade of Shahram", attackSpeed = 3.5, spellID = 16602, spellName = "Shahram", school = "Arcane", events = L.Events.Summon, superWowEvents = L.Events.SuperWowEnemy },

	[13285]  = { itemName = "The Blackrock Slicer", attackSpeed = 4.0, spellID = 17407, spellName = "Wound", school = L.SCHOOL.Physical, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy, isPhantomStrike = true },
	[13348]  = { itemName = "Demonshear", attackSpeed = 3.8, spellID = 17483, spellName = "Shadow Bolt", school = L.SCHOOL.Shadow, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[13393]  = { itemName = "Malown's Slam", attackSpeed = 3.8, spellID = 17500, spellName = "Malown's Slam", events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy }, -- This weapon has both a 2 sec enemy debuff and a 30 sec self buff.
	[15853]  = { itemName = "Windreaper", attackSpeed = 2.3, spellID = 20586, spellName = "Windreaper", school = L.SCHOOL.Nature, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy },
	[17073]  = { itemName = "Earthshaker", attackSpeed = 3.5, spellID = 21152, spellName = "Earthshaker", school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.SuperWowEnemy },
	[17182]  = { itemName = "Sulfuras, Hand of Ragnaros", attackSpeed = 3.7, spellID = 21162, spellName = "Fireball", school = L.SCHOOL.Fire, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
	[19169]  = { itemName = "Nightfall", attackSpeed = 3.5, spellID = 23605, spellName = "Spell Vulnerability", school = L.SCHOOL.Physical, events = L.Events.TargetAura }, -- Does not trigger UNIT_CASTEVENT
	[19353]  = { itemName = "Drake Talon Cleaver", attackSpeed = 3.4, spellID = 21140, spellName = "Fatal Wound", school = L.SCHOOL.Physical, events = L.Events.Damage, superWowEvents = L.Events.SuperWowEnemy },
}
