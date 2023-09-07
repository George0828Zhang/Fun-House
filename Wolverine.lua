settings = {
    heal_enable = true,
    heal_thres = 285, --128 (very low) 312 (full) set to ~85% to avoid sus
    heal_rate = {30, 20},
    armour_enable = true,
    armour_thres = 35,
    armour_rate = {8, 10},
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
        settings.heal_enable, _Toggled1 = ImGui.Checkbox("Health", settings.heal_enable)
        ImGui.SameLine()
        settings.armour_enable, _Toggled2 = ImGui.Checkbox("Armour", settings.armour_enable)

        if settings.heal_enable then
            settings.heal_rate, _used1 = ImGui.SliderInt2("Regen Rate", settings.heal_rate, 1, 50)
            if ImGui.IsItemHovered() then
                ImGui.SetTooltip("Regenerate number1 amount of health for every number2 frames.")
            end
        end
        if settings.armour_enable then
            settings.armour_rate, _used2 = ImGui.SliderInt2("Repair Rate", settings.armour_rate, 1, 50)
            if ImGui.IsItemHovered() then
                ImGui.SetTooltip("Regain number1 amount of armour for every number2 frames.")
            end
        end
    end
end)

script.register_looped("wolverineloops", function (script)
    script:yield() -- necessary for the rates to update
    local playerPed = PLAYER.PLAYER_PED_ID()
    if playerPed ~= nil then
        if settings.heal_enable and _frame % settings.heal_rate[2] == 0 then
            local x = ENTITY.GET_ENTITY_HEALTH(playerPed)
            if x <= settings.heal_thres then
                ENTITY.SET_ENTITY_HEALTH(playerPed, x + settings.heal_rate[1])
            end
        end
        if settings.armour_enable and _frame % settings.armour_rate[2] == 0 then
            local x = PED.GET_PED_ARMOUR(playerPed)
            if x <= settings.armour_thres then
                PED.SET_PED_ARMOUR(playerPed, x + settings.armour_rate[1])
            end
        end
        if settings.headshot_pf then
            PED.SET_PED_SUFFERS_CRITICAL_HITS(playerPed, 0)
        end
        _frame = (_frame + 1) % _max_frame_count
    end
end)
