-- Thermal Bypass credits: GTA5TunersGenZ
-- https://www.unknowncheats.me/forum/downloads.php?do=file&id=41096

local PED_FLAG_IS_SNIPER_SCOPE_ACTIVE = 72
local PED_FLAG_IS_AIMING = 78
script.register_looped("loops", function (sc)
    -- sleep until next game frame
    sc:yield()
    
    if PED.GET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), PED_FLAG_IS_AIMING, true) and PAD.IS_CONTROL_PRESSED(0, 54) then
        GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(9999.0)
        GRAPHICS.SEETHROUGH_SET_NOISE_MIN(0.0)
        GRAPHICS.SEETHROUGH_SET_NOISE_MAX(0.0)
        GRAPHICS.SEETHROUGH_SET_HIGHLIGHT_NOISE(0.0)
        GRAPHICS.SEETHROUGH_SET_HILIGHT_INTENSITY(2.5)
        GRAPHICS.SET_SEETHROUGH(not GRAPHICS.GET_USINGSEETHROUGH())
        sc:sleep(200)
    end
    -- Again I didn't find this myself credits goes to GTA5TunersGenZ
    globals.set_int(1853988+1+PLAYER.PLAYER_ID()*867+823+10+1, 1) 
end)
event.register_handler(menu_event.PlayerMgrInit, function ()
    GRAPHICS.SEETHROUGH_RESET()
end)
