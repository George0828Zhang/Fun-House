local PED_FLAG_IS_SNIPER_SCOPE_ACTIVE = 72
local PED_FLAG_IS_AIMING = 78
local thermalCB = true
-- local Tab = gui.get_tab("GUI_TAB_WEAPONS")
local tabName = "GUI_TAB_WEAPONS" -- "Thermal"
local Tab = gui.get_tab(tabName)

-- Tab:add_button("Click me", function ()
--     local p = globals.get_int(2703656)
--     log.info("got " .. tostring(p))
--     globals.set_int(1853128+1+p*888+848+9+1, 1)
-- GA(1853348+1+PLAYER_ID()*834+794+9+1)
-- Global_1853348.f_1.(PLAYER::PLAYER_ID() * 834).f_794.f_9.f_1
-- end)
Tab:add_imgui(function()
    ImGui.Text("Extras")
    thermalCB, thermalToggled = ImGui.Checkbox("Thermal Control", thermalCB)
end)

GRAPHICS.SEETHROUGH_RESET()

script.register_looped("loops", function (sc)
    -- sleep until next game frame
    sc:yield()
    
    if PED.GET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), PED_FLAG_IS_AIMING, 1) and PAD.IS_CONTROL_PRESSED(0, 54) then
        if thermalCB then
            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(9999.0)
            GRAPHICS.SEETHROUGH_SET_NOISE_MIN(0.0)
            GRAPHICS.SEETHROUGH_SET_NOISE_MAX(0.0)
            GRAPHICS.SEETHROUGH_SET_HIGHLIGHT_NOISE(0.0)
            GRAPHICS.SEETHROUGH_SET_HILIGHT_INTENSITY(2.5)
            GRAPHICS.SET_SEETHROUGH(not GRAPHICS.GET_USINGSEETHROUGH())     

            -- try 1:
            local x = globals.get_int(2794162 + 4697)
            x = x | (1<<9)
            x = x | (1<<12)
            globals.set_int(2794162 + 4697, x)
            -- MISC::SET_BIT(&(Global_2794162.f_4697), 9);
            -- MISC::SET_BIT(&(Global_2794162.f_4697), 12);

            
            -- FILES::DOES_CURRENT_PED_COMPONENT_HAVE_RESTRICTION_TAG(
            --     PLAYER::PLAYER_PED_ID(), 1, joaat("THERMAL_VISION")
            -- ) || 
            -- FILES::DOES_CURRENT_PED_PROP_HAVE_RESTRICTION_TAG(
            --     PLAYER::PLAYER_PED_ID(), 0, joaat("THERMAL_VISION")))
        end 
    end    
end)

-- local fadestart = Tab:add_input_float("Fade Start")
-- local fadeend = Tab:add_input_float("Fade End")
-- local maxthick = Tab:add_input_float("Max Thickness") -- 1~10000
-- local noisemin = Tab:add_input_float("Noise Min")
-- local noisemax = Tab:add_input_float("Noise Max")
-- local intensity = Tab:add_input_float("HiLight Intensity")
-- local hinoise = Tab:add_input_float("HiLight Noise")
-- local heatscale = Tab:add_input_float("Heatscale")
-- local nearR = Tab:add_input_float("R")
-- local nearG = Tab:add_input_float("G")
-- local nearB = Tab:add_input_float("B")

-- maxthick:set_value(9999.0)
-- intensity:set_value(1.0)
-- nearR:set_value(36.0)
-- nearG:set_value(18.0)
-- nearB:set_value(74.0)

-- Tab:add_button("Set", function()
--     if GRAPHICS.GET_USINGSEETHROUGH() then
--         GRAPHICS.SEETHROUGH_SET_FADE_STARTDISTANCE(fadestart:get_value())
--         GRAPHICS.SEETHROUGH_SET_FADE_ENDDISTANCE(fadeend:get_value())
--         GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(maxthick:get_value())
--         GRAPHICS.SEETHROUGH_SET_NOISE_MIN(noisemin:get_value())
--         GRAPHICS.SEETHROUGH_SET_NOISE_MAX(noisemax:get_value())
--         GRAPHICS.SEETHROUGH_SET_HILIGHT_INTENSITY(intensity:get_value())
--         GRAPHICS.SEETHROUGH_SET_HIGHLIGHT_NOISE(hinoise:get_value())
--         GRAPHICS.SEETHROUGH_SET_HEATSCALE(0, heatscale:get_value())
--         GRAPHICS.SEETHROUGH_SET_COLOR_NEAR(nearR:get_value(), nearG:get_value(), nearB:get_value())
--     end
-- end)
-- Tab:add_button("Reset", function()
--     GRAPHICS.SEETHROUGH_RESET()
-- end)