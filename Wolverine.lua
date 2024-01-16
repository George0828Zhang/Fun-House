settings = {
    health={
        enable=true,
        low=128, --128 (very low) 312 (full) set to ~85% to avoid sus
        high=285,
        rate={10, 1}
    },
    armour={
        enable=true,
        low=10,
        high=75,
        rate={10, 1}
    },
    headshot_pf = true
}

local tabName = "GUI_TAB_SELF"
local Tab = gui.get_tab(tabName)
local _frame = 0
local _max_frame_count = 2147483646

Tab:add_imgui(function()
    if ImGui.CollapsingHeader("Regenerative") then
        settings.headshot_pf, _Toggled3 = ImGui.Checkbox("Heatshot Proof", settings.headshot_pf)
        ImGui.SameLine()
        settings.health.enable, _Toggled1 = ImGui.Checkbox("Health", settings.health.enable)
        ImGui.SameLine()
        settings.armour.enable, _Toggled2 = ImGui.Checkbox("Armour", settings.armour.enable)

        if settings.health.enable then
            settings.health.rate, _used1 = ImGui.SliderInt2("Regen Rate", settings.health.rate, 1, 50)
            if ImGui.IsItemHovered() then
                ImGui.SetTooltip("Regenerate number1 amount of health for every number2 frames.")
            end
        end
        if settings.armour.enable then
            settings.armour.rate, _used2 = ImGui.SliderInt2("Repair Rate", settings.armour.rate, 1, 50)
            if ImGui.IsItemHovered() then
                ImGui.SetTooltip("Regain number1 amount of armour for every number2 frames.")
            end
        end
    end
end)

function heal_by_type(playerPed, setting, frame, get_func, set_func)
    if setting.enable then
        local curr = get_func(playerPed)
        local target = curr
        if curr < setting.low then
            target = setting.low
        elseif frame % setting.rate[2] == 0 and curr < setting.high then
            target = curr + setting.rate[1]
        end
        set_func(playerPed, target, 0, 0)
    end
end

script.register_looped("wolverineloops", function (script)
    script:yield() -- necessary for the rates to update
    local playerPed = PLAYER.PLAYER_PED_ID()
    if playerPed ~= nil then
        heal_by_type(
            playerPed, settings.health, _frame,
            ENTITY.GET_ENTITY_HEALTH,
            ENTITY.SET_ENTITY_HEALTH
        )
        heal_by_type(
            playerPed, settings.armour, _frame,
            PED.GET_PED_ARMOUR,
            PED.SET_PED_ARMOUR
        )
        if settings.headshot_pf then
            PED.SET_PED_SUFFERS_CRITICAL_HITS(playerPed, false)
        end
        _frame = (_frame + 1) % _max_frame_count
    end
end)
