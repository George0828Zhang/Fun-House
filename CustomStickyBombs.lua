local c4_md_presets = {
    -- See https://forge.plebmasters.de/objects
    [0] = {"Disabled", nil, nil},
    [1] = {"stt_prop_c4_stack", vec3:new(0, 0, 0.09), vec3:new(0, 0, 0)}, -- giant stack of c4
    [2] = {"ch_prop_ch_ld_bomb_01a", vec3:new(0, 0, 0), vec3:new(-90, 0, 0)}, -- satchel, earth timer on
    [3] = {"h4_prop_h4_ld_bomb_01a", vec3:new(0, 0, 0), vec3:new(-90, 0, 0)}, -- satchel, green
    [4] = {"h4_prop_h4_ld_bomb_02a", vec3:new(0, 0, 0), vec3:new(-90, 0, 0)}, -- satchel, earth timer off
    [5] = {"hei_prop_heist_thermite", vec3:new(0, 0, 0), vec3:new(0, 0, 0)}, -- thermite bomb
    [6] = {"hei_prop_heist_thermite_flash", vec3:new(0, 0, 0), vec3:new(0, 0, 0)}, -- thermite timer on
}
local c4_md_choice = 2

local c4_weap_hash = joaat("weapon_stickybomb")
local before = joaat("w_ex_pe")
local after = joaat(c4_md_presets[c4_md_choice][1])
local offset = c4_md_presets[c4_md_choice][2]
local rot = c4_md_presets[c4_md_choice][3]

local c4_exp_presets = {
    -- See https://altv.stuyk.com/docs/articles/tables/explosions.html
    "GRENADE","GRENADELAUNCHER","STICKYBOMB","MOLOTOV","ROCKET","TANKSHELL","HI_OCTANE","CAR","PLANE","PETROL_PUMP","BIKE","DIR_STEAM","DIR_FLAME","DIR_WATER_HYDRANT","DIR_GAS_CANISTER","BOAT","SHIP_DESTROY","TRUCK","BULLET","SMOKEGRENADELAUNCHER","SMOKEGRENADE","BZGAS","FLARE","GAS_CANISTER","EXTINGUISHER","PROGRAMMABLEAR","TRAIN","BARREL","PROPANE","BLIMP","FLAME_EXPLODE","TANKER","PLANE_ROCKET","VEHICLE_BULLET","GAS_TANK","BIRD_CRAP","RAILGUN","BLIMP2","FIREWORK","SNOWBALL","PROXMINE","VALKYRIE_CANNON","AIR_DEFENSE","PIPEBOMB","VEHICLEMINE","EXPLOSIVEAMMO","APCSHELL","BOMB_CLUSTER","BOMB_GAS","BOMB_INCENDIARY","BOMB_STANDARD","TORPEDO","TORPEDO_UNDERWATER","BOMBUSHKA_CANNON","BOMB_CLUSTER_SECONDARY","HUNTER_BARRAGE","HUNTER_CANNON","ROGUE_CANNON","MINE_UNDERWATER","ORBITAL_CANNON","BOMB_STANDARD_WIDE","EXPLOSIVEAMMO_SHOTGUN","OPPRESSOR2_CANNON","MORTAR_KINETIC","VEHICLEMINE_KINETIC","VEHICLEMINE_EMP","VEHICLEMINE_SPIKE","VEHICLEMINE_SLICK","VEHICLEMINE_TAR","SCRIPT_DRONE","RAYGUN","BURIEDMINE","SCRIPT_MISSILE",
}
local c4_exp_choice = 50

log.info("Hash "..tostring(c4_md_presets[c4_md_choice][1]).." valid: "..tostring(STREAMING.IS_MODEL_VALID(after)))

local tabName = "GUI_TAB_WEAPONS"
local Tab = gui.get_tab(tabName)

Tab:add_imgui(function()
    if ImGui.CollapsingHeader("Customize C4") then
        if ImGui.BeginCombo("C4 Model", tostring(c4_md_presets[c4_md_choice][1]), ImGuiComboFlags.PopupAlignLeft) then
            for k, v in pairs(c4_md_presets) do
                if ImGui.Selectable(v[1], k == c4_md_choice) then
                    c4_md_choice = k
                    after = joaat(c4_md_presets[c4_md_choice][1])
                    offset = c4_md_presets[c4_md_choice][2]
                    rot = c4_md_presets[c4_md_choice][3]
                end
                if k == c4_md_choice then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
        -- ImGui.SameLine()
        if ImGui.BeginCombo("C4 Explosion", tostring(c4_exp_presets[c4_exp_choice+1]), ImGuiComboFlags.PopupAlignLeft) then
            for k, v in pairs(c4_exp_presets) do
                if ImGui.Selectable(v, k == c4_exp_choice+1) then
                    c4_exp_choice = k-1
                end
                if k == c4_exp_choice+1 then
                    ImGui.SetItemDefaultFocus()
                end
            end
            ImGui.EndCombo()
        end
    end
end)



function spawn_obj(sc, entity, hash, playerPed)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do sc:yield() end
    local pj_coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(entity, 0, 0, 100)
    local isNetwork = true
    local netMissionEntity = false
    local pj = OBJECT.CREATE_OBJECT_NO_OFFSET(
        hash,
        pj_coords.x,
        pj_coords.y,
        pj_coords.z,
        isNetwork, 
        netMissionEntity,
        true
    )
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)

    -- This prevents collision with player when throwing
    -- while also making thrown ones destroyable
    -- *can also use this one: IS_PROJECTILE_TYPE_WITHIN_DISTANCE() to differenciate
    if ENTITY.IS_ENTITY_ATTACHED_TO_ENTITY(entity, playerPed) or c4_exp_choice < 0 then
        ENTITY.SET_ENTITY_COLLISION(pj, false, false)
        ENTITY.FREEZE_ENTITY_POSITION(pj, true)
    else
        ENTITY.ENABLE_ENTITY_BULLET_COLLISION(pj) -- necessary?
    end
    ENTITY.SET_ALLOW_MIGRATE_TO_SPECTATOR(pj, 1) -- necessary?
    
    ENTITY.SET_ENTITY_VISIBLE(entity, false, false)
    ENTITY.SET_ENTITY_ALPHA(entity, 0, false)
    
    ENTITY.ATTACH_ENTITY_TO_ENTITY(pj, entity, 0, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)
    ENTITY.PROCESS_ENTITY_ATTACHMENTS(entity) -- necessary?

    ENTITY.SET_ENTITY_LOD_DIST(pj, ENTITY.GET_ENTITY_LOD_DIST(entity))	

    local unk = NETWORK.OBJ_TO_NET(pj) -- necessary?
    return pj
end

function get_world_addr()
    local world_base = memory.scan_pattern("48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07")
    local world_offset = world_base:add(3):get_dword()
    local world_addr = world_base:add(world_offset + 7)
    return world_addr:deref()
end

local pj_record = {}
local world_ptr = get_world_addr()
script.register_looped("bombloop", function (sc)
    sc:yield() -- necessary for numbers to update

    local playerPed = PLAYER.PLAYER_PED_ID()
    local pl_coords = ENTITY.GET_ENTITY_COORDS(playerPed)
    
    for k, v in pairs(pj_record) do
        if not ENTITY.DOES_ENTITY_EXIST(k) then
            if v ~= nil and ENTITY.DOES_ENTITY_EXIST(v) then				
                ENTITY.DELETE_ENTITY(v)
            end
            pj_record[k] = nil
        end
    end

    -- Handle explosion
    local curr_weap = 0
    local has_weap, curr_weap = WEAPON.GET_CURRENT_PED_WEAPON(playerPed, curr_weap)
    if has_weap and curr_weap == c4_weap_hash then
        local wpn_info_addr = world_ptr:add(0x8):deref():add(0x10B8):deref():add(0x20):deref()
        local ammo_info_addr = wpn_info_addr:add(0x60):deref()

        -- apply explosion
        ammo_info_addr:add(0x7C):set_dword(c4_exp_choice) -- default
        ammo_info_addr:add(0x80):set_dword(c4_exp_choice) -- hit car
        ammo_info_addr:add(0x84):set_dword(c4_exp_choice) -- hit truck
        ammo_info_addr:add(0x88):set_dword(c4_exp_choice) -- hit bike
        ammo_info_addr:add(0x8C):set_dword(c4_exp_choice) -- hit boat
        ammo_info_addr:add(0x90):set_dword(c4_exp_choice) -- hit plane
    end


    -- Handle attachment
    if c4_md_choice == 0 then
        return
    end

    local pj_obj = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(pl_coords.x, pl_coords.y, pl_coords.z, 100, before, false, false, false)
    local has_pj = pj_obj ~= nil and ENTITY.DOES_ENTITY_EXIST(pj_obj)

    if has_pj and pj_record[pj_obj] == nil then
        new_pj = spawn_obj(sc, pj_obj, after, playerPed)
        pj_record[pj_obj] = new_pj
    end
end)