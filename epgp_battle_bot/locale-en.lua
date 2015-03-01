EPGP_BB_HELP = "WowRaider.Net EPGP Battle Bot %s.\nConfigurable by /epgpbb or /ebb commands. Options list:\n"
    .."   /ebb help - display configuration help\n"
    .."   /ebb announce say|guild|raid|party - announce active rules to the specific channel (raid by default)\n"
    .."   /ebb list - display the list of current rules\n"
    .."   /ebb add GP_value on event - add new rule to charge GP on event. Events are:\n"
    .."       death by spell_id - charge GP on taking damage with overkill from spell by id\n"
    .."       damagetaken by spell_id - charge GP on taking damage from spell by id\n"
    .."       buff spell_id [stacks min_staks] - charge GP to players, gathered min_staks of buff/debuff\n"
    .."   /ebb del rule_id - delete rule by id\n"
    .."   /ebb enable rule_id - enable rule by id\n"
    .."   /ebb disable rule_id - disable rule by id\n"
    .."   /ebb reset - reset configuraion, delete all rules\n"
EPGP_BB_CONFIG_RESET = "Configuration has been reset\n"
EPGP_BB_RULE_PH = "%d: (%s) %s" -- rule number, status, rule text
EPGP_BB_RULE_DEATH_BY_PH = "%d GP for death from %s"
EPGP_BB_RULE_BUFF_BY_PH = "%d GP for gaining buff %s"
EPGP_BB_RULE_DAMAGE_TAKEN_BY_PH = "%d GP for taking damage from %s"
EPGP_BB_ACTIVE_RULES_HEADER = "List of active penalties:"
EPGP_BB_RULE_BUFF_STACKS_BY_PH = "%d GP for gaining %d stacks of the buff %s"
EPGP_BB_RULE_DELETED = "Deleted rule: %s"
EPGP_BB_RULE_NOT_FOUND = "Error: unable to find rule %s. Here is the list of available rules:"
EPGP_BB_RULE_ENABLED = "Enabled rule: %s"
EPGP_BB_RULE_DISABLED = "Disabled rule: %s"
EPGP_BB_ENABLED = "enabled"
EPGP_BB_DISABLED = "disabled"
EPGP_BB_SPELL_LINK = "|cff71d5ff|Hspell:%d|h[%s]|h|r"
EPGP_BB_CREATED_RULE = "Created rule: %s"
EPGP_BB_REPLACED_RULE = "Replaced rule: '%s' with '%s'"