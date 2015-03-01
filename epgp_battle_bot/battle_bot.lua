local version = "6.1"
local cfg_death
local cfg_damage_done
local cfg_damage_taken
local cfg_buff

-- @todo rulesets

local config_keys = {
    "death",
    "damagedone",
    "damagetaken",
    "buff",
};
-- /ebb add 150 on death by 156554 Успел на поезд
-- /ebb add 150 on buff by 154960 Приколист
-- /ebb add 150 on buff by 154960 10
function battle_bot_add_rule( section, item, gp_value)
    item["enabled"] = true
    item["section"] = section
    item["gp_value"] = gp_value

    local found = false

    local announce  = ""
    for key, val in pairs( config[section] ) do
        if( val['spellid'] == item['spellid'] ) then
            local olditem = config[section][key]
            config[section][key] = item
            announce = string.format(
                EPGP_BB_REPLACED_RULE
                , battle_bot_get_rule_as_string(olditem)
                , battle_bot_get_rule_as_string(item)
            )
            found = true
            break
        end
    end
    
    if( not found ) then
        table.insert(config[section], item)
        announce = string.format(
            EPGP_BB_CREATED_RULE
            , battle_bot_get_rule_as_string(item)
        )
    end
    
    if( announce ~= "" ) then
        if( UnitInRaid('player') == nil ) then
            print(announce)
        else
            SendChatMessage(announce, 'RAID')
        end
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
    gp_value, action_base, action_ext, actor, tail = string.match( tail, '^(%d+)%s+on%s+(%a+)%s+(%a+)%s+(%w+)%s*(.*)$' )
    if( 
        action_base == 'damagedone' 
        or action_base == 'death'
        or action_base == 'buff'
    ) then
        if( action_ext == 'by' ) then
            local item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            
            if( action_base == 'buff' ) then
                item["stacks"] = tonumber(tail)
                if( item["stacks"] == nil ) then
                    item["stacks"] = 1
                end
            end
            
            battle_bot_add_rule( action_base, item, gp_value )
        else
            battle_bot_help_handler();
        end
    else
        battle_bot_help_handler();
    end
end

function battle_bot_get_rule_as_string( item )
    local result
    
    if( item['section'] == 'death' ) then
        result = string.format(
            EPGP_BB_RULE_DEATH_BY_PH
            , item["gp_value"]
            , (GetSpellLink(item["spellid"]))
        )
    elseif( item['section'] == 'buff' ) then
        if( item['stacks'] > 1 ) then
            result = string.format(
                EPGP_BB_RULE_BUFF_STACKS_BY_PH
                , item["gp_value"]
                , item["stacks"]
                , (GetSpellLink(item["spellid"]))
            )
        else
            result = string.format(
                EPGP_BB_RULE_BUFF_BY_PH
                , item["gp_value"]
                , (GetSpellLink(item["spellid"]))
            )
        end
    else
        print( "Don't know how to stringify rule: "..item['section'].."\n" )
        result = 'Unknown'
    end
    
    return result
end

function battle_bot_get_rules_text()
    local result = {}
    local counter = 1

    for _, subtable in pairs(config_keys) do
        if( config[subtable] ) then
            for _, item in pairs(config[subtable]) do
                is_enabled = EPGP_BB_DISABLED
                
                if( item["enabled"] ) then
                    is_enabled = EPGP_BB_ENABLED
                end

                table.insert(
                    result
                    , {
                        ["counter"] = counter,
                        ["enabled"] = is_enabled,
                        ["rule"] = battle_bot_get_rule_as_string(item),
                    }
                )
                
                counter = counter + 1
            end
        end
    end
    
    return result
end

function battle_bot_list_handler( cmd, tail )
    local rules = battle_bot_get_rules_text()
    for _, rule in pairs(rules) do
        print(
            string.format(
                EPGP_BB_RULE_PH
                , rule["counter"]
                , rule["enabled"]
                , rule["rule"]
            )
        )
    end
end

function battle_bot_announce_handler( cmd, tail )
    local channel = string.lower(tail);
    
    if( 
        channel == 'raid'
        or channel == 'guild'
        or channel == 'say'
        or channel == 'party'
    ) then
        local rules = battle_bot_get_rules_text(EPGP_BB_ACTIVE_RULE_PH)
       
        SendChatMessage(EPGP_BB_ACTIVE_RULES_HEADER, tail)
        for _, rule in pairs(rules) do
            if( rule["enabled"] == EPGP_BB_ENABLED ) then
                SendChatMessage( 
                    "    "..rule["rule"]
                    , tail
                )
            end
        end
    else
        battle_bot_help_handler();
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