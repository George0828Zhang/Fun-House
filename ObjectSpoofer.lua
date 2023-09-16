proximity = 50 -- only spoof object within proximity.
presets_text = {
    -- For objects see https://forge.plebmasters.de/objects
    -- Syntax:
    -- original_model={"new_model", offset(x,y,z), rotation(x,y,z)},
    --
    w_ex_apmine={"h4_prop_h4_ld_bomb_02a", vec3:new(0, 0, 0), vec3:new(-90, 0, 0)}, -- satchel, earth timer off
    w_ex_pe={"prop_cash_pile_01", vec3:new(0, 0, 0), vec3:new(90, 0, 90)},
    w_ex_pipebomb={"hei_prop_heist_thermite_flash", vec3:new(0, 0, 0), vec3:new(90, 0, 0)}, -- thermite timer on
    
    w_me_gclub={"prop_tool_sledgeham", vec3:new(0, 0, 0), vec3:new(-3, 0, 0)},
    w_me_dagger={"prop_cs_katana_01", vec3:new(0, 0, 0), vec3:new(0, 0, 0)},
    w_me_bat={"prop_tool_shovel2", vec3:new(0, 0.07, 0.85), vec3:new(180, 0, 0)},
    w_me_stonehatchet={"prop_cleaver", vec3:new(0.02, 0.02, 0.15), vec3:new(90, 0, 0)},
    

    w_me_machette_lr={"prop_ld_w_me_machette", vec3:new(0, 0, 0), vec3:new(0, 0, 0)},
    w_sb_compactsmg={"prop_tool_nailgun", vec3:new(-0.06, -0.02, 0), vec3:new(0, 0, 180)},

    w_me_hatchet={"prop_tool_pickaxe", vec3:new(0, 0, -0.25), vec3:new(0, 0, 0)},
    w_me_poolcue={"prop_tool_broom", vec3:new(0, 0, 0.25), vec3:new(180, 0, 0)},
    w_me_hammer={"prop_tool_mallet", vec3:new(0, 0, 0.15), vec3:new(0, 0, 0)},
    w_me_bottle={"prop_tool_screwdvr01", vec3:new(0.05, 0.1, 0.0), vec3:new(90, 0, 0)},

    w_at_scope_macro={"w_at_scope_nv", vec3:new(-0.05, 0, 0), vec3:new(0, 0, 0)},
}

function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. tostring(k) .. ": "
        if type(v) == "table" then
            log.info(formatting)
            tprint(v, indent+1)
        else
            log.info(formatting .. tostring(v))
        end
    end
end

function spawn_obj(sc, entity, hash, offset, rot)
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
        false
    )
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)

    ENTITY.SET_ENTITY_COLLISION(pj, false, false)
    if ENTITY.IS_ENTITY_ATTACHED(entity) then
        ENTITY.FREEZE_ENTITY_POSITION(pj, true)
    end
    ENTITY.SET_ALLOW_MIGRATE_TO_SPECTATOR(pj, 1) -- necessary?

    ENTITY.SET_ENTITY_VISIBLE(entity, false, false)
    ENTITY.SET_ENTITY_ALPHA(entity, 0, false)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(pj, entity, 0, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)
    ENTITY.PROCESS_ENTITY_ATTACHMENTS(entity) -- necessary?

    ENTITY.SET_ENTITY_LOD_DIST(pj, ENTITY.GET_ENTITY_LOD_DIST(entity))

    return pj
end

function get_world_addr()
    local world_base = memory.scan_pattern("48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07")
    if world_base:is_null() then
        log.warning("World address is null! Either the pattern changed or something else is wrong.")
    end
    local world_offset = world_base:add(3):get_dword()
    local world_addr = world_base:add(world_offset + 7)
    if world_addr:is_null() then
        log.warning("World address is null! Either the pattern changed or something else is wrong.")
        return nil
    end
    return world_addr:deref()
end

function get_cped_addr(world_addr)
    local addr1 = world_addr:add(0x8):deref()
    if addr1:is_null() then
        log.warning("CPed address is null! Either the offset changed or something else is wrong.")
        return nil
    end
    return addr1
end

function get_pos_from_addr(addr)
    if addr:is_null() then
        return vec3:new(0,0,0)
    end
    local nav_addr = addr:add(0x30):deref()
    if nav_addr:is_null() then
        return vec3:new(0,0,0)
    end
    local coords_addr = nav_addr:add(0x50)
    return vec3:new(
        coords_addr:get_float(),
        coords_addr:add(4):get_float(),
        coords_addr:add(8):get_float()
    )
end

function get_player_pos()
    local cped = get_cped_addr(world_addr)
    if cped:is_null() then
        return vec3:new(0,0,0)
    end
    return get_pos_from_addr(cped)
end

function get_obj_pos(obj)
    local addr = memory.handle_to_ptr(obj)
    return get_pos_from_addr(addr)
end

function network_owned(obj)
    return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(obj)
end

script.run_in_fiber(function(script)
    presets = {}
    obj_record = {}
    world_addr = get_world_addr()
    -- optimize presets
    for k, v in pairs(presets_text) do
        local k_hash = joaat(k)
        local v_hash = joaat(v[1])
        if not STREAMING.IS_MODEL_VALID(k_hash) then
            log.warning(string.format("%s (%d) is not valid model. Skipped.", k, k_hash))
            goto continue
        end
        if not STREAMING.IS_MODEL_VALID(v_hash) then
            log.warning(string.format("%s (%d) is not valid model. Skipped.", v[1], v_hash))
            goto continue
        end
        v[1] = v_hash
        presets[k_hash] = v
        ::continue::
    end
end)

script.register_looped("spoofloop", function (sc)
    sc:yield()
    -- GC
    for k, v in pairs(obj_record) do
        if not ENTITY.DOES_ENTITY_EXIST(k) then
            if v ~= nil and ENTITY.DOES_ENTITY_EXIST(v) then
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent,true,true)
                ENTITY.DELETE_ENTITY(v)
            end
            obj_record[k] = nil
        end
    end
    -- Handle attachment
    local ppos = get_player_pos()
    for model,repl_pack in pairs(presets) do
        local obj = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(ppos.x, ppos.y, ppos.z, proximity, model, false, false, false)
        local has_obj = obj ~= nil and ENTITY.DOES_ENTITY_EXIST(obj)
        if has_obj and obj_record[obj] == nil and network_owned(obj) then
            local repl_md = repl_pack[1]
            local repl_off = repl_pack[2]
            local repl_rot = repl_pack[3]
            local repl_obj = spawn_obj(sc, obj, repl_md, repl_off, repl_rot)
            obj_record[obj] = repl_obj
        end
    end
end)