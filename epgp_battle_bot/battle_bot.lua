local version = "6.1"
local cfg_death
local cfg_damage_done
local cfg_damage_taken
local cfg_buff

local config_keys = {
    "death",
    "damage_done",
    "damage_taken",
    "buff",
};

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
    _, _, gp_value, action_base, action_ext, actor, comment = string.find( tail, '^(%d+)%s+on%s+(%a+)%s+(%a+)%s+(%w+)%s*(.*)$' )
    
    -- /ebb add 123 on damage by 123 Попал под поезд
    if( action_base == 'damagedone' ) then
        if( action_ext == 'by' ) then
            local item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            battle_bot_add_rule( 'damage', item, comment )
        else
            battle_bot_help_handler();
        end
    -- /ebb add 123 on death by 123 Попал под поезд
    elseif( action_base == 'death' ) then
        if( action_ext == 'by' ) then
            item = {
                ['type'] = 'spellid',
                ['spellid'] = actor,
            }
            battle_bot_add_rule( 'death', item, comment )
        else
            battle_bot_help_handler();
        end
    else
        battle_bot_help_handler();
    end
end

function battle_bot_list_handler( cmd, tail )
    print( cmd, tail);
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
    list    = battle_bot_list_handler,
    add     = battle_bot_add_handler,
    del     = battle_bot_del_handler,
    enable  = battle_bot_enable_handler,
    disable = battle_bot_disable_handler,
    reset   = battle_bot_reset_handler,
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