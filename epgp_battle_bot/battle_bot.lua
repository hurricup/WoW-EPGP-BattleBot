local version = "6.1"
local cfg_death
local cfg_damage_done
local cfg_damage_taken
local cfg_buff

-- @todo rulesets

local config_keys = {
    "death",
    "damage_done",
    "damage_taken",
    "buff",
};
-- /ebb add 150 on death by 156554 Успел на поезд
-- /ebb add 150 on buff by 154960 Приколист
function battle_bot_add_rule( section, item, comment, gp_value)
    item["enabled"] = true
    item["comment"] = comment
    item["section"] = section
    item["gp_value"] = gp_value
    
    if( 
        ( not item["comment"] or item["comment"] == "" )
        and item["spellid"] 
    ) then
        item["comment"] = GetSpellInfo(item["spellid"])
    end

    local found = false
    
    for key, val in pairs( config[section] ) do
        if( val['spellid'] == item['spellid'] ) then
            local olditem = config[section][key]
            config[section][key] = item
            print( string.format(
                EPGP_BB_REPLACED_RULE
                , battle_bot_get_rule_as_string(olditem)
                , battle_bot_get_rule_as_string(item)
            ))
            found = true
            break
        end
    end
    
    if( not found ) then
        table.insert(config[section], item)
        print( string.format(
            EPGP_BB_CREATED_RULE
            , battle_bot_get_rule_as_string(item)
        ))
    end
end

function battle_bot_check_config_keys()
    for _, key in pairs(config_keys) do
        if( not config[key] ) then
            config[key] = {}
        end
    end
end

function battle_bot_reset_handler()
    config = {}
    battle_bot_check_config_keys()
    print(EPGP_BB_CONFIG_RESET)
end

function battle_bot_add_handler( cmd, tail )                           
    gp_value, action_base, action_ext, actor, comment = string.match( tail, '^(%d+)%s+on%s+(%a+)%s+(%a+)%s+(%w+)%s*(.*)$' )
    if( action_base == 'damagedone' ) then
        if( action_ext == 'by' ) then
            local item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            
            battle_bot_add_rule( 'damage_done', item, comment, gp_value )
        else
            battle_bot_help_handler();
        end
    elseif( action_base == 'death' ) then
        if( action_ext == 'by' ) then
            item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            battle_bot_add_rule( 'death', item, comment, gp_value )
        else
            battle_bot_help_handler();
        end
    elseif( action_base == 'buff' ) then
        if( action_ext == 'by' ) then
            item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            battle_bot_add_rule( 'buff', item, comment, gp_value )
        else
            battle_bot_help_handler();
        end
    else
        battle_bot_help_handler();
    end
end

function battle_bot_get_spell_link( item )
    return string.format(
        EPGP_BB_SPELL_LINK
        , item["spellid"]
        , item["comment"]
    ) -- /ebb add 150 on death by 156554
end

function battle_bot_get_rule_as_string( item )
    local result
    
    if( item['section'] == 'death' ) then
        result = string.format(
            EPGP_BB_RULE_DEATH_BY_PH
            , item["gp_value"]
            , battle_bot_get_spell_link(item)
        )
    elseif( item['section'] == 'buff' ) then
        result = string.format(
            EPGP_BB_RULE_BUFF_BY_PH
            , item["gp_value"]
            , battle_bot_get_spell_link(item)
        )
    else
        print( "Don't know how to stringify rule: "..item['section'].."\n" )
        result = 'Unknown'
    end
    
    return result
end

function battle_bot_get_rules_text()
    local result = {}
    local counter = 1
    
    if( config["death"] ) then
        for _, item in pairs(config["death"]) do
            is_enabled = EPGP_BB_DISABLED
            
            if( item["enabled"] ) then
                is_enabled = EPGP_BB_ENABLED
            end
            
            table.insert(
                result, string.format(
                    EPGP_BB_RULE_PH
                    , counter
                    , is_enabled
                    , battle_bot_get_rule_as_string(item)
                )
            )
            
            counter = counter + 1
        end
    end
    if( config["buff"] ) then
        for _, item in pairs(config["buff"]) do
            is_enabled = EPGP_BB_DISABLED
            
            if( item["enabled"] ) then
                is_enabled = EPGP_BB_ENABLED
            end
            
            table.insert(
                result
                , string.format(
                    EPGP_BB_RULE_PH
                    , counter
                    , is_enabled
                    , battle_bot_get_rule_as_string(item)
                )
            )
            counter = counter + 1
        end
    end
    
    return result
end

function battle_bot_list_handler( cmd, tail )
    local rules = battle_bot_get_rules_text()
    for _, rule in pairs(rules) do
        print(rule)
    end
end

function battle_bot_announce_handler( cmd, tail )
    local rules = battle_bot_get_rules_text()
    for _, rule in pairs(rules) do
        SendChatMessage( 
            rule
            , tail
        )
    end
end

function battle_bot_del_handler( cmd, tail )
    print( cmd, tail);
end

function battle_bot_enable_handler( cmd, tail )
    print( cmd, tail);
end

function battle_bot_disable_handler( cmd, tail )
    print( cmd, tail);
end

function battle_bot_help_handler()
    print(EPGP_BB_HELP:format(version))
end

local slash_handlers = {
    list     = battle_bot_list_handler,
    add      = battle_bot_add_handler,
    del      = battle_bot_del_handler,
    enable   = battle_bot_enable_handler,
    disable  = battle_bot_disable_handler,
    reset    = battle_bot_reset_handler,
    announce = battle_bot_announce_handler,
}

function battle_bot_slash_handler( msg, box)
    msg = string.lower(msg)

    _, _, cmd, tail = string.find( msg, '^%s*(%a+)%s*(.*)$');
    
    if( slash_handlers[cmd] ) then
        slash_handlers[cmd](cmd, tail)
    else
        battle_bot_help_handler();
    end
end

function battle_bot_validate_config()
    if( not config) then
        battle_bot_reset_handler()
    end

    battle_bot_check_config_keys()
 
    cfg_death = config["death"];
    cfg_damage_done = config["damage_done"];
    cfg_damage_taken = config["damage_taken"];
    cfg_buff = config["buff"];
end

function battle_bot_init()
    battle_bot_validate_config()
    
    SLASH_EPGPBB1 = '/epgpbb';
    SLASH_EPGPBB2 = '/ebb';
    
    SlashCmdList["EPGPBB"] = battle_bot_slash_handler
end

function battle_bot_register_events(self)
    self:RegisterEvent("VARIABLES_LOADED")
end

function battle_bot_event_handler(self, event, ...)
    if( event == "VARIABLES_LOADED" ) then
        battle_bot_init()
    end
end