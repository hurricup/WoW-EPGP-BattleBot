local version = "6.1"
local cfg_death
local cfg_damage
local cfg_buff

function battle_bot_slash_handler( msg, box)
    msg = string.lower(msg)

    if( not msg or msg == "" or msg == "help" ) then
        print(EPGP_BB_HELP:format(version))
--    elseif( msg == "list" ) then
    else
        print("Got "..msg)
    end
end

function battle_bot_init()
    if( not config) then
        config = {
            ["death"] = {},
            ["damage"] = {},
            ["buff"] = {}
        }
    end

    cfg_death = config["death"];
    cfg_damage = config["damage"];
    cfg_buff = config["buff"];
    
    SLASH_EPGPBB1 = '/epgpbb';
    
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