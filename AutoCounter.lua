local projectile_names = {
    -- unks:
    -- xs_prop_arena_airmissile_01a
    -- gr_prop_gr_missle_long
    -- gr_prop_gr_missle_short
    -- "w_arena_airmissile_01a",
    -- "w_smug_airmissile_01",
    -- "w_smug_airmissile_01b",
    -- "w_smug_airmissile_02b",
    -- "h4_prop_h4_airmissile_01a" -- kosatka maybe
    -- -- apc & pounder c (no lockon)
    -- "w_ex_vehiclemissile_2",

    -- strikeforce
    "w_battle_airmissile_01",
    -- nearly all planes/helicopters, tampa, mule c
    "w_lr_rpg_rocket",
    -- homing launcher
    "w_lr_homing_rocket",
    -- akula, hunter, annihilator s, 
    "w_smug_airmissile_02",
    -- oppressor 1 and 2, stromberg, toreador, deluxo, vigilante, thruster, scramjet
    "w_ex_vehiclemissile_3",
    -- aa trailer
    "w_ex_vehiclemissile_1",
    -- chernobog
    "w_ex_vehiclemissile_4",
}
local projectiles = {}
for _, name in pairs(projectile_names) do
    projectiles[name] = joaat(name)
end
local flare_hash = joaat("WEAPON_FLAREGUN")
local flare_orig = vec3:new(0,0,0)
local flare_dests = {
    vec3:new(0,10,5),
    vec3:new(0,10,-5),

    vec3:new(5,-10,-1),
    vec3:new(-5,-10,-1),
}
local flare_interval_ms = 300
local counter_range = 200
local invisible = false

function is_approaching(playerPed, pl_coords, proj)
    local pl_vel = ENTITY.GET_ENTITY_VELOCITY(playerPed)
    local proj_coords = ENTITY.GET_ENTITY_COORDS(proj)
    local proj_vel = ENTITY.GET_ENTITY_VELOCITY(proj)

    local d_x = pl_coords.x - proj_coords.x
    local d_y = pl_coords.y - proj_coords.y
    local d_z = pl_coords.z - proj_coords.z
    local delta = SYSTEM.VMAG(d_x, d_y, d_z)

    local proj_speed = proj_vel.x * d_x + proj_vel.y * d_y + proj_vel.z * d_z
    local rel_speed  = proj_speed - (pl_vel.x * d_x + pl_vel.y * d_y + pl_vel.z * d_z)

    return proj_speed > 0 and rel_speed > 2 * delta -- x/d > 2
end
function deploy_once(sc, playerPed)
    WEAPON.REQUEST_WEAPON_ASSET(flare_hash, 31, 0)
    while not WEAPON.HAS_WEAPON_ASSET_LOADED(flare_hash) do sc:yield() end
    for _, flare_dest in pairs(flare_dests) do
        local offset_orig = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(
            playerPed, flare_orig.x, flare_orig.y, flare_orig.z)
        local offset_dest = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(
            playerPed, flare_dest.x, flare_dest.y, flare_dest.z)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(
            offset_orig.x,
            offset_orig.y,
            offset_orig.z,
            offset_dest.x,
            offset_dest.y,
            offset_dest.z,
            25, false, flare_hash, playerPed, true, invisible, 0.1, playerPed, 0)
        sc:sleep(flare_interval_ms)
    end
end

script.register_looped("counterloop", function (sc)
    sc:yield() -- necessary numbers to update
     
    local playerPed = PLAYER.PLAYER_PED_ID()
    local pl_coords = ENTITY.GET_ENTITY_COORDS(playerPed)
    
    for name, v in pairs(projectiles) do
        local proj = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(pl_coords.x, pl_coords.y, pl_coords.z, counter_range, v, false, false, false)
        local has_pj = proj ~= nil and ENTITY.DOES_ENTITY_EXIST(proj)

        local air = ENTITY.IS_ENTITY_IN_AIR(proj)
        local a_o = ENTITY.IS_ENTITY_ATTACHED_TO_ANY_OBJECT(proj)
        -- local a_p = ENTITY.IS_ENTITY_ATTACHED_TO_ANY_PED(proj)
        -- local a_v = ENTITY.IS_ENTITY_ATTACHED_TO_ANY_VEHICLE(proj)
        if has_pj and air and not a_o then
            -- log.info("Detected "..name.."("..tostring(proj).." "..tostring(air).." "..tostring(a_o).." "..tostring(a_p).." "..tostring(a_v)..") at "..tostring(proj_coords))
            if is_approaching(playerPed, pl_coords, proj) then
                deploy_once(sc, playerPed)
            end
        end
    end
    -- check each seconds
    sc:sleep(flare_interval_ms)
end)

-- local myTab = gui.get_tab("Debug")
-- myTab:add_button("shoot self", function()
--     local playerPed = PLAYER.PLAYER_PED_ID()
--     local weap_hash = joaat("weapon_hominglauncher")
--     local offset_orig = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(
--         playerPed, 0, -300, -5)
--     local offset_dest = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(
--         playerPed, 0, 0, 0)
--     WEAPON.REQUEST_WEAPON_ASSET(weap_hash, 31, 0)
--     -- while not WEAPON.HAS_WEAPON_ASSET_LOADED(weap_hash) do script:yield() end
--     MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY_NEW(
--             offset_orig.x,
--             offset_orig.y,
--             offset_orig.z,
--             offset_dest.x,
--             offset_dest.y,
--             offset_dest.z,
--     100, false, weap_hash, playerPed, true, false, 2000, nil, false, false, playerPed, false, 0, 0, 0) 
-- end)

