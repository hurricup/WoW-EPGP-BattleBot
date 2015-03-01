local version = "6.1"

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

    battle_bot_smart_announce(announce)
end

function battle_bot_smart_announce(announce)
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
                local newitem = {
                    ["enabled"] = item["enabled"],
                    ["enabled_text"] = EPGP_BB_DISABLED,
                    ["counter"] = counter,
                    ["rule"] = battle_bot_get_rule_as_string(item),
                }
                
                if( item["enabled"] ) then
                    newitem["enabled_text"] = EPGP_BB_ENABLED
                end

                table.insert( result, newitem )
                
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
                , rule["enabled_text"]
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
            if( rule["enabled"] ) then
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

function battle_bot_get_rule_by_number(counter)
    local index = tonumber(tail)
    local counter = 1
    
    if( index ~= nil ) then
        for _, subtable in pairs(config_keys) do
            if( config[subtable] ) then
                for key, item in pairs(config[subtable]) do
                    if( counter == index ) then
                        return subtable, key
                    else
                        counter = counter + 1
                    end    
                end
            end
        end
    end

    if( counter == nil ) then
        counter = ""
    end
    print( string.format( EPGP_BB_RULE_NOT_FOUND, counter ))
    
end

function battle_bot_del_handler( cmd, tail )

    local subtable, key = battle_bot_get_rule_by_number(tail)
   
    if( key ~= nil ) then
        local item = config[subtable][key]
        config[subtable][key] = nil
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_DELETED
            , battle_bot_get_rule_as_string(item)
        ))
        battle_bot_list_handler();
    end
end

function battle_bot_enable_handler( cmd, tail )
    local subtable, key = battle_bot_get_rule_by_number(tail)
   
    if( key ~= nil ) then
        config[subtable][key]["enabled"] = true
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_ENABLED
            , battle_bot_get_rule_as_string(config[subtable][key])
        ))
        battle_bot_list_handler();
    end
end

function battle_bot_disable_handler( cmd, tail )
    local subtable, key = battle_bot_get_rule_by_number(tail)
    
    if( key ~= nil ) then
        config[subtable][key]["enabled"] = false
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_DISABLED
            , battle_bot_get_rule_as_string(config[subtable][key])
        ))
        battle_bot_list_handler();
    end
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