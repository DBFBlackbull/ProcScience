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
Therefore all testing should be done with only 1 weapon equiped in the main hand.

Due to limitations on the 1.12.1 client information about combat log events are limit.
The information available is in the form of:
 - `You gain 1 extra attack through Hand of Justice.`
 - `You gain Destiny.`
 - `Winterfall Den Watcher is afflicted by Spell Vulnerability.`

This can cause potential error sources to the data.

### Items that proc extra attacks are safe

These include:
 - [[Hand of Justice]](https://www.wowhead.com/classic/item=11815/hand-of-justice)
 - [[Ironfoe]](https://www.wowhead.com/classic/item=11684/ironfoe)
 - [[Thrash Blade]](https://www.wowhead.com/classic/item=17705/thrash-blade)

Since these procs only affect your character and contains the wording "extra attack" they can be detected without error.

### Items that proc a buff are somewhat reliable:

These include:
 - [[Destiny]](https://www.wowhead.com/classic/item=647/destiny)
 - [[The Untamed Blade]](https://www.wowhead.com/classic/item=19334/the-untamed-blade)
 - [[Felstriker]](https://www.wowhead.com/classic/item=12590/felstriker)

These procs rely on having a unique name for the buff they provide.
If a weapons buff was called "Mark of the Wild", it would be indistinguishable from a druid buffing the player and would cause a proc to be tracked when it did not happen.
Luckily most item buffs are uniquely named so it is rarely a problem.

**If a buff is refreshed then it is not detected by the addon!**

The 1.12 combat log only reports if a player gets a new buff.
If an exiting buff, like [[Destiny]](https://www.wowhead.com/classic/spell=17152/destiny), has 2 seconds left and is refreshed, then no combat log event is posted, and therefore no proc is be detected.

### Items that proc on the opponent are likely unsafe.

These include:
 - [[Nightfall]](https://www.wowhead.com/classic/item=19169/nightfall) proccing [Spell Vulnerability](https://www.wowhead.com/classic/spell=23605/spell-vulnerability)
 - [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger) proccing [Frostbolt](https://www.wowhead.com/classic/spell=13439/frostbolt)
 - [[Alcor's Sunrazor]](https://www.wowhead.com/classic/item=14555/alcors-sunrazor) proccing [Firebolt](https://www.wowhead.com/classic/spell=18833/firebolt)

Since the combat log event for these items are of the format:
 - `Winterfall Den Watcher is afflicted by Spell Vulnerability.`
 - `Winterfall Den Watcher is afflicted by Frostbolt.`
 - `Winterfall Den Watcher takes 75 fire damage from Firebolt.`

These events cannot be reliable determined to come from the player character or from the characters weapon.
Issues arise in the following situations:
 - If you are testing a [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger) against a 'Winterfall Den Watcher' and a nearby Mage is also farming 'Winterfall Den Watcher' with [Frostbolt](https://www.wowhead.com/classic/spell=25304/frostbolt), then the addon cannot tell if the 'Winterfall Den Watcher' is afflicted by [[Coldrage Dagger]](https://www.wowhead.com/classic/item=10761/coldrage-dagger)'s [Frostbolt](https://www.wowhead.com/classic/spell=13439/frostbolt) or Mage [Frostbolt](https://www.wowhead.com/classic/spell=25304/frostbolt). Thus, incorrect data will be tracked.
 - The same goes for [[Alcor's Sunrazor]](https://www.wowhead.com/classic/item=14555/alcors-sunrazor) proccing [Firebolt](https://www.wowhead.com/classic/spell=18833/firebolt) being indistinguishable from a Warlock Imp using [Firebolt](https://www.wowhead.com/classic/spell=11763/firebolt).
 - If multiple people are testing [[Nightfall]](https://www.wowhead.com/classic/item=19169/nightfall) against mobs of the same name, then a proc of [Spell Vulnerability](https://www.wowhead.com/classic/spell=23605/spell-vulnerability) for one character will count as every player's Nightfall just procced. 

Therefore, it is best to test these weapons in a safe environment.
Either alone or away from classes that can cause errors.

**If a debuff is refreshed then it is not detected by the addon!**

The 1.12 combat log only reports if a unit gets a new debuff.
If an exiting debuff, like [[Spell Vulnerability]](https://www.wowhead.com/classic/spell=23605/spell-vulnerability), has 2 seconds left and is refreshed, then no combat log event is posted, and therefore no proc is be detected.

# ProcScience from Classic WoW Armaments

This addon is based on the addon from the Classic WoW Armaments Discord server: https://discord.gg/NKjS5KKk.
This is not the official github repository of this addon. No official repository seems exists.
If you need the 1.14 Classic version of the addon switch to the "classic" branch where the original addon is placed.

I do not own the discord server, the original addon or is affiliated with either in any way.
