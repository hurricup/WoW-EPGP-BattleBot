#DESCRIPTION
World of Warcraft addon for automatic GP charging by combatlog events: deaths,
damage, debuffs. May be useful for saving your raid time due to the new 
encounters mastering.

You may add/remove/enable/disable rules via console commands.

#DEPENDENCIES

This addon works only with epgp addon installed:

* http://www.curse.com/addons/wow/epgp-dkp-reloaded

#CONFIGURATION
Addon configuration may be managed via `/epgpbb` or `/ebb` slash commands:

* `/ebb help` - display configuration help 
* `/ebb announce` - announce active rules to a raid chat
* `/ebb list` - list of current configuration
* `/ebb add GP_value on event` - add new rule to charge GP on event. Events are:
  * `death by spell_id` - charge GP on taking damage with overkill from spell by id
  * `damagetaken by spell_id` - charge GP on taking damage from spell by id
  * `buff by spell_id [stacks min_stacks]` - charge GP to players, gained min_stacks of buff/debuff. 1 by default
* `/ebb del rule_id` - delete rule by id
* `/ebb enable rule_id` - enable rule by id
* `/ebb disable rule_id` - disable rule by id
* `/ebb reset` - reset configuration

#LINKS
* Repository: https://github.com/hurricup/WoW-EPGP-BattleBot
* Bug tracker: https://github.com/hurricup/WoW-EPGP-BattleBot/issues

#AUTHOR
(c) 2015 Alexandr Evstigneev (hurricup@evstigneev.com)
