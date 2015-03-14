local GS = LibStub("LibGuildStorage-1.2")
local version = GetAddOnMetadata("epgp_battle_bot", "Version")

-- legacy thing, remove with import_legacy_rules
local config_keys = {
    "death",
    "damagedone",
    "damagetaken",
    "buff",
    "protect_buff",
    "protect_cast",
};

local queue = {}
local protected = {}

local player_name = ""
local realm_name = ""
local player_config = nil
local rules = nil
local active_rules = nil


function battle_bot_add_rule( section, new_rule)
    new_rule["enabled"] = true
    new_rule["section"] = section

    local found = false

    local announce  = ""
    for index, rule in pairs(rules) do
        if( 
            rule['spellid'] == new_rule['spellid'] 
            and rule['section'] == new_rule['section']
        ) then
            rules[index] = new_rule
            announce = string.format(
                EPGP_BB_REPLACED_RULE
                , battle_bot_get_rule_as_string(rule)
                , battle_bot_get_rule_as_string(new_rule)
            )
            found = true
            break
        end
    end
    
    if( not found ) then
        table.insert(rules, new_rule)
        announce = string.format(
            EPGP_BB_CREATED_RULE
            , battle_bot_get_rule_as_string(new_rule)
        )
    end

    battle_bot_smart_announce(announce)
    battle_bot_make_active_rules()
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


function battle_bot_protect_handler( cmd, tail )
    -- /ebb protect by buff|cast spell_id
    local action, spell_id = string.match( tail, '^by%s+(%a+)%s+(%d+)$' )
    if( action == 'cast' ) then
        local item = {
            ['type'] = 'spellid',
            ['spellid'] = spell_id
        }
        battle_bot_add_rule( 'protect_cast', item )
    elseif( action == 'buff' ) then
        local item = {
            ['type'] = 'spellid',
            ['spellid'] = spell_id
        }
        battle_bot_add_rule( 'protect_buff', item )
    else
        battle_bot_help_handler();
    end
end


function battle_bot_add_handler( cmd, tail )                           
    local value, currency, action_base, action_ext, actor, tail = string.match( tail, '^(-?%d+)%s+(%ap)%s+for%s+(%a+)%s+(%w+)%s*(%w*)%s*(.*)$' )
    if( 
        action_base == 'damagetaken' 
        or action_base == 'death'
        or action_base == 'buff'
    ) then
        if( action_ext == 'by' ) then
            local item = {
                ['type'] = 'spellid',
                ['spellid'] = tonumber(actor),
                ['value'] = tonumber(value),
                ['currency'] = string.upper(currency),
            }
            
            if( action_base == 'buff' ) then
                item["stacks"] = tonumber(tail)
                if( item["stacks"] == nil ) then
                    item["stacks"] = 1
                end
            end
            
            battle_bot_add_rule( action_base, item )
        else
            battle_bot_help_handler();
        end
    elseif( 
        action_base == 'interrupt' 
        or action_base == 'dispel'
    ) then
        local spell_id = tonumber(action_ext)
        if( spell_id ~= nil ) then
            local item = {
                ['type'] = 'spellid',
                ['spellid'] = spell_id,
                ['value'] = tonumber(value),
                ['currency'] = string.upper(currency),
            }
            
            battle_bot_add_rule( action_base, item )
        else
            battle_bot_help_handler();
        end
    else
        battle_bot_help_handler();
    end
end


function battle_bot_get_rule_as_string( rule )
    local result

    local section = rule['section']
    if( section == 'death' ) then
        result = string.format(
            EPGP_BB_RULE_DEATH_BY_PH
            , rule["value"]
            , rule["currency"]
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'damagetaken' ) then
        result = string.format(
            EPGP_BB_RULE_DAMAGE_TAKEN_BY_PH
            , rule["value"]
            , rule["currency"]
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'interrupt' ) then
        result = string.format(
            EPGP_BB_RULE_INTERRUPT_PH
            , rule["value"]
            , rule["currency"]
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'dispel' ) then
        result = string.format(
            EPGP_BB_RULE_DISPEL_PH
            , rule["value"]
            , rule["currency"]
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'protect_cast' ) then
        result = string.format(
            EPGP_BB_RULE_PROTECT_CAST_PH
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'protect_buff' ) then
        result = string.format(
            EPGP_BB_RULE_PROTECT_BUFF_PH
            , (GetSpellLink(rule["spellid"]))
        )
    elseif( section == 'buff' ) then
        if( rule['stacks'] > 1 ) then
            result = string.format(
                EPGP_BB_RULE_BUFF_STACKS_BY_PH
                , rule["value"]
                , rule["currency"]
                , rule["stacks"]
                , (GetSpellLink(rule["spellid"]))
            )
        else
            result = string.format(
                EPGP_BB_RULE_BUFF_BY_PH
                , rule["value"]
                , rule["currency"]
                , (GetSpellLink(rule["spellid"]))
            )
        end
    else
        print( "Don't know how to stringify rule: "..section.."\n" )
        result = 'Unknown'
    end
    
    return result
end


function battle_bot_get_rules_text()
    local result = {}
    local counter = 1

    for _, item in pairs(rules) do
        local newitem = {
            ["enabled"] = item["enabled"],
            ["enabled_text"] = EPGP_BB_STATE[item["enabled"]],
            ["counter"] = counter,
            ["rule"] = battle_bot_get_rule_as_string(item),
            
        }

        table.insert( result, newitem )
        
        counter = counter + 1
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
    
    if not( 
        channel == 'raid'
        or channel == 'guild'
        or channel == 'say'
        or channel == 'party'
    ) then
        if( UnitInRaid('player') == nil ) then
            channel = 'say'
        else
            channel = 'raid'
        end
    end
    
    local rules = battle_bot_get_rules_text(EPGP_BB_ACTIVE_RULE_PH)
   
    SendChatMessage(EPGP_BB_ACTIVE_RULES_HEADER, channel)
    for _, rule in pairs(rules) do
        if( rule["enabled"] ) then
            SendChatMessage( 
                "    "..rule["rule"]
                , channel
            )
        end
    end
end


function battle_bot_del_handler( cmd, tail )
    local old_tail = tail
    tail = tonumber(tail)
    if( rules[tail] ~= nil ) then
        local rule = table.remove(rules, tail)
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_DELETED
            , battle_bot_get_rule_as_string(rule)
        ))
        battle_bot_make_active_rules()
    else
        print(string.format(EPGP_BB_RULE_NOT_FOUND, old_tail))
    end
    battle_bot_list_handler();
end


function battle_bot_enable_handler( cmd, tail )
    local old_tail = tail
    tail = tonumber(tail)
    if( rules[tail] ~= nil ) then
        rules[tail]["enabled"] = true
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_ENABLED
            , battle_bot_get_rule_as_string(rules[tail])
        ))
        battle_bot_make_active_rules()
    else
        print(string.format(EPGP_BB_RULE_NOT_FOUND, old_tail))
        battle_bot_list_handler();
    end
end


function battle_bot_disable_handler( cmd, tail )
    local old_tail = tail
    tail = tonumber(tail)
    if( rules[tail] ~= nil ) then
        rules[tail]["enabled"] = false
        battle_bot_smart_announce(string.format(
            EPGP_BB_RULE_DISABLED
            , battle_bot_get_rule_as_string(rules[tail])
        ))
        battle_bot_make_active_rules()
    else
        print(string.format(EPGP_BB_RULE_NOT_FOUND, old_tail))
        battle_bot_list_handler();
    end
end


function battle_bot_help_handler()
    for _, line in pairs(EPGP_BB_HELP) do
        print(line:format(version))
    end
end


function battle_bot_turn_on_handler()
    player_config["enabled"] = true
    if( player_config["autologging"] ) then
        if( LoggingCombat(true) ) then
            battle_bot_smart_announce(EPGP_BB_LOGGING_ENABLED)
        else
            print("Error enabling logging")
        end
    end
    battle_bot_smart_announce(EPGP_BB_ADDON_ENABLED)
end


function battle_bot_turn_off_handler()
    player_config["enabled"] = false
    if( player_config["autologging"] ) then
        if( not LoggingCombat(false) ) then
            battle_bot_smart_announce(EPGP_BB_LOGGING_DISABLED);
        else
            print("Error disabling logging")
        end
    end
    battle_bot_smart_announce(EPGP_BB_ADDON_DISABLED)
end

function battle_bot_autologging_handler(cmd,tail)
    if( string.lower(tail) == 'on' ) then
        player_config['autologging'] = true
        print(EPGP_BB_AUTOLOGGING_ENABLED)
    elseif( string.lower(tail) == 'off' ) then
        player_config['autologging'] = false
        print(EPGP_BB_AUTOLOGGING_DISABLED)
    else
        battle_bot_help_handler()
    end
end

function battle_bot_reset_handler()
    player_config["rules"] = {}
    print(EPGP_BB_CONFIG_RESET)
end

function battle_bot_status_handler()
    print(string.format(EPGP_BB_STATUS_VERSION, version))
    print(string.format(EPGP_BB_STATUS_STATUS, EPGP_BB_STATE[player_config["enabled"]]))
    print(string.format(EPGP_BB_STATUS_AUTOLOGGING, EPGP_BB_STATE[player_config["autologging"]]))
    print(string.format(EPGP_BB_STATUS_RULES, table.getn(rules)))
end

local slash_handlers = {
    status      = battle_bot_status_handler,
    autologging = battle_bot_autologging_handler,
    list        = battle_bot_list_handler,
    add         = battle_bot_add_handler,
    protect     = battle_bot_protect_handler,
    del         = battle_bot_del_handler,
    enable      = battle_bot_enable_handler,
    disable     = battle_bot_disable_handler,
    reset       = battle_bot_reset_handler,
    announce    = battle_bot_announce_handler,
    on          = battle_bot_turn_on_handler,
    off         = battle_bot_turn_off_handler,
}


function battle_bot_slash_handler( msg, box)
    msg = string.lower(msg)

    cmd, tail = string.match( msg, '^%s*(%a+)%s*(.*)$');
    
    if( slash_handlers[cmd] ) then
        slash_handlers[cmd](cmd, tail)
    else
        battle_bot_help_handler();
    end
end


function battle_bot_combatlog_parser(...)

    if( not player_config["enabled"] ) then
        return
    end

    local arg = {...}
    local timestamp, event, _, src_guid, src_name, src_flags, src_raid_flags, dst_guid, dst_name, dst_flags, dst_raid_flags, spell_id, spell_name, spell_school = ... -- 14 items
    
    local rule_target = dst_name
    local active_rule = nil
    
    if( event == "SPELL_AURA_APPLIED" ) then
        local rule = active_rules["buff"][spell_id]
        local buff_rule = active_rules["protect_buff"][spell_id]
        
        if( rule ~= nil and rule["stacks"] == 1 ) then
            active_rule = rule
        elseif( buff_rule ~= nil  and dst_name ~= nil ) then
            protected[dst_name] = true
        end        
    elseif( event == "SPELL_AURA_APPLIED_DOSE" ) then
        local rule = active_rules["buff"][spell_id]
   
        if( rule ~= nil and rule["stacks"] > 1 ) then
            local stacks = tonumber(arg[16])
            if( stacks ~= nil and stacks >= rule["stacks"] ) then
                active_rule = rule
            end
        end
    elseif( event == "SPELL_AURA_REMOVED" ) then 
        local buff_rule = active_rules["protect_buff"][spell_id]
        
        if( buff_rule ~= nil and dst_name ~= nil ) then
            protected[dst_name] = nil
        end        
    
    elseif( event == "SPELL_AURA_BROKEN" ) then 
        local buff_rule = active_rules["protect_buff"][spell_id]
        
        if( buff_rule ~= nil  and dst_name ~= nil ) then
            protected[dst_name] = nil
        end        
    elseif( event == "SPELL_DAMAGE" ) then
        local death_rule = active_rules["death"][spell_id]
        local damagetaken_rule = active_rules["damagetaken"][spell_id]

        if( death_rule ~= nil and tonumber(arg[16]) > 0 ) then
            active_rule = death_rule
        elseif( 
            damagetaken_rule ~= nil         -- got rule
            and ( 
                protected[dst_name] == nil  -- not protected
                or tonumber(arg[16]) > 0    -- or died
            )
        ) then 
            active_rule = damagetaken_rule
        end
    elseif( event == "SPELL_CAST_START" ) then 
        local cast_rule = active_rules["protect_cast"][spell_id]
        
        if( cast_rule ~= nil  and src_name ~= nil ) then
            protected[src_name] = true
        end        
    elseif( event == "SPELL_CAST_SUCCESS" ) then 
        local cast_rule = active_rules["protect_cast"][spell_id]
        
        if( cast_rule ~= nil  and src_name ~= nil ) then
            protected[src_name] = nil
        end        
    
    elseif( event == "SPELL_CAST_FAILED" ) then 
        local cast_rule = active_rules["protect_cast"][spell_id]
        
        if( cast_rule ~= nil  and src_name ~= nil ) then
            protected[src_name] = nil
        end
    elseif( event == "SPELL_INTERRUPT" ) then 
        local target_spell = tonumber(arg[15])
        local rule = active_rules["interrupt"][target_spell]
        
        if( rule ~= nil and src_name ~= nil ) then
            active_rule = rule
            rule_target = src_name
        end
    elseif( 
        event == "SPELL_DISPEL" 
        or event == "SPELL_STOLEN" 
    ) then 
        local target_spell = tonumber(arg[15])
        local rule = active_rules["dispel"][target_spell]
        
        if( rule ~= nil and src_name ~= nil ) then
            active_rule = rule
            rule_target = src_name
        end
    elseif( event == "UNIT_DIED" ) then
        if( dst_name ~= nil ) then
            protected[dst_name] = nil
        end
    end

    -- push to queue, should check that we are in guild
    if( active_rule ~= nil and rule_target ~= nil ) then
        table.insert(queue, {
            ["player"] = rule_target,
            ["rule"] = active_rule
        })
    end

    -- proceed the queue
    if( 
        table.getn(queue) > 0 
        and GS:IsCurrentState()
    ) then 
        local item = table.remove(queue, 1);
        local rule = item['rule']
        local reason, value, currency, player = battle_bot_get_rule_as_string(rule), rule['value'], rule['currency'], item['player']
        
        if( currency == 'GP' ) then
            if( EPGP:CanIncGPBy(reason, value) ) then
                EPGP:IncGPBy( player, reason, value )
            else
                print("Unabe to charge GP", player, reason, value)
            end
        else
            if( EPGP:CanIncEPBy(reason, value) ) then
                EPGP:IncEPBy( player, reason, value )
            else
                print("Unabe to charge EP", player, reason, value)
            end
        end
    end
   
end


-- legacy, this function should be removed in release or two
function battle_bot_make_active_rules()
    active_rules = {
        ["damagetaken"] = {},
        ["buff"] = {},
        ["death"] = {},
        ["dispel"] = {},
        ["interrupt"] = {},

        ["protect_buff"] = {},
        ["protect_cast"] = {},
    }
    for _, rule in pairs(rules) do
    
        local section = rule["section"]

        -- legacy migrating
        if( rule['value'] == nil and rule['gp_value'] ~= nil ) then
            rule['value'] = tonumber(rule['gp_value'])
            rule['gp_value'] = nil
        end
        
        if( rule['currency'] == nil ) then
            rule['currency'] = 'GP'
        end
        
        if( rule['value'] ~= tonumber(rule['value'])) then
            rule['value'] = tonumber(rule['value'])
        end
        
        if( rule['spellid'] ~= tonumber(rule['spellid'])) then
            rule['spellid'] = tonumber(rule['spellid'])
        end
        -- end of legacy migration
    
        if( rule["enabled"] ) then
            active_rules[section][rule["spellid"]] = rule
        end
    end
end

-- legacy, this function should be removed in release or two
function battle_bot_import_legacy_rules()
    for _, key in pairs(config_keys) do
        if( config[key] ~= nil ) then
            for _, rule in pairs( config[key] ) do
                table.insert(player_config["rules"], rule)
            end
            config[key] = nil
        end
    end
end


function battle_bot_check_config_keys()
    if( player_config["enabled"] == nil ) then
        player_config["enabled"] = true
    end
    if( player_config["autologging"] == nil ) then
        player_config["autologging"] = true
    end
    if( player_config["rules"] == nil ) then
        player_config["rules"] = {}
        battle_bot_import_legacy_rules()
    end    
end


function battle_bot_validate_config()
    if( config == nil ) then
        config = {}
    end

    if( config[realm_name] == nil ) then
        config[realm_name] = {}
    end

    if( config[realm_name][player_name] == nil ) then
        config[realm_name][player_name] = {}
    end
    
    player_config = config[realm_name][player_name];

    battle_bot_check_config_keys()

    rules = player_config["rules"]
    
    battle_bot_make_active_rules()
end


function battle_bot_init()
    --version = 

    SLASH_EPGPBB1 = '/epgpbb';
    SLASH_EPGPBB2 = '/ebb';
    
    SlashCmdList["EPGPBB"] = battle_bot_slash_handler

    realm_name = SelectedRealmName()
    player_name = UnitName("player")
    battle_bot_validate_config()
end


function battle_bot_register_events(self)
    self:RegisterEvent("VARIABLES_LOADED")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function battle_bot_event_handler(self, event, ...)
    if( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
        battle_bot_combatlog_parser(...)
    elseif( event == "PLAYER_REGEN_DISABLED" ) then -- entering combat
        protected = {}
    elseif( event == "VARIABLES_LOADED" ) then
        battle_bot_init()
    end
end
