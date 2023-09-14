
function apply(script)
    local playerPed = PLAYER.PLAYER_PED_ID()
    WEAPON.SET_WEAPON_ANIMATION_OVERRIDE(playerPed, joaat("Gang1H"))
end

script.run_in_fiber(apply)
event.register_handler(menu_event.PlayerMgrInit, apply)