local tabName = "GUI_TAB_WEAPONS"
local Tab = gui.get_tab(tabName)
local antivehCB = false

local gangstaCB = true
local gangsta_active = false

local fireammoCB = false
local fireammoVer = 1  -- 1=lightup peds & vehicles  2=only lightup peds

local homingCB = true
local homing_presets = {
    {{4,4,4,4,4,4}, 1, 4.0, 8.5, 0.2, 0.6, 20.0, 0.15, 0.5, 1},
    {{4,7,17,10,15,8}, 0, 0, 0, 0, 0, 0, 0, 2.0, 0} -- default
}
local exp_presets = {
    -- See https://altv.stuyk.com/docs/articles/tables/explosions.html
    "GRENADE","GRENADELAUNCHER","STICKYBOMB","MOLOTOV","ROCKET","TANKSHELL","HI_OCTANE","CAR","PLANE","PETROL_PUMP","BIKE","DIR_STEAM","DIR_FLAME","DIR_WATER_HYDRANT","DIR_GAS_CANISTER","BOAT","SHIP_DESTROY","TRUCK","BULLET","SMOKEGRENADELAUNCHER","SMOKEGRENADE","BZGAS","FLARE","GAS_CANISTER","EXTINGUISHER","PROGRAMMABLEAR","TRAIN","BARREL","PROPANE","BLIMP","FLAME_EXPLODE","TANKER","PLANE_ROCKET","VEHICLE_BULLET","GAS_TANK","BIRD_CRAP","RAILGUN","BLIMP2","FIREWORK","SNOWBALL","PROXMINE","VALKYRIE_CANNON","AIR_DEFENSE","PIPEBOMB","VEHICLEMINE","EXPLOSIVEAMMO","APCSHELL","BOMB_CLUSTER","BOMB_GAS","BOMB_INCENDIARY","BOMB_STANDARD","TORPEDO","TORPEDO_UNDERWATER","BOMBUSHKA_CANNON","BOMB_CLUSTER_SECONDARY","HUNTER_BARRAGE","HUNTER_CANNON","ROGUE_CANNON","MINE_UNDERWATER","ORBITAL_CANNON","BOMB_STANDARD_WIDE","EXPLOSIVEAMMO_SHOTGUN","OPPRESSOR2_CANNON","MORTAR_KINETIC","VEHICLEMINE_KINETIC","VEHICLEMINE_EMP","VEHICLEMINE_SPIKE","VEHICLEMINE_SLICK","VEHICLEMINE_TAR","SCRIPT_DRONE","RAYGUN","BURIEDMINE","SCRIPT_MISSILE",
}
local homing_models = {
    [joaat("w_lr_homing_rocket")] = "Default",
    [joaat("w_lr_rpg_rocket")] = "RPG",
    [joaat("w_ex_vehiclemissile_1")] = "AA Trailer",   -- too behind
    [joaat("w_ex_vehiclemissile_2")] = "APC SAM",      -- behind but model is long enough
    [joaat("w_ex_vehiclemissile_3")] = "Oppressor",
    [joaat("w_ex_vehiclemissile_4")] = "Chernobog",    -- very big, a bit behind
    [joaat("w_smug_airmissile_02")] = "Hunter",        -- a bit ahead
    [joaat("w_battle_airmissile_01")] = "B11",
    [joaat("w_smug_airmissile_01b")] = "blue missile", -- a bit ahead
    [joaat("w_arena_airmissile_01a")] = "Arena",
    -- [joaat("xs_prop_arena_airmissile_01a")] = "Arena Large", -- model is backwards
}
local homing_choice = joaat("w_lr_homing_rocket")
local homing_hash = joaat("WEAPON_HOMINGLAUNCHER")
function get_world_addr()
    local world_base = memory.scan_pattern("48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07")
    local world_offset = world_base:add(3):get_dword()
    local world_addr = world_base:add(world_offset + 7)
    return world_addr:deref()
end

local world_ptr = get_world_addr()
function make_homing_op(sc)
    local homing_set = homing_presets[homingCB and 1 or 2]
    local wpn_info_addr = world_ptr:add(0x8):deref():add(0x10B8):deref():add(0x20):deref()
    local ammo_info_addr = wpn_info_addr:add(0x60):deref()
    local homing_param_addr = ammo_info_addr:add(0x19C)
    local weapon_flags_addr = wpn_info_addr:add(0x900)

    -- apply model
    STREAMING.REQUEST_MODEL(homing_choice)
    while not STREAMING.HAS_MODEL_LOADED(homing_choice) do
        sc:yield()
    end
    ammo_info_addr:add(0x14):set_dword(homing_choice)

    -- apply explosion
    ammo_info_addr:add(0x7C):set_dword(homing_set[1][1]) -- default
    ammo_info_addr:add(0x80):set_dword(homing_set[1][2]) -- hit car
    ammo_info_addr:add(0x84):set_dword(homing_set[1][3]) -- hit truck
    ammo_info_addr:add(0x88):set_dword(homing_set[1][4]) -- hit bike
    ammo_info_addr:add(0x8C):set_dword(homing_set[1][5]) -- hit boat
    ammo_info_addr:add(0x90):set_dword(homing_set[1][6]) -- hit plane

    -- apply homing improvement
    homing_param_addr:add(0x00):set_byte(homing_set[2]) -- should_use_homing_params_from_info
    homing_param_addr:add(0x0C):set_float(homing_set[3]) -- turn_rate_modifier
    homing_param_addr:add(0x10):set_float(homing_set[4]) -- pitch_yaw_roll_clamp
    homing_param_addr:add(0x14):set_float(homing_set[5]) -- default_homing_rocket_break_lock_angle
    homing_param_addr:add(0x18):set_float(homing_set[6]) -- default_homing_rocket_break_lock_angle_close
    homing_param_addr:add(0x1C):set_float(homing_set[7]) -- default_homing_rocket_break_lock_close_distance
    homing_param_addr:add(0x04):set_float(homing_set[8]) -- time_before_starting_homing
    ammo_info_addr:add(0x178):set_float(homing_set[9]) -- time_before_homing aka lock-on time
    
    weapon_flags_addr:add(0x288):set_float(500) -- lock_on_range
    weapon_flags_addr:add(0x28C):set_float(1000) -- weapon_range

    -- IgnoreHomingCloseThresholdCheck 152 = 8 * 19 + 0
    local bitset = weapon_flags_addr:add(19):get_byte()
    if homing_set[10] == 1 then
        bitset = bitset | (1 << 0)
    else
        bitset = bitset & (~(1 << 0))
    end
    weapon_flags_addr:add(19):set_byte(bitset)
end

Tab:add_imgui(function()
    if ImGui.CollapsingHeader("Weapon Addons") then
        homingCB, homingCB_Toggled = ImGui.Checkbox("Better Homing", homingCB)
        if ImGui.IsItemHovered() then
            ImGui.SetTooltip("Make your homing launcher OP.")
        end

        ImGui.SameLine()
        gangstaCB, _Toggled2 = ImGui.Checkbox("Gangsta Aim", gangstaCB)
        if ImGui.IsItemHovered() then
            ImGui.SetTooltip("Shoot the pistol or pistol mk2 like a gangsta.")
        end

        ImGui.SameLine()
        fireammoCB, _Toggled3 = ImGui.Checkbox("Fire Ammo", fireammoCB)

        if ImGui.BeginCombo("Homing Rocket", homing_models[homing_choice], ImGuiComboFlags.PopupAlignLeft) then
            for k, v in pairs(homing_models) do
                if ImGui.Selectable(v, k == homing_choice) then
                    homing_choice = k
                end
                if k == homing_choice then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
        if ImGui.IsItemHovered() then
            ImGui.SetTooltip("Change rocket appearance. Unequip & re-equip to see changes.")
        end
        if ImGui.BeginCombo("Homing Explosion", exp_presets[homing_presets[1][1][1]+1], ImGuiComboFlags.PopupAlignLeft) then
            for k, v in pairs(exp_presets) do
                if ImGui.Selectable(v, k == homing_presets[1][1][1]+1) then
                    homing_presets[1][1] = {k-1,k-1,k-1,k-1,k-1,k-1}
                end
                if k == homing_presets[1][1][1]+1 then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
    end
end)

script.register_looped("homingloop", function (sc)
    sc:yield() -- necessary numbers to update
    local curr_weap = 0
    local has_weap, curr_weap = WEAPON.GET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), curr_weap)
    -- log.info("has weap: "..tostring(has_weap).." hash: "..tostring(curr_weap))
    if not has_weap or curr_weap ~= homing_hash then
        return
    end
    make_homing_op(sc)
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