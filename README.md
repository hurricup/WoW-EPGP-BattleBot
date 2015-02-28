#DESCRIPTION
World of Warcraft addon for automatic GP charging by combatlog events: deaths,
damage, debuffs. May be useful for new encounters and save your raid time.

You may add/remove/enable/disable rules via console commands.

#CONFIGURATION
Addon configuration may be managed via `/epgpbb` slash commands:

* `/epgpbb help` - display configuration help 
* `/epgpbb list` - list of current configuration
* `/epgpbb add GP_value on ...` - add new rule to charge GP on event
** `death by spell_id` - charge GP on taking damage with overkill from spell by id
** `damage by spell_id` - charge GP on taking damage from spell by id
** `buff spell_id [stacks min_staks] - charge GP to players, gathered min_staks of buff/debuff
* `/epgpbb del [rule id]` - delete rule by id
* `/epgpbb enable [rule id]` - enable rule by id
* `/epgpbb disable [rule id]` - disable rule by id

#LINKS
* Repository: https://github.com/hurricup/WoW-EPGP-BattleBot
* Bug tracker: https://github.com/hurricup/WoW-EPGP-BattleBot/issues

#AUTHOR
(c) 2015 Alexandr Evstigneev (hurricup@evstigneev.com)
