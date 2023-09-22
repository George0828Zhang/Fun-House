
function apply()
    local playerPed = PLAYER.PLAYER_PED_ID()
    if playerPed ~= prev_player then
        prev_player = curr_player
        WEAPON.SET_WEAPON_ANIMATION_OVERRIDE(playerPed, joaat("Gang1H"))
    end
end

script.register_looped("gangstaloop", function (script)
    script:yield()
    apply()
end)