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
	SelfHeal = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
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
	SelfSuperWow = {
		target = L.TARGET_SELF,
		trigger = L.TRIGGER_ON_HIT,
		UNIT_CASTEVENT = true
	},
	TargetSuperWow = {
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
	[14555] = { itemName = "Alcor's Sunrazor",           spellID = 18833, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[12791] = { itemName = "Barman Shanker",             spellID = 13318, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[6904]  = { itemName = "Bite of Serra'kis",          spellID = 8313,  spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19166] = { itemName = "Black Amnesty",              spellID = 23604, spellName = "Reduce Threat",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6831]  = { itemName = "Black Menace",               spellID = 13440, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[4446]  = { itemName = "Blackvenom Blade",           spellID = 13518, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10761] = { itemName = "Coldrage Dagger",            spellID = 13439, spellName = "Frostbolt",                  school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[2912]  = { itemName = "Claw of the Shadowmancer",   spellID = 16409, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13984] = { itemName = "Darrowspike",                spellID = 18276, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[19100] = { itemName = "Electrified Dagger",         spellID = 23592, spellName = "Lightning Bolt",             school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[20578] = { itemName = "Emerald Dragonfang",         spellID = 24993, spellName = "Acid Blast",                 school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13218] = { itemName = "Fang of the Crystal Spider", spellID = 17331, spellName = "Fang of the Crystal Spider", school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12590] = { itemName = "Felstriker",                 spellID = 16551, spellName = "Felstriker",                 school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow },
	[3336]  = { itemName = "Flesh Piercer",              spellID = 18078, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[14024] = { itemName = "Frightalon",                 spellID = 19755, spellName = "Frightalon",                 school = L.SCHOOL.Shadow,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9467]  = { itemName = "Gahz'rilla Fang",            spellID = 3742,  spellName = "Static Electricity",         school = L.SCHOOL.Nature,   events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19099] = { itemName = "Glacial Blade",              spellID = 18398, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[2164]  = { itemName = "Gut Ripper",                 spellID = 18107, spellName = "Wound",                      school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[17071] = { itemName = "Gutgore Ripper",             spellID = 21151, spellName = "Gutgore Ripper",             school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[5616]  = { itemName = "Gutwrencher",                spellID = 16406, spellName = "Rend",                       school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[11635] = { itemName = "Hookfang Shanker",           spellID = 13526, spellName = "Corrosive Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6331]  = { itemName = "Howling Blade",              spellID = 13490, spellName = "Howling Blade",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6660]  = { itemName = "Julie's Dagger",             spellID = 8348,  spellName = "Julie's Blessing",           school = L.SCHOOL.Holy,     events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12582] = { itemName = "Keris of Zul'Serak",         spellID = 16528, spellName = "Numbing Pain",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6220]  = { itemName = "Meteor Shard",               spellID = 13442, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[4449]  = { itemName = "Naraxis' Fang",              spellID = 16400, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[18816] = { itemName = "Perdition's Blade",          spellID = 23267, spellName = "Firebolt",                   school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[17752] = { itemName = "Satyr's Lash",               spellID = 18205, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12531] = { itemName = "Searing Needle",             spellID = 16454, spellName = "Searing Blast",              school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2163]  = { itemName = "Shadowblade",                spellID = 18138, spellName = "Shadow Bolt",                school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[5756]  = { itemName = "Sliverblade",                spellID = 18398, spellName = "Frost Blast",                school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10625] = { itemName = "Stealthblade",               spellID = 12685, spellName = "Fade",                       school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19324] = { itemName = "The Lobotomizer",            spellID = 24388, spellName = "Brain Damage",               school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[8006]  = { itemName = "The Ziggler",                spellID = 13482, spellName = "Lightning Bolt",             school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9453]  = { itemName = "Toxic Revenger",             spellID = 11790, spellName = "Poison Cloud",               school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[899]   = { itemName = "Venom Web Fang",             spellID = 18077, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[5752]  = { itemName = "Wyvern Tailspike",           spellID = 16400, spellName = "Poison",                     school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Fist weapons ====
	[19910] = { itemName = "Arlokk's Grasp",           spellID = 18205, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11744] = { itemName = "Bloodfist",                spellID = 16433, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[17738] = { itemName = "Claw of Celebras",         spellID = 21952, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[18202] = { itemName = "Eskhandar's Left Claw",    spellID = 22639, spellName = "Eskhandar's Rage", school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[18203] = { itemName = "Eskhandar's Right Claw",   spellID = 22640, spellName = "Eskhandar's Rage", school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13399] = { itemName = "Gargoyle Shredder Talons", spellID = 18202, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13198] = { itemName = "Hurd Smasher",             spellID = 17308, spellName = "Stun",             school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2942]  = { itemName = "Iron Knuckles",            spellID = 13491, spellName = "Pummel",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[11603] = { itemName = "Vilerend Slicer",          spellID = 16405, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	--endregion

	--region ==== Axes ====
	[19852] = { itemName = "Ancient Hakkari Manslayer", spellID = 24585, spellName = "Drain Life",       school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12798] = { itemName = "Annihilator",               spellID = 16928, spellName = "Armor Shatter",    school = L.SCHOOL.Shadow,   events = L.Events.TargetStackingAura }, -- Does not trigger UNIT_CASTEVENT
	[811]   = { itemName = "Axe of the Deep Woods",     spellID = 18104, spellName = "Wrath",            school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow },
	[6738]  = { itemName = "Bleeding Crescent",         spellID = 16403, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17068] = { itemName = "Deathbringer",              spellID = 18138, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow },
	[12621] = { itemName = "Demonfork",                 spellID = 16603, spellName = "Demonfork",        school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9465]  = { itemName = "Digmaster 5000",            spellID = 11791, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[17704] = { itemName = "Edge of Winter",            spellID = 16407, spellName = "Frost Blast",      school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[871]   = { itemName = "Flurry Axe",                spellID = 18797, spellName = "Flurry Axe",       school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks,       superWowEvents = L.Events.TargetSuperWow },
	[10772] = { itemName = "Glutton's Cleaver",         spellID = 18075, spellName = "Rend",             school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[1481]  = { itemName = "Grimclaw",                  spellID = 13440, spellName = "Shadow Bolt",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17002] = { itemName = "Ichor Spitter",             spellID = 17511, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9478]  = { itemName = "Ripsaw",                    spellID = 16405, spellName = "Wound",            school = L.SCHOOL.Physical, events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- needs testing
	[13286] = { itemName = "Rivenspike",                spellID = 17315, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[5426]  = { itemName = "Serpent's Kiss",            spellID = 18197, spellName = "Poison",           school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9608]  = { itemName = "Shoni's Disarming Tool",    spellID = 11879, spellName = "Disarm",           school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13408] = { itemName = "Soul Breaker",              spellID = 17506, spellName = "Soul Breaker",     school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[934]   = { itemName = "Stalvan's Reaper",          spellID = 13524, spellName = "Curse of Stalvan", school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9485]  = { itemName = "Vibroblade",                spellID = 11791, spellName = "Puncture Armor",   school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[15853] = { itemName = "Windreaper",                spellID = 20586, spellName = "Windreaper",       school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11920] = { itemName = "Wraith Scythe",             spellID = 16414, spellName = "Drain Life",       school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Maces ====
	[18671] = { itemName = "Baron Charr's Sceptre",       spellID = 13442, spellName = "Firebolt",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13204] = { itemName = "Bashguuder",                  spellID = 17315, spellName = "Puncture Armor",      school = L.SCHOOL.Physical, events = L.Events.TargetStackingAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[14487] = { itemName = "Bonechill Hammer",            spellID = 18276, spellName = "Frost Blast",         school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19170] = { itemName = "Ebon Hand",                   spellID = 18211, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17112] = { itemName = "Empyrean Demolisher",         spellID = 21165, spellName = "Haste",               school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.TargetSuperWow },
	[9386]  = { itemName = "Excavator's Brand",           spellID = 13438, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17943] = { itemName = "Fist of Stone",               spellID = 21951, spellName = "Fist of Stone",       school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[10804] = { itemName = "Fist of the Damned",          spellID = 18084, spellName = "Drain Life",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9419]  = { itemName = "Galgann's Firehammer",        spellID = 18083, spellName = "Firebolt",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9651]  = { itemName = "Gryphon Rider's Stormhammer", spellID = 18081, spellName = "Lightning Bolt",      school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[810]   = { itemName = "Hammer of the Northern Wind", spellID = 13439, spellName = "Frostbolt",           school = L.SCHOOL.Frost,    events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2243]  = { itemName = "Hand of Edward the Odd",      spellID = 18803, spellName = "Focus",               school = L.SCHOOL.Physical, events = L.Events.SelfAura,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11684] = { itemName = "Ironfoe",                     spellID = 15494, spellName = "Fury of Forgewright", school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks,       superWowEvents = L.Events.TargetSuperWow },
	[12794] = { itemName = "Masterwork Stormhammer",      spellID = 16921, spellName = "Chain Lightning",     school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[23221] = { itemName = "Misplaced Servo Arm",         spellID = 29150, spellName = "Electric Discharge",  school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[4090]  = { itemName = "Mug O' Hurt",                 spellID = 13496, spellName = "Dazed",               school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19908] = { itemName = "Sceptre of Smiting",          spellID = 24254, spellName = "Serpent's Hiss",      school = L.SCHOOL.Nature,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12781] = { itemName = "Serenity",                    spellID = 16908, spellName = "Dispel Magic",        school = L.SCHOOL.Arcane,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2256]  = { itemName = "Skeletal Club",               spellID = 13440, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6472]  = { itemName = "Stinging Viper",              spellID = 18197, spellName = "Poison",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13401] = { itemName = "The Cruel Hand of Timmy",     spellID = 17505, spellName = "Curse of Timmy",      school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9639]  = { itemName = "The Hand of Antu'sul",        spellID = 13532, spellName = "Thunder Clap",        school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[7954]  = { itemName = "The Shatterer",               spellID = 13534, spellName = "Disarm",              school = L.SCHOOL.Physical, events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13183] = { itemName = "Venomspitter",                spellID = 18203, spellName = "Poison",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12792] = { itemName = "Volcanic Hammer",             spellID = 18082, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,             superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Swords ====
	[13246] = { itemName = "Argent Avenger",                               spellID = 17352, spellName = "Argent Avenger",       school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[8223]  = { itemName = "Blade of the Basilisk",                        spellID = 10351, spellName = "Basilisk Skin",        school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10803] = { itemName = "Blade of the Wretched",                        spellID = 18088, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12777] = { itemName = "Blazing Rapier",                               spellID = 16898, spellName = "Blaze",                school = L.SCHOOL.Frost,    events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9511]  = { itemName = "Bloodletter Scalpel",                          spellID = 13486, spellName = "Wound",                school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[809]   = { itemName = "Bloodrazor",                                   spellID = 17504, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[14145] = { itemName = "Cursed Felblade",                              spellID = 18381, spellName = "Cripple",              school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[14576] = { itemName = "Ebon Hilt of Marduk",                          spellID = 18656, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11121] = { itemName = "Darkwater Talwar",                             spellID = 16408, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[869]   = { itemName = "Dazzling Longsword",                           spellID = 13752, spellName = "Faerie Fire",          school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10847] = { itemName = "Dragon's Call",                                spellID = 13049, spellName = "Dragon's Call",        school = L.SCHOOL.Physical, events = L.Events.Summon,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9446]  = { itemName = "Electrocutioner Leg",                          spellID = 13482, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10797] = { itemName = "Firebreather",                                 spellID = 16413, spellName = "Fireball",             school = L.SCHOOL.Fire,     events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12797] = { itemName = "Frostguard",                                   spellID = 16927, spellName = "Chilled",              school = L.SCHOOL.Frost,    events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[15814] = { itemName = "Hameya's Slayer",                              spellID = 16406, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[8190]  = { itemName = "Hanzo Sword",                                  spellID = 16405, spellName = "Wound",                school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[11086] = { itemName = "Jang'thraze the Protector",                    spellID = 11657, spellName = "Jang'thraze",          school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17054] = { itemName = "Joonho's Mercy",                               spellID = 20883, spellName = "Arcane Blast",         school = L.SCHOOL.Arcane,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11902] = { itemName = "Linken's Sword of Mastery",                    spellID = 18089, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11817] = { itemName = "Lord General's Sword",                         spellID = 15602, spellName = "Lord General's Sword", school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[7961]  = { itemName = "Phantom Blade",                                spellID = 9806,  spellName = "Phantom Strike",       school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2263]  = { itemName = "Phytoblade",                                   spellID = 14119, spellName = "Lightning Bolt",       school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[18348] = { itemName = "Quel'Serrar",                                  spellID = 22850, spellName = "Sanctuary",            school = L.SCHOOL.Physical, events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow },
	[1265]  = { itemName = "Scorpion Sting",                               spellID = 18208, spellName = "Poison",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13035] = { itemName = "Serpent Slicer",                               spellID = 17511, spellName = "Poison",               school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[754]   = { itemName = "Shortsword of Vengeance",                      spellID = 13519, spellName = "Holy Smite",           school = L.SCHOOL.Holy,     events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1482]  = { itemName = "Shadowfang",                                   spellID = 13440, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13953] = { itemName = "Silent Fang",                                  spellID = 18278, spellName = "Silence",              school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[8224]  = { itemName = "Silithid Ripper",                              spellID = 16403, spellName = "Rend",                 school = L.SCHOOL.Physical, events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13361] = { itemName = "Skullforge Reaver",                            spellID = 17484, spellName = "Skullforge Brand",     school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13032] = { itemName = "Sword of Corruption",                          spellID = 17510, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1727]  = { itemName = "Sword of Decay",                               spellID = 13528, spellName = "Decayed Strength",     school = L.SCHOOL.Nature,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6622]  = { itemName = "Sword of Zeal",                                spellID = 8191,  spellName = "Zeal",                 school = L.SCHOOL.Holy,     events = L.Events.SelfAura,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[8225]  = { itemName = "Tainted Pierce",                               spellID = 13530, spellName = "Corruption",           school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1728]  = { itemName = "Teebu's Blazing Longsword",                    spellID = 18086, spellName = "Firebolt",             school = L.SCHOOL.Fire,     events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12974] = { itemName = "The Black Knight",                             spellID = 14106, spellName = "Shadow Bolt",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17705] = { itemName = "Thrash Blade",                                 spellID = 21919, spellName = "Thrash",               school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks, superWowEvents = L.Events.TargetSuperWow },
	[19019] = { itemName = "Thunderfury, Blessed Blade of the Windseeker", spellID = 21992, spellName = "Thunderfury",          school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17075] = { itemName = "Vis'kag the Bloodletter",                      spellID = 21140, spellName = "Fatal Wound",          school = L.SCHOOL.Physical, events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[19901] = { itemName = "Zulian Slicer",                                spellID = 24251, spellName = "Zulian Slice",         school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	--endregion

	--region ==== Polearms ====
	[12583] = { itemName = "Blackhand Doomsaw",        spellID = 16549, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[7959]  = { itemName = "Blight",                   spellID = 9796,  spellName = "Blight",          school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[13057] = { itemName = "Bloodpike",                spellID = 18202, spellName = "Rend",            school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13148] = { itemName = "Chillpike",                spellID = 19260, spellName = "Frost Blast",     school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9475]  = { itemName = "Diabolic Skiver",          spellID = 18206, spellName = "Fatal Wound",     school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[11809] = { itemName = "Flame Wrath",              spellID = 16559, spellName = "Flame Wrath",     school = L.SCHOOL.Fire,     events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13054] = { itemName = "Grim Reaper",              spellID = 14126, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[19874] = { itemName = "Halberd of Smiting",       spellID = 25669, spellName = "Decapitate",      school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[1726]  = { itemName = "Poison-tipped Bone Spear", spellID = 16401, spellName = "Poison",          school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17074] = { itemName = "Shadowstrike",             spellID = 21170, spellName = "Drain Life",      school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12243] = { itemName = "Smoldering Claw",          spellID = 15662, spellName = "Fireball",        school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[13060] = { itemName = "The Needler",              spellID = 16405, spellName = "Wound",           school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[17223] = { itemName = "Thunderstrike",            spellID = 21179, spellName = "Chain Lightning", school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Staves ====
	[937]   = { itemName = "Black Duskwood Staff",         spellID = 18138, spellName = "Shadow Bolt",       school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10627] = { itemName = "Bludgeon of the Grinning Dog", spellID = 56,    spellName = "Stun",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[880]   = { itemName = "Staff of Horrors",             spellID = 8552,  spellName = "Curse of Weakness", school = L.SCHOOL.Shadow,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9477]  = { itemName = "The Chief's Enforcer",         spellID = 56,    spellName = "Stun",              school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Two-handed Axes ====
	[7753]  = { itemName = "Bloodspiller",                spellID = 18200, spellName = "Rend",                school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[1263]  = { itemName = "Brain Hacker",                spellID = 17148, spellName = "Brain Hacker",        school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[2299]  = { itemName = "Burning War Axe",             spellID = 18199, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[21134] = { itemName = "Dark Edge of Insanity",       spellID = 26108, spellName = "Glimpse of Madness",  school = L.SCHOOL.Shadow,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11607] = { itemName = "Dark Iron Sunderer",          spellID = 15280, spellName = "Cleave Armor",        school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, },
	[19353] = { itemName = "Drake Talon Cleaver",         spellID = 21140, spellName = "Fatal Wound",         school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[870]   = { itemName = "Fiery War Axe",               spellID = 18796, spellName = "Fireball",            school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17730] = { itemName = "Gatorbite Axe",               spellID = 21949, spellName = "Rend",                school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13983] = { itemName = "Gravestone War Axe",          spellID = 18289, spellName = "Creeping Mold",       school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2291]  = { itemName = "Kang the Decapitator",        spellID = 17153, spellName = "Rend",                school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13016] = { itemName = "Killmaim",                    spellID = 13318, spellName = "Rend",                school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[12250] = { itemName = "Midnight Axe",                spellID = 13440, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[21856] = { itemName = "Neretzek, The Blood Drinker", spellID = 26693, spellName = "Drain Life",          school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1318]  = { itemName = "Night Reaver",                spellID = 13480, spellName = "Shadow Bolt",         school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19169] = { itemName = "Nightfall",                   spellID = 23605, spellName = "Spell Vulnerability", school = L.SCHOOL.Physical, events = L.Events.TargetAura }, -- Does not trigger UNIT_CASTEVENT
	[9425]  = { itemName = "Pendulum of Doom",            spellID = 10373, spellName = "Fatal Wound",         school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[7717]  = { itemName = "Ravager",                     spellID = 9632,  spellName = "Bladestorm",          school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[13285] = { itemName = "The Blackrock Slicer",        spellID = 17407, spellName = "Wound",               school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true },
	[9486]  = { itemName = "Supercharger Battle Axe",     spellID = 13527, spellName = "Lightning Bolt",      school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	--endregion

	--region ==== Two-handed Maces ====
	[3194]  = { itemName = "Black Malice",                  spellID = 18205, spellName = "Shadow Bolt",            school = L.SCHOOL.Shadow,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[7730]  = { itemName = "Cobalt Crusher",                spellID = 18204, spellName = "Frost Blast",            school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[11608] = { itemName = "Dark Iron Pulverizer",          spellID = 15283, spellName = "Stunning Blow",          school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17073] = { itemName = "Earthshaker",                   spellID = 21152, spellName = "Earthshaker",            school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow },
	[11803] = { itemName = "Force of Magma",                spellID = 18086, spellName = "Firebolt",               school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[14531] = { itemName = "Frightskull Shaft",             spellID = 18633, spellName = "Weakening Disease",      school = L.SCHOOL.Shadow,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[5815]  = { itemName = "Glacial Stone",                 spellID = 20869, spellName = "Frost Blast",            school = L.SCHOOL.Frost,    events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12796] = { itemName = "Hammer of the Titans",          spellID = 56,    spellName = "Stun",                   school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19918] = { itemName = "Jeklik's Crusher",              spellID = 24257, spellName = "Jeklik's Crushing Blow", school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13393] = { itemName = "Malown's Slam",                 spellID = 17500, spellName = "Malown's Slam",          school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- This weapon has both a 2 sec enemy debuff and a 30 sec self buff.
	[17766] = { itemName = "Princess Theradras' Scepter",   spellID = 21961, spellName = "Wound",                  school = L.SCHOOL.Physical, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[10626] = { itemName = "Ragehammer",                    spellID = 12686, spellName = "Enrage",                 school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12969] = { itemName = "Seeping Willow",                spellID = 17196, spellName = "Seeping Willow",         school = L.SCHOOL.Nature,   events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing - This is AOE and needs specific testing
	[15418] = { itemName = "Shimmering Platinum Warhammer", spellID = 19874, spellName = "Lightning Bolt",         school = L.SCHOOL.Nature,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[17182] = { itemName = "Sulfuras, Hand of Ragnaros",    spellID = 21162, spellName = "Fireball",               school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[17193] = { itemName = "Sulfuron Hammer",               spellID = 21159, spellName = "Fireball",               school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2915]  = { itemName = "Taran Icebreaker",              spellID = 16415, spellName = "Fireball",               school = L.SCHOOL.Fire,     events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12528] = { itemName = "The Judge's Gavel",             spellID = 56,    spellName = "Stun",                   school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19323] = { itemName = "The Unstoppable Force",         spellID = 23454, spellName = "Stun",                   school = L.SCHOOL.Physical, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9423]  = { itemName = "The Jackhammer",                spellID = 13533, spellName = "Haste",                  school = L.SCHOOL.Physical, events = L.Events.SelfAura,   superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Two-handed Swords ====
	[12790] = { itemName = "Arcanite Champion",     spellID = 16916, spellName = "Strength of the Champion", school = L.SCHOOL.Holy,     events = L.Events.SelfHeal,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[2000]  = { itemName = "Archeus",               spellID = 18091, spellName = "Arcane Blast",             school = L.SCHOOL.Arcane,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[14541] = { itemName = "Barovian Family Sword", spellID = 18652, spellName = "Siphon Health",            school = L.SCHOOL.Shadow,   events = L.Events.TargetAura,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12592] = { itemName = "Blackblade of Shahram", spellID = 16602, spellName = "Shahram",                  school = L.SCHOOL.Arcane,   events = L.Events.Summon,           superWowEvents = L.Events.TargetSuperWow },
	[17076] = { itemName = "Bonereaver's Edge",     spellID = 21153, spellName = "Bonereaver's Edge",        school = L.SCHOOL.Shadow,   events = L.Events.SelfStackingAura, superWowEvents = L.Events.TargetSuperWow },
	[22691] = { itemName = "Corrupted Ashbringer",  spellID = 29155, spellName = "Drain Life",               school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[10628] = { itemName = "Deathblow",             spellID = 16411, spellName = "Fatal Wound",              school = L.SCHOOL.Physical, events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[13348] = { itemName = "Demonshear",            spellID = 17483, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow },
	[647]   = { itemName = "Destiny",               spellID = 17152, spellName = "Destiny",                  school = L.SCHOOL.Physical, events = L.Events.SelfAura,         superWowEvents = L.Events.TargetSuperWow },
	[13053] = { itemName = "Doombringer",           spellID = 18211, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12463] = { itemName = "Drakefang Butcher",     spellID = 14118, spellName = "Rend",                     school = L.SCHOOL.Physical, events = L.Events.TargetAura,       superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[2205]  = { itemName = "Duskbringer",           spellID = 18217, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[3854]  = { itemName = "Frost Tiger Blade",     spellID = 13439, spellName = "Frostbolt",                school = L.SCHOOL.Frost,    events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1387]  = { itemName = "Ghoulfang",             spellID = 16409, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1986]  = { itemName = "Gutrender",             spellID = 18090, spellName = "Wound",                    school = L.SCHOOL.Physical, events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow, isPhantomStrike = true }, -- Needs testing
	[21679] = { itemName = "Kalimdor's Revenge",    spellID = 26415, spellName = "Shock",                    school = L.SCHOOL.Nature,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[1982]  = { itemName = "Nightblade",            spellID = 18211, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[3822]  = { itemName = "Runic Darkblade",       spellID = 16409, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[12992] = { itemName = "Searing Blade",         spellID = 16413, spellName = "Fireball",                 school = L.SCHOOL.Fire,     events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[5182]  = { itemName = "Shiver Blade",          spellID = 18092, spellName = "Frost Blast",              school = L.SCHOOL.Frost,    events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[18410] = { itemName = "Sprinter's Sword",      spellID = 22863, spellName = "Speed",                    school = L.SCHOOL.Physical, events = L.Events.SelfAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9418]  = { itemName = "Stoneslayer",           spellID = 12731, spellName = "Strength of Stone",        school = L.SCHOOL.Physical, events = L.Events.SelfAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[6909]  = { itemName = "Strike of the Hydra",   spellID = 13526, spellName = "Corrosive Poison",         school = L.SCHOOL.Nature,   events = L.Events.TargetAura,       superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[9372]  = { itemName = "Sul'thraze the Lasher", spellID = 11658, spellName = "Sul'thraze",               school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[19334] = { itemName = "The Untamed Blade",     spellID = 23719, spellName = "Untamed Fury",             school = L.SCHOOL.Physical, events = L.Events.SelfAura,         superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	[7960]  = { itemName = "Truesilver Champion",   spellID = 9800,  spellName = "Holy Shield",              school = L.SCHOOL.Holy,     events = L.Events.SelfAura,         superWowEvents = L.Events.TargetSuperWow },
	[13051] = { itemName = "Witchfury",             spellID = 18214, spellName = "Shadow Bolt",              school = L.SCHOOL.Shadow,   events = L.Events.Damage,           superWowEvents = L.Events.TargetSuperWow }, -- Needs testing
	--endregion

	--region ==== Trinkets ====
	[19287] = { itemName = "Darkmoon Card: Heroism",   spellID = 23689, spellName = "Heroism",          school = L.SCHOOL.Holy,     events = L.Events.SelfHeal,     superWowEvents = L.Events.SelfSuperWow },
	[19289] = { itemName = "Darkmoon Card: Maelstrom", spellID = 23687, spellName = "Lightning Strike", school = L.SCHOOL.Nature,   events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow },
	[11815] = { itemName = "Hand of Justice",          spellID = 15601, spellName = "Hand of Justice",  school = L.SCHOOL.Physical, events = L.Events.ExtraAttacks, superWowEvents = L.Events.SelfSuperWow }, -- 2% chance, 2 sec cooldown
	[22321] = { itemName = "Heart of Wyrmthalak",      spellID = 27656, spellName = "Flame Lash",       school = L.SCHOOL.Fire,     events = L.Events.Damage,       superWowEvents = L.Events.TargetSuperWow },
	--endregion
}

L.Enchants = {
	[1900] = { enchantName = "Crusader",      enchantID = 20034, spellID = 20007, spellName = "Holy Strength", school = L.SCHOOL.Holy,   events = L.Events.SelfHeal,   superWowEvents = L.Events.SelfSuperWow },
	[912]  = { enchantName = "Demonslaying",  enchantID = 13915, spellID = 13907, spellName = "Smite Demon",   school = L.SCHOOL.Holy,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[803]  = { enchantName = "Fiery Weapon",  enchantID = 13898, spellID = 13897, spellName = "Fiery Weapon",  school = L.SCHOOL.Fire,   events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[1894] = { enchantName = "Icy Weapon",    enchantID = 20029, spellID = 20005, spellName = "Chilled",       school = L.SCHOOL.Frost,  events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow},
	[1898] = { enchantName = "Lifestealing",  enchantID = 20032, spellID = 20004, spellName = "Life Steal",    school = L.SCHOOL.Shadow, events = L.Events.Damage,     superWowEvents = L.Events.TargetSuperWow },
	[1899] = { enchantName = "Unholy Weapon", enchantID = 20033, spellID = 20006, spellName = "Unholy Curse",  school = L.SCHOOL.Shadow, events = L.Events.TargetAura, superWowEvents = L.Events.TargetSuperWow },
}

-- 1.12 cannot get the temp enchant ID via GetWeaponEnchantInfo()
-- so name and tooltip scanning will be the way it is found
L.TemporaryEnchants = {
	["Frost Oil"]  = { itemID = 3829, enchantID = 26, spellID = 205, spellName = "Frostbolt",   school = L.SCHOOL.Frost,  events = L.Events.Damage, superWowEvents = L.Events.TargetSuperWow },
	["Shadow Oil"] = { itemID = 3824, enchantID = 25, spellID = 705, spellName = "Shadow Bolt", school = L.SCHOOL.Shadow, events = L.Events.Damage, superWowEvents = L.Events.TargetSuperWow },
}

L.Buffs = {
	[15852] = { itemID = 12217, buffName = "Dragonbreath Chili", spellID = 15851, spellName = "Dragonbreath Chili", school = L.SCHOOL.Fire, events = L.Events.Damage, superWowEvents = L.Events.TargetSuperWow },
}