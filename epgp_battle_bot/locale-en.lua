EPGP_BB_HELP = {
    "WowRaider.Net EPGP Battle Bot %s.\nConfigurable by /epgpbb or /ebb commands. Options list:",
    "  /ebb help - display configuration help (NYI)",
    "  /ebb status - displays current addon settings",
    "  /ebb announce (say|guild|raid|party) - announce active rules to the specific channel (raid by default, say if not in raid)",
    "  /ebb list - display the list of current rules",
    "  /ebb add value (EP|GP) on event - add new rule to charge GP or EP on event. Negative values are supported. Events are:",
    "    death by spell_id - charge GP on taking damage with overkill from spell by id",
    "    damagetaken by spell_id - charge GP on taking damage from spell by id",
    "    buff spell_id [min_staks] - charge GP to players, gained min_staks of buff/debuff, 1 by default",
    "  /ebb protect by - protect from damage taken penalties of penalty_class by conditions:",
    "    cast spell_id - casting spell with spell_id (long important heals)",
    "    buff spell_id - having buff with spell_id (anti-magic shell)",
    "  /ebb del rule_id - delete rule by id",
    "  /ebb enable rule_id - enable rule by id",
    "  /ebb disable rule_id - disable rule by id",
    "  /ebb reset - reset configuraion, delete all rules",
    "  /ebb autologging (on|off) - enables or disables automatic combatlogging on on/off command",
    "  /ebb on - enables monitoring, start combat logging, put this in pull macro",
    "  /ebb off - disables monitoring, stops combat logging, put this in wipe macro",
}
EPGP_BB_CONFIG_RESET = "Configuration has been reset\n"
EPGP_BB_RULE_PH = "%d: (%s) %s" -- rule number, status, rule text

EPGP_BB_RULE_PROTECT_CAST_PH = "immune to damage penalties while casting %s"
EPGP_BB_RULE_PROTECT_BUFF_PH = "immune to damage penalties with buff %s"

EPGP_BB_RULE_DAMAGE_TAKEN_BY_PH = "%d %s for taking damage from %s"
EPGP_BB_RULE_DEATH_BY_PH = "%d %s for death from %s"
EPGP_BB_RULE_BUFF_BY_PH = "%d %s for gaining buff %s"
EPGP_BB_RULE_BUFF_STACKS_BY_PH = "%d %s for gaining %d stacks of the buff %s"

EPGP_BB_ACTIVE_RULES_HEADER = "List of active penalties:"
EPGP_BB_RULE_NOT_FOUND = "Error: unable to find rule %s. Here is the list of available rules:"
EPGP_BB_RULE_ENABLED = "Enabled rule: %s"
EPGP_BB_RULE_DISABLED = "Disabled rule: %s"
EPGP_BB_RULE_DELETED = "Deleted rule: %s"
EPGP_BB_ENABLED = "enabled"
EPGP_BB_DISABLED = "disabled"
EPGP_BB_SPELL_LINK = "|cff71d5ff|Hspell:%d|h[%s]|h|r"
EPGP_BB_CREATED_RULE = "Created rule: %s"
EPGP_BB_REPLACED_RULE = "Replaced rule: '%s' with '%s'"
EPGP_BB_ADDON_ENABLED = "EPGP Battle Bot enabled, be careful"
EPGP_BB_ADDON_DISABLED = "EPGP Battle Bot disabled, relax"
EPGP_BB_LOGGING_ENABLED = "Combatlog recording turned on"
EPGP_BB_LOGGING_DISABLED = "Combatlog recording turned off"

EPGP_BB_AUTOLOGGING_ENABLED = "Automatic combatlogging control enabled"
EPGP_BB_AUTOLOGGING_DISABLED = "Automatic combatlogging control disabled"
