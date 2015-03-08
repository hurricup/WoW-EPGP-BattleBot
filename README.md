#DESCRIPTION
World of Warcraft addon for automatic EP/GP charging by combatlog events: deaths, damage, debuffs, interrupts and dispels. May be useful for saving your raid time due to the new encounters mastering.

You may add/remove/enable/disable rules via console commands.

#DEPENDENCIES

This addon works only with [epgp addon](http://www.curse.com/addons/wow/epgp-dkp-reloaded) installed.

#CONFIGURATION
Addon configuration may be managed via `/epgpbb` or `/ebb` slash commands:

* `/ebb help` - display configuration help 
* `/ebb status` - display addon settings
* `/ebb announce (say|guild|raid|party)` - announce active rules to a channel. Raid by default, or say if player is not in raid
* `/ebb list` - list of current configuration and rules
* `/ebb add value (GP|EP) for event` - add new rule to charge GP or EP on event. Negative values supported. Events are:
  * `death by spell_id` - taking damage with overkill from spell by id
  * `damagetaken by spell_id` - taking damage from spell by id
  * `buff by spell_id [min_stacks]` - gaining min_stacks of buff/debuff. 1 by default
  * `interrupt spell_id` - interrupting spell
  * `dispel spell_id` - dispelling/spellstealing spell
* `/ebb protect by` - protect from damage taken penalties of penalty_class by conditions:
  * `cast spell_id` - casting spell with spell_id (long important heals)
  * `buff spell_id` - having buff with spell_id (anti-magic shell)
* `/ebb del rule_id` - delete rule by id
* `/ebb enable rule_id` - enable rule by id
* `/ebb disable rule_id` - disable rule by id
* `/ebb reset` - reset configuration, delete all rules. Note: no confirmation asked
* `/ebb autologging (on|off)` - enables or disables automatic combatlogging on on/off command
* `/ebb on` - enables monitoring, start combat logging if autologging is enabled (put this in pull macro)
* `/ebb off` - disables monitoring, stops combat logging if autologging is disabled (put this in wipe macro)

#EXAMPLE RULES
My guilds Blackrock Foundry penalties (except last boss and Blast Furnance)

    /ebb add 150 GP for death by 156554       
    /ebb add 150 GP for buff by 154960        
    /ebb add 50 GP for damagetaken by 157247  
    /ebb add 50 GP for damagetaken by 158140  
    /ebb add 50 GP for damagetaken by 161570  
    /ebb add 150 GP for death by 156938       
    /ebb add 150 GP for death by 154938       
    /ebb add 50 GP for buff by 155314         
    /ebb add 150 GP for buff by 154989 3      
    /ebb add 150 GP for damagetaken by 160050 
    /ebb add 150 GP for damagetaken by 157659 
    /ebb add 150 GP for damagetaken by 161839 
    /ebb add 150 GP for damagetaken by 157884 
    /ebb add 150 GP for damagetaken by 160733 
    /ebb add 150 GP for damagetaken by 176133

#LINKS
* [Curse page](http://www.curse.com/addons/wow/epgp-battle-bot)
* [Repository](https://github.com/hurricup/WoW-EPGP-BattleBot)
* [Bug tracker](https://github.com/hurricup/WoW-EPGP-BattleBot/issues)

#AUTHOR
(c) 2015 Alexandr Evstigneev (hurricup@evstigneev.com)
