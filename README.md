# ProcScience for 1.12.1

This addon is a backport of the addon of the same name for the Classic 1.14 game cleint.
It helps with tracking number of hits and procs from various items in Vanilla World of Warcraft.
The addon calculates what the proc percentage chance of an item is and the estimated Procs-Per-Minute (PPM) of the item.

![Tracking](https://github.com/DBFBlackbull/ProcScience/raw/vanilla/img/proc-science-tracking.png)
![Print Stats](https://github.com/DBFBlackbull/ProcScience/raw/vanilla/img/proc-science-stats.png)
![Proc notification](https://github.com/DBFBlackbull/ProcScience/raw/vanilla/img/proc-science-notify.png)

**The addon is not perfect yet!** If you find any bugs or procs that are not being tracked or recoded, please let me know.

## Functionality

The addon will show you what items you have equipped that are being tracked.
Every time you attack, either with an auto attack or with an ability, it will be counted.
Every time your item procs it will track that and use these two numbers to calculate proc chance and PPM

Your statistics are saved between game sessions per character, so you can log out and log back in to continue testing.

## Limitation

 - The 1.12.1 client is limited in the information given in the combat log which causes this version to be less rigours than the 1.14 counterpart.
 - This addon only works for the English client. No work have gone into localization.
 - The addon only tracks a handful of manually added items, so if your item of interest is not being tracked, please either modify the `Procs.lua` file or create an issue on github.

## Errors and uncertainty

The 1.12.1 client gives no information about if the main hand or offhand made an auto attack.
Therefore, all testing should be done with only 1 weapon equipped in the main hand.

Due to limitations on the 1.12.1 client information about combat log events are limit.
The information available is in the form of:
 - `You gain 1 extra attack through Hand of Justice.`
 - `Your Fireball hits Winterfall Den Watcher for 302 Fire damage.`
 - `You gain Destiny.`
 - `Winterfall Den Watcher is afflicted by Spell Vulnerability.`

This can cause potential error sources to the data.

### Items that proc extra attacks are safe

These include:
 - [[Hand of Justice]](https://www.wowhead.com/classic/item=11815/hand-of-justice)
 - [[Ironfoe]](https://www.wowhead.com/classic/item=11684/ironfoe)
 - [[Thrash Blade]](https://www.wowhead.com/classic/item=17705/thrash-blade)

These procs contains the wording "You gain X extra attack" and can be detected without error.

### Items that proc direct damage are likely safe.

These inclide:
 - [[Sulfuras, Hand of Ragnaros]](https://www.wowhead.com/classic/item=17182/sulfuras-hand-of-ragnaros)
 - [[Drake Talon Cleaver]](https://www.wowhead.com/classic/item=19353/drake-talon-cleaver)
 - [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger)

These procs contains the wordings:
 - `Your Fireball hits Winterfall Den Watcher for 302 Fire damage.`
 - `Your Frostbolt crits Winterfall Den Watcher for 400 Frost damage.`
 - `Your Fatal Wound is parried by Winterfall Den Watcher.`

The procs always come from you, so other players cannot interfer.
The procs rely on the spell name which is not unique, so if a Mage equips a [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger) and casts Frostbolt, then every cast will be considered as a proc.

### Items that proc a buff are somewhat reliable:

These include:
 - [[Destiny]](https://www.wowhead.com/classic/item=647/destiny)
 - [[Bonereaver's Edge]](https://www.wowhead.com/classic/item=17076/bonereavers-edge)
 - [[Truesilver Champion]](https://www.wowhead.com/classic/item=7960/truesilver-champion)

These procs contains the wordings:
 - `You gain Destiny.`
 - `You gain Bonereaver's Edge (2).`
 - `You gain Holy Shield.`

These procs rely on having a unique name for the buff they provide. Therefore, [[Destiny]](https://www.wowhead.com/classic/item=647/destiny) and [[Bonereaver's Edge]](https://www.wowhead.com/classic/item=17076/bonereavers-edge) are safe. [[Truesilver Champion]](https://www.wowhead.com/classic/item=7960/truesilver-champion) equipped by a Protection Paladin will count a proc every time [[Holy Shield]](https://www.wowhead.com/classic/spell=20928/holy-shield) (the paladin spell) is cast because it matches the name of the weapon proc [[Holy Shield]](https://www.wowhead.com/classic/spell=9800/holy-shield).

**If a buff is refreshed it is not detected by the addon!**

The 1.12 combat log only reports if a player gets a new buff.
 - If an exiting buff, like [[Destiny]](https://www.wowhead.com/classic/spell=17152/destiny), has 2 seconds left and is refreshed, then no combat log event is posted, and therefore no proc can be detected.
 - If an existing stackable buffs like [[Bonereaver's Edge]](https://www.wowhead.com/classic/spell=21153/bonereavers-edge) is at max stacks, has 2 seconds left, and is refreshed, then no combat log event is posted, and therefore no proc can be detected.

### Items that only proc a debuff on the target (no damage) are unsafe.

These include:
 - [[Nightfall]](https://www.wowhead.com/classic/item=19169/nightfall) proccing [Spell Vulnerability](https://www.wowhead.com/classic/spell=23605/spell-vulnerability)
 - [[Annihilator]](https://www.wowhead.com/classic/item=12798/annihilator) proccing [[Armor Shatter]](https://www.wowhead.com/classic/spell=16928/armor-shatter)
 - [[Bashguuder]](https://www.wowhead.com/classic/item=13204/bashguuder) proccing [[Puncture Armor]](https://www.wowhead.com/classic/spell=17315/puncture-armor)

Since the combat log event for these items are of the format:
 - `Winterfall Den Watcher is afflicted by Spell Vulnerability.`
 - `Winterfall Den Watcher is afflicted by Armor Shatter (2).`
 - `Winterfall Den Watcher is afflicted by Puncture Armor (3).`

These events cannot be reliable determined to come from the player character or from the characters weapon.
 - If multiple people are testing [[Nightfall]](https://www.wowhead.com/classic/item=19169/nightfall) against mobs of the same name, then a proc of [Spell Vulnerability](https://www.wowhead.com/classic/spell=23605/spell-vulnerability) for one character will count as every player's Nightfall just procced. In a raid with multiple Nightfall's this can easily occur.

Therefore, it is best to test these weapons in a safe environment alone, away from other players.

**If a debuff is refreshed then it is not detected by the addon!**

The 1.12 combat log only reports if a unit gets a new debuff.
 - If an existing debuff, like [[Spell Vulnerability]](https://www.wowhead.com/classic/spell=23605/spell-vulnerability), has 2 seconds left and is refreshed, then no combat log event is posted, and therefore no proc can be detected.
 - If an existing stackable debuffs like [[Armor Shatter]](https://www.wowhead.com/classic/spell=16928/armor-shatter) or [[Puncture Armor]](https://www.wowhead.com/classic/spell=17315/puncture-armor) is at max stacks, has 2 seconds left, and is refreshed, then no combat log event is posted, and therefore no proc can be detected.

## SuperWow Improvements

If you use [SuperWoW](https://github.com/balakethelock/SuperWoW) then almost all procs have 100% accuracy.

SuperWoW introduces a new event `UNIT_CASTEVENT` that fires every time a spell or ability is used which includes procs. The event contains:
 - The caster GUID
 - The target GUID
 - The spellID

Some of the edge cases above that are handled
 - The spellID ensures that no spell name duplication triggers false positives. For instance: [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger)'s [[Frostbolt]](https://www.wowhead.com/classic/spell=13439/frostbolt) has a different spellID from a mages [[Frostbolt]](https://www.wowhead.com/classic/spell=25304/frostbolt)
 - Buff refreshes are now tracked because `UNIT_CASTEVENT` is always fired, even when an existing buffs is still active
 - Debuff refhreses are now tracked because `UNIT_CASTEVENT` is always fired, even when an existing debuff is still active.

### SuperWoW exceptions

Even though SupwerWoW has some information about Main hand and Off-hand attacks, this information is not enough to determine which hand procced an effect. Therefore, all testing should still be done with only 1 weapon equipped in the main hand.

3 buffs have been found that triggers without any `UNIT_CASTEVENT` firing, which excepts them from the SuperWoW improvements. These are:
 - [[Nightfall]](https://www.wowhead.com/classic/item=19169/nightfall) proccing [Spell Vulnerability](https://www.wowhead.com/classic/spell=23605/spell-vulnerability)
 - [[Annihilator]](https://www.wowhead.com/classic/item=12798/annihilator) proccing [[Armor Shatter]](https://www.wowhead.com/classic/spell=16928/armor-shatter)
 - [[Dark Iron Sunderer]](https://www.wowhead.com/classic/item=11607/dark-iron-sunderer) proccing [[Cleave Armor]](https://www.wowhead.com/classic/spell=15280/cleave-armor)

Ironicly these 3 debuffs have the highest viability in raids and are therefore most tested while being in the most unreliable group. These would have benefited the most from being made secure by SupwerWoW.

# ProcScience from Classic WoW Armaments

This addon is based on the addon from the Classic WoW Armaments Discord server: https://discord.gg/NKjS5KKk.
This is not the official github repository of this addon. No official repository seems exists.
If you need the 1.14 Classic version of the addon switch to the "classic" branch where the original addon is placed.

I do not own the discord server, the original addon or is affiliated with either in any way.
