local L = ProcScience_L

L.WARRIOR = {
	Damage = {
		["Heroic Strike"] =  { spellID = 78 },
		["Hamstring"]     =  { spellID = 7373 },
		["Overpower"]     =  { spellID = 7384 },
		["Revenge"]       =  { spellID = 6572 },
		["Mocking Blow"]  =  { spellID = 694 },
		["Execute"]       =  { spellID = 5308 },
		["Slam"]          =  { spellID = 1464 },
		["Pummel"]        =  { spellID = 6552 },
		["Bloodthirst"]   =  { spellID = 23881 },
		["Mortal Strike"] =  { spellID = 12294 },
		["Retaliation"]   =  { spellID = 20240 },
	},
	AreaEffect = {
		["Cleave"]    = { spellID = 845 },
		["Whirlwind"] = { spellID = 1680 },
	},
	Aura = {
		["Disarm"]       = { spellID = 676 },
		["Rend"]         = { spellID = 772 },
		["Sunder Armor"] = { spellID = 7386 },
	},
	GCDSpell = "Battle Shout"
}

L.PALADIN = {
	Damage = {
		["Seal of Righteousness"] = { spellID = 21084, isPhantomStrike = true },
		["Seal of Command"]       = { spellID = 20375 },
		["Judgement of Command"]  = { spellID = 20467 },
	},
	Aura = {
	},
	GCDSpell = "Holy Light"
}

L.ROGUE = {
	Damage = {
		["Backstab"]        = { spellID = 53 },
		["Gouge"]           = { spellID = 1776 },
		["Kick"]            = { spellID = 1766 },
		["Sinister Strike"] = { spellID = 1752 },
		["Eviscerate"]      = { spellID = 2098 },
		["Ambush"]          = { spellID = 8676 },
		["Riposte"]         = { spellID = 14251 },
		["Hemorrhage"]      = { spellID = 16511 },
	},
	Aura = {
		["Cheap Shot"]  = { spellID = 1833 },
		["Kidney Shot"] = { spellID = 408 },
		["Garrote"]     = { spellID = 703 },
		["Rupture"]     = { spellID = 1943 },
		["Sap"]         = { spellID = 6770 },
	},
	GCDSpell = "Sinister Strike"
}

L.SHAMAN = {
	Damage = {
		["Stormstrike"] = {spellID = 17364}
	},
	Aura = {
	},
	GCDSpell = "Lightning Bolt"
}