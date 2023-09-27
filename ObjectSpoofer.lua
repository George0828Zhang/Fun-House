proximity = 50 -- only spoof object within proximity.
presets_text = {
    -- For objects see https://forge.plebmasters.de/objects
    -- Syntax:
    -- original_model={"new_model", offset(x,y,z), rotation(x,y,z)},
    --
    w_ex_apmine={"h4_prop_h4_ld_bomb_02a", vec3:new(0, 0, 0), vec3:new(-90, 0, 0)},
    w_ex_pe={"prop_cash_pile_01", vec3:new(0, 0, 0), vec3:new(90, 0, 90)},
    w_ex_pipebomb={"hei_prop_heist_thermite_flash", vec3:new(0, 0, 0), vec3:new(90, 0, 0)},
    
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

function spawn_obj(sc, entity, repl_pack)
    local is_attach = false
    if ENTITY.IS_ENTITY_ATTACHED(entity) then
        is_attach = true
        local at_entity = entity
        while ENTITY.DOES_ENTITY_EXIST(at_entity) and not ENTITY.IS_ENTITY_A_PED(at_entity) do
            at_entity = ENTITY.GET_ENTITY_ATTACHED_TO(at_entity)
        end
        if ENTITY.DOES_ENTITY_EXIST(at_entity) and at_entity ~= playerPed then
            return nil
        end
    end
    local hash = repl_pack[1]
    local offset = repl_pack[2]
    local rot = repl_pack[3]
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
    if is_attach then
        ENTITY.FREEZE_ENTITY_POSITION(pj, true)
    end
    ENTITY.SET_ALLOW_MIGRATE_TO_SPECTATOR(pj, 1) -- necessary?

    ENTITY.SET_ENTITY_VISIBLE(entity, false, false)
    ENTITY.SET_ENTITY_ALPHA(entity, 0, false)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(pj, entity, 0, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)

    ENTITY.SET_ENTITY_LOD_DIST(pj, ENTITY.GET_ENTITY_LOD_DIST(entity))

    return pj
end

script.run_in_fiber(function(script)
    presets = {}
    obj_record = {}
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
    playerPed = PLAYER.PLAYER_PED_ID()
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
    for _, obj in pairs(entities.get_all_objects_as_handles()) do
        local repl_pack = presets[ENTITY.GET_ENTITY_MODEL(obj)]
        if repl_pack ~= nil and obj_record[obj] == nil then
            obj_record[obj] = spawn_obj(sc, obj, repl_pack)
        end
    end
end)