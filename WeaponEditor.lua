-- Author: George Chang (George0828Zhang)
-- Credits:
--  read xml      http://lua-users.org/wiki/LuaXml
--  print table   (hashmal)  https://gist.github.com/hashmal/874792
--  worldpointer  (DDHibiki) https://www.unknowncheats.me/forum/grand-theft-auto-v/496174-worldptr.html
--  offsets       https://github.com/Yimura/GTAV-Classes

require("lib/xmlreader")
require("lib/gtaenums")
require("lib/gtaoffsets")
require("weaponsmeta")

local verbose = true

function log_info(msg)
    if verbose then
        log.info(msg)
    end
end

function _handle_enum(name, value)
    if name == "DamageType" then
        return eDamageType[value]
    elseif name:find("^Explosion") ~= nil then
        return eExplosion[value]
    elseif name == "FireType" then
        return eFireType[value]
    elseif name == "EffectGroup" then
        return eEffectGroup[value]
    elseif name == "WeaponFlags" then
        return eWeaponFlags[value]
    elseif name == "AmmoSpecialType" then
        return eAmmoSpecialType[value]
    elseif name == "AmmoFlags" then
        return eAmmoFlags[value]
    elseif name == "ProjectileFlags" then
        return eProjectileFlags[value]
    end
end

function handle_enum(name, value)
    local out = _handle_enum(name, value)
    if out == nil then
        log_info("[debug][enum] Unseen enum/flag: "..value.." in "..name)
    end
    return out
end

function recursive_parse_into_gta_form(inner_table, output_table, model_registry, value_pack, next_tag)
    -- recursive call
    for sub_k, sub_v in pairs(value_pack) do
        parse_into_gta_form(inner_table, output_table, model_registry, sub_v, next_tag)
    end
end

function parse_into_gta_form_array(offset_table, output_table, model_registry, value_pack, parent_tag)
    -- array syntax
    -- base, "array", ItemTemplate, count
    local key = value_pack.label
    local offset = offset_table[key][1]
    if offset_table._base ~= nil then
        offset = offset + offset_table._base
    end

    local inner_table = offset_table[key].ItemTemplate -- should be another table
    local interval = offset_table[key].ItemSize
    local count = 0
    for _, value_item in pairs(value_pack) do
        if value_item.label == "Item" then
            inner_table._base = offset + count * interval
            recursive_parse_into_gta_form(inner_table, output_table, model_registry, value_item, parent_tag..key)
            count = count + 1
        end
    end
    -- handle count
    local count_pack = {label="Count", count}
    if offset_table._base ~= nil then
        offset_table[key]._base = offset_table._base
    end
    parse_into_gta_form(offset_table[key], output_table, model_registry, count_pack, parent_tag)
end

function parse_into_gta_form(offset_table, output_table, model_registry, value_pack, parent_tag)
    local key = value_pack.label
    if offset_table[key] == nil then
        return
    end

    if offset_table[key][1] == nil then
        local inner_table = offset_table[key] -- should be another table
        recursive_parse_into_gta_form(inner_table, output_table, model_registry, value_pack, parent_tag..key)
    elseif offset_table[key][2] == "array" then
        parse_into_gta_form_array(offset_table, output_table, model_registry, value_pack, parent_tag)
    else
        -- has offset + not array
        local offset = offset_table[key][1]
        local typ = offset_table[key][2]
        local value = value_pack[1]
        if value_pack.empty and value_pack.xarg.value ~= nil then
            value = value_pack.xarg.value -- e.g. <ClipSize value="6" />
        end
        if offset_table._base ~= nil then
            offset = offset + offset_table._base
        end
        local gta = "dword" -- default
        if typ == "hash" then
            value = joaat(value)
            model_registry[value] = 1
        elseif typ == "enum" then
            value = handle_enum(parent_tag..key, value)
        elseif typ == "int" then
            value = tonumber(value)
        elseif typ == "bool" then
            value = (value == "true")
            gta = "byte"
        elseif typ:find("^flags") ~= nil then -- flags32, flags192 etc
            bits = {}
            for w in value:gmatch("%S+") do
                table.insert(bits, handle_enum(key, w))
            end
            value = bits
            gta = typ:gsub("flags", "bitset")
        elseif typ == "vec2" then
            value = tonumber(value_pack.xarg.x)
            gta = "float"
            table.insert(output_table, {offset=offset + 4, gtatype="float", val=tonumber(value_pack.xarg.y)})
        elseif typ == "vec3" then
            value = tonumber(value_pack.xarg.x)
            gta = "float"
            table.insert(output_table, {offset=offset + 4, gtatype="float", val=tonumber(value_pack.xarg.y)})
            table.insert(output_table, {offset=offset + 8, gtatype="float", val=tonumber(value_pack.xarg.z)})
        elseif typ == "ref_ammo" then
            value = joaat(value_pack.xarg.ref)
            gta = "ref_ammo"
        else
            value = tonumber(value)
            gta = "float"
        end
        table.insert(output_table, {offset=offset, gtatype=gta, val=value})
    end
end

function transform(meta, model_registry)
    -- transform table into efficient lookup
    local lookup = {
        CWeaponInfo={},
        CAmmoInfo={}
    }
    local alias = {
        CWeaponInfo="CWeaponInfo",
        CAmmoInfo="CAmmoInfo",
        CAmmoProjectileInfo="CAmmoInfo",
        CAmmoThrownInfo="CAmmoInfo",
        CAmmoRocketInfo="CAmmoInfo"
    }
    for _, item in pairs(meta) do -- each <Item type=...>
        if item.xarg ~= nil and item.xarg.type ~= nil then
            local key = alias[item.xarg.type]
            if lookup[key] ~= nil then
                local item_hash = nil
                local item_type = key
                local data = {} -- {offset=, gtatype=, val=}
                for _, value_pack in pairs(item) do -- each <Field>
                    if value_pack.label == "Name" then
                        item_hash = joaat(value_pack[1]) -- e.g. WEAPON_PISTOL
                    elseif gta_offset_types[item_type] ~= nil then
                        parse_into_gta_form(gta_offset_types[item_type], data, model_registry, value_pack, "")
                    end
                end
                lookup[item_type][item_hash] = data
            end
        end
    end 
    return lookup
end



function get_world_addr()
    local world_base = memory.scan_pattern("48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07")
    local world_offset = world_base:add(3):get_dword()
    local world_addr = world_base:add(world_offset + 7)
    return world_addr:deref()
end

function try_load(script, model, looktype)
    -- if not STREAMING.IS_MODEL_VALID(model) then
    --     model = WEAPON.GET_WEAPON_COMPONENT_TYPE_MODEL(model)
    -- end
    if not STREAMING.IS_MODEL_VALID(model) then
        return
    end
    STREAMING.REQUEST_MODEL(model)
    while not STREAMING.HAS_MODEL_LOADED(model) do script:yield() end
    log_info("[debug]["..looktype.."] loaded model "..tostring(model))
end

function apply_weapons_meta(script, lookup, looktype, curr_weap, base_addr, model_registry)
    local data = lookup[looktype][curr_weap]
    for k, v in pairs(data) do
        local wpn_field_addr = base_addr:add(v.offset)
        -- special handling model
        if v.gtatype == "byte" then
            wpn_field_addr:set_byte(v.val)
        elseif v.gtatype == "word" then
            wpn_field_addr:set_word(v.val)
        elseif v.gtatype == "dword" then
            if model_registry[v.val] ~= nil then
                try_load(script, v.val, looktype)
            end
            wpn_field_addr:set_dword(v.val)
        elseif v.gtatype == "float" then
            wpn_field_addr:set_float(v.val)
        elseif v.gtatype == "qword" then
            wpn_field_addr:set_qword(v.val)
        elseif v.gtatype == "string" then
            wpn_field_addr:set_string(v.val)
        elseif v.gtatype == "bitset192" then
            local bitset64s = {0, 0, 0}
            local debugmsg = "[debug]["..looktype.."][flags] bits="
            for _, b in pairs(v.val) do
                local q = b // 64 + 1 -- lua 1-indexed
                local r = b % 64
                debugmsg = debugmsg..tostring(b).." "
                bitset64s[q] = bitset64s[q] | (1 << r)
            end
            log_info(debugmsg)
            -- log_info("[debug]["..looktype.."][flags] bitset1="..tostring(bitset64s[1]))
            wpn_field_addr:set_qword(bitset64s[1])
            wpn_field_addr:add(8):set_qword(bitset64s[2])
            wpn_field_addr:add(16):set_qword(bitset64s[3])
        elseif v.gtatype == "bitset32" then
            local bitset = 0
            local debugmsg = "[debug]["..looktype.."][flags] bits="
            for _, b in pairs(v.val) do
                debugmsg = debugmsg..tostring(b).." "
                bitset = bitset | (1 << b)
            end
            log_info(debugmsg)
            wpn_field_addr:set_dword(bitset)
        elseif v.gtatype == "ref_ammo" and looktype == "CWeaponInfo" then
            local curr_ammo = v.val
            local ammo_info_addr = base_addr:add(0x60):deref()
            if lookup.CAmmoInfo[curr_ammo] ~= nil then
                -- recursive call
                apply_weapons_meta(script, lookup, "CAmmoInfo", curr_ammo, ammo_info_addr, model_registry)
            end
        end
        log_info("[debug]["..looktype.."] Applied "..tostring(v.val).." at "..string.format("0x%x", v.offset))
    end
end

function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. tostring(k) .. ": "
        if type(v) == "table" then
            log_info(formatting)
            tprint(v, indent+1)
        else
            log_info(formatting .. tostring(v))
        end
    end
end

function print_hash(name)
    log_info(name .. " hash is "..tostring(joaat(name)))
end

local attachment_registry = {}
function register_attachments(xml, track, depth, components)
    track[depth] = xml.label
    local isouter = false
    if xml.xarg ~= nil and xml.xarg.type == "CWeaponInfo" then
        track[depth] = xml.xarg.type
        isouter = true
    end
    local weapon_hash = nil
    for _, item in pairs(xml) do
        if isouter and item.label == "Name" then
            weapon_hash = joaat(item[1])
        end
        if type(item) == "table" then
            if item.label == "Name" and track[2] == "AttachPoints" and track[4] == "Components" then
                table.insert(components, item[1])
            end
            register_attachments(item, track, depth + 1, components)
        end
    end
    if isouter and weapon_hash ~= nil then
        for k, item in pairs(components) do
            if attachment_registry[weapon_hash] == nil then
                attachment_registry[weapon_hash] = {}
            end
            table.insert(attachment_registry[weapon_hash], item)
            components[k] = nil
        end
    end
    track[depth] = nil
end

local myTab = gui.get_tab("Weapon Editor") -- or put "GUI_TAB_WEAPONS"
local rawxml = nil
local lookup = nil
local prev_weapon = nil
local model_registry = {}

function reload_meta()
    package.loaded.weaponsmeta = nil
    require("weaponsmeta")
    prev_weapon = nil
    sel_attachment = 1
    model_registry = {}
    attachment_registry = {}
    playerPed = PLAYER.PLAYER_PED_ID()
    has_weap, curr_weap = WEAPON.GET_CURRENT_PED_WEAPON(playerPed, curr_weap)
    rawxml = collect(weaponsmeta)
    lookup = transform(rawxml, model_registry)
    register_attachments(rawxml, {}, 0, {})
    log_info("weaponsmeta.lua reloaded.")
end

local world_ptr = get_world_addr()
local wpn_info_addr = world_ptr:add(0x8):deref():add(0x10B8):deref():add(0x20):deref()
local playerPed = 0
local has_weap = 0
local curr_weap = 0
local sel_attachment = 1
reload_meta()
-- tprint(rawxml)
-- tprint(lookup)
-- tprint(attachment_registry)

myTab:add_imgui(function()

    if ImGui.Button("Reload weaponsmeta.lua") then
        reload_meta()
    end
    if ImGui.IsItemHovered() then
        ImGui.SetTooltip("Press to reload your weaponsmeta.lua after making changes.")
    end

    playerPed = PLAYER.PLAYER_PED_ID()
    has_weap, curr_weap = WEAPON.GET_CURRENT_PED_WEAPON(playerPed, curr_weap)
    if not has_weap or attachment_registry[curr_weap] == nil then
        ImGui.Text("Equip a modded weapon to apply attachments.")
        return
    end

    if ImGui.BeginCombo("Modded Attachments", attachment_registry[curr_weap][sel_attachment], ImGuiComboFlags.PopupAlignLeft) then
        for k, v in pairs(attachment_registry[curr_weap]) do
            if ImGui.Selectable(v, k == sel_attachment) then
                sel_attachment = k
            end
            if k == sel_attachment then
                ImGui.SetItemDefaultFocus()
            end
        end
        ImGui.EndCombo()
    end
    if ImGui.IsItemHovered() then
        ImGui.SetTooltip("These are the attachments found in your weaponsmeta.lua.")
    end

    local comp = joaat(attachment_registry[curr_weap][sel_attachment])
    local hascomp = WEAPON.HAS_PED_GOT_WEAPON_COMPONENT(playerPed, curr_weap, comp)
    -- local active = WEAPON.IS_PED_WEAPON_COMPONENT_ACTIVE(playerPed, curr_weap, comp)
    if ImGui.Button(hascomp and "Remove" or "Add") then
        if hascomp then
            WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(playerPed, curr_weap, comp)
        else
            WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(playerPed, curr_weap, comp)
        end
        hascomp = WEAPON.HAS_PED_GOT_WEAPON_COMPONENT(playerPed, curr_weap, comp)
        active = WEAPON.IS_PED_WEAPON_COMPONENT_ACTIVE(playerPed, curr_weap, comp)
        log_info("[debug][attachment]: has "..tostring(hascomp).." active "..tostring(active))
    end
    if ImGui.IsItemHovered() then
        ImGui.SetTooltip("Press to give or remove selected attachment from current weapon.")
    end
end)

script.register_looped("weaponloop", function (script)
    -- on weapon changed
    if has_weap and curr_weap ~= prev_weapon and lookup.CWeaponInfo[curr_weap] ~= nil then
        world_ptr = get_world_addr()
        wpn_info_addr = world_ptr:add(0x8):deref():add(0x10B8):deref():add(0x20):deref()
        -- apply CWeaponInfo changes
        apply_weapons_meta(script, lookup, "CWeaponInfo", curr_weap, wpn_info_addr, model_registry)
        prev_weapon = curr_weap
    end
    script:yield() -- necessary for numbers to update
end)
