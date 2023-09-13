
function apply()
    local playerPed = PLAYER.PLAYER_PED_ID()
    WEAPON.SET_WEAPON_ANIMATION_OVERRIDE(playerPed, joaat("Gang1H"))
end

apply()
event.register_handler(menu_event.PlayerMgrInit, function ()
    apply()
end)
