local tabName = "GUI_TAB_WEAPONS"
local Tab = gui.get_tab(tabName)
local antivehCB = false

local gangstaCB = true
local gangsta_active = false

local fireammoCB = false
local fireammoVer = 1  -- 1=lightup peds & vehicles  2=only lightup peds

Tab:add_imgui(function()
    ImGui.Text("Extras")
    antivehCB, _Toggled = ImGui.Checkbox("Anti-Vehicle Gun", antivehCB)
    
    ImGui.SameLine()
    gangstaCB, _Toggled2 = ImGui.Checkbox("Gangsta Aim", gangstaCB)

    ImGui.SameLine()
    fireammoCB, _Toggled3 = ImGui.Checkbox("Fire Ammo", fireammoCB)
end)

function GET_PLAYER_INDEX_FROM_PED(ped)
    for i = 0, 31 do
		local plyped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(i)
        if plyped == ped then 
            return i
        end
    end
    return nil
end
function ProcessAntiVeh(ped, vehicle)
    if vehicle == nil then
        return
    end
    local isPlayer = ped ~= nil and PED.GET_PED_TYPE(ped) < 4
    local health = VEHICLE.GET_VEHICLE_ENGINE_HEALTH(vehicle)
    -- log.info("player="..tostring(isPlayer)..", health="..tostring(health))    
    if isPlayer then
        -- log.info("playerid="..tostring(GET_PLAYER_INDEX_FROM_PED(ped)))
        command.call("killengine", {GET_PLAYER_INDEX_FROM_PED(ped)})
    else
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, -3800)
    end
end
script.register_looped("antivehloop", function (sc)
    sc:yield() -- necessary numbers to update
     
    local player = PLAYER.PLAYER_ID()
    local tgtped = nil
    local tgtveh = nil
    if antivehCB and PLAYER.IS_PLAYER_FREE_AIMING(player) and PAD.IS_CONTROL_PRESSED(0, 24) then
        local playerPed = PLAYER.PLAYER_PED_ID()        
        local has_ent, tgtped = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(player, tgtped)
        if has_ent then
            if ENTITY.IS_ENTITY_A_PED(tgtped) and PED.IS_PED_IN_ANY_VEHICLE(tgtped, 1) then            
                tgtveh = PED.GET_VEHICLE_PED_IS_IN(tgtped, 0)
            elseif ENTITY.IS_ENTITY_A_VEHICLE(tgtped) then
                tgtveh = tgtped
                tgtped = nil
            end            
            ProcessAntiVeh(tgtped, tgtveh)
            sc:sleep(200)
        end        
    end
end)

script.register_looped("fireammoloop", function (sc)
    sc:yield() -- necessary numbers to update
    local player = PLAYER.PLAYER_ID()
    -- If you don't care about discretion, use this
    if fireammoCB then
        if fireammoVer == 1 then
            MISC.SET_FIRE_AMMO_THIS_FRAME(player)
        elseif PLAYER.IS_PLAYER_FREE_AIMING(player) then
            local has_ent, entity = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(player, entity)        
            if has_ent and ENTITY.IS_ENTITY_A_PED(entity) and not PED.IS_PED_IN_ANY_VEHICLE(entity, false) then
                MISC.SET_FIRE_AMMO_THIS_FRAME(PLAYER.PLAYER_ID())
            end
        end
    end
end)

script.register_looped("gangstaloop", function (sc)
    sc:yield() -- necessary numbers to update
    local player = PLAYER.PLAYER_ID()
    local playerPed = PLAYER.PLAYER_PED_ID()
    if PLAYER.IS_PLAYER_PLAYING(player) and playerPed ~= nil and ENTITY.DOES_ENTITY_EXIST(playerPed) then
        if gangsta_active ~= gangstaCB then
            gangsta_active = gangstaCB
            if gangsta_active then
                WEAPON.SET_WEAPON_ANIMATION_OVERRIDE(PLAYER.PLAYER_PED_ID(), joaat("Gang1H"))
            else
                WEAPON.SET_WEAPON_ANIMATION_OVERRIDE(PLAYER.PLAYER_PED_ID(), joaat("Default"))
            end
        end
    else
        gangsta_active = false
    end
end)