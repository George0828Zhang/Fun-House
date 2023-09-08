-- Author: George Chang (George0828Zhang)
-- Credits:
--  read xml      http://lua-users.org/wiki/LuaXml
--  print table   (hashmal)  https://gist.github.com/hashmal/874792
--  worldpointer  (DDHibiki) https://www.unknowncheats.me/forum/grand-theft-auto-v/496174-worldptr.html
--  offsets       https://github.com/Yimura/GTAV-Classes

require("weaponsmeta")

function parseargs(s)
    local arg = {}
    string.gsub(s, "([%-%w]+)=([\"'])(.-)%2", function (w, _, a)
      arg[w] = a
    end)
    return arg
end
    
function collect(s)
    local stack = {}
    local top = {}
    table.insert(stack, top)
    local ni,c,label,xarg, empty
    local i, j = 1, 1
    while true do
        ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
        if not ni then break end
        local text = string.sub(s, i, ni-1)
        if not string.find(text, "^%s*$") then
        table.insert(top, text)
        end
        if empty == "/" then  -- empty element tag
        table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
        elseif c == "" then   -- start tag
        top = {label=label, xarg=parseargs(xarg)}
        table.insert(stack, top)   -- new level
        else  -- end tag
        local toclose = table.remove(stack)  -- remove top
        top = stack[#stack]
        if #stack < 1 then
            error("nothing to close with "..label)
        end
        if toclose.label ~= label then
            error("trying to close "..toclose.label.." with "..label)
        end
        table.insert(top, toclose)
        end
        i = j+1
    end
    local text = string.sub(s, i)
    if not string.find(text, "^%s*$") then
        table.insert(stack[#stack], text)
    end
    if #stack > 1 then
        error("unclosed "..stack[#stack].label)
    end
    return stack[1]
end

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

function handle_enum(name, value)
    local tabl = nil
    if name == "DamageType" then
        tabl = {
            BULLET = 3,
            EXPLOSIVE = 5
        }
    elseif string.sub(name,1,string.len("Explosion")) == "Explosion" then
        tabl = {
            DONTCARE = -1,
            GRENADE = 0,
            MOLOTOV = 3,
            ROCKET = 4,
            TANKSHELL = 5,
            BZGAS = 21,
            FLARE = 22,
            EXPLOSIVEAMMO_SHOTGUN = 61
        }
    elseif name == "FireType" then
        tabl = {
            NONE = 0,
            MELEE = 1,
            INSTANT_HIT = 2,
            DELAYED_HIT = 3,
            PROJECTILE = 4,
            VOLUMETRIC_PARTICLE = 5
        }
    else
        tabl = {}
    end
    return tabl[value]
end

function parse_into_gta_form(itemtype, vpack)
    local offset_types = {
        CWeaponInfo={
            Model={0x0014, "hash"},
            Audio={0x0018, "hash"},
            DamageType={0x0020, "enum"},
            ExplosionDefault={0x0024, "enum"},
            ExplosionHitCar={0x0028, "enum"},
            ExplosionHitTruck={0x002C, "enum"},
            ExplosionHitBike={0x0030, "enum"},
            ExplosionHitBoat={0x0034, "enum"},
            ExplosionHitPlane={0x0038, "enum"},
            FireType={0x0054, "enum"},
            -- <AmmoInfo ref="AMMO_SHOTGUN" /> -- need to handle directly
            ClipSize={0x0070, "int"},
            Damage={0x00B0, "float"},
            -- WeaponFlags={0x0900, "flags"}
        },
    }
    local out = nil
    if offset_types[itemtype] ~= nil and offset_types[itemtype][vpack.label] ~= nil then
        local offset, tp = table.unpack(offset_types[itemtype][vpack.label])
        local value = vpack[1]
        if vpack.empty then
            value = vpack.xarg.value
        end
        local gta = "dword" -- default
        if tp == "hash" then
            value = joaat(value)
        elseif tp == "enum" then
            value = handle_enum(vpack.label, value)
        elseif tp == "int" then
            value = tonumber(value)
        else
            value = tonumber(value)
            gta = "float"
        end
        out = {offset=offset, gtatype=gta, val=value}
    end
    return out
end
function transform(meta)
    -- transform table into efficient lookup    
    local lookup = {
        CWeaponInfo={},
    }
    local key = nil
    for _, item in pairs(meta) do -- each <Item type=...>
        if item.xarg ~= nil and item.xarg.type ~= nil and lookup[item.xarg.type] ~= nil then
            local ihash = nil
            local itype = item.xarg.type
            local data = {} -- [offset]={gtatype=, val=}
            for k, v in pairs(item) do -- each <Field>?</>
                if v.label == "Name" then
                    ihash = joaat(v[1]) -- e.g. WEAPON_PISTOL
                elseif v.label == "Explosion" then
                    for ch_k, ch_v in pairs(v) do
                        if type(ch_k) == "number" then
                            ch_v.label = "Explosion"..ch_v.label
                            table.insert(data, parse_into_gta_form(itype, ch_v))
                        end
                    end
                else
                    table.insert(data, parse_into_gta_form(itype, v))
                end
            end
            lookup[itype][ihash] = data
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

local world_ptr = get_world_addr()
function apply_weapons_meta(script, lookup, curr_weap)
    local wpn_info_addr = world_ptr:add(0x8):deref():add(0x10B8):deref():add(0x20):deref()
    -- apply CWeaponInfo changes
    local data = lookup.CWeaponInfo[curr_weap]
    for k, v in pairs(data) do
        local wpn_field_addr = wpn_info_addr:add(v.offset)
        -- special handling model
        if v.gtatype == "byte" then
            wpn_field_addr:set_byte(v.val)
        elseif v.gtatype == "word" then
            wpn_field_addr:set_word(v.val)
        elseif v.gtatype == "dword" then
            if STREAMING.IS_MODEL_VALID(v.val) then
                STREAMING.REQUEST_MODEL(v.val)
                while not STREAMING.HAS_MODEL_LOADED(v.val) do script:yield() end
            end
            wpn_field_addr:set_dword(v.val)            
        elseif v.gtatype == "float" then
            wpn_field_addr:set_float(v.val)
        elseif v.gtatype == "qword" then
            wpn_field_addr:set_qword(v.val)
        elseif v.gtatype == "string" then
            wpn_field_addr:set_string(v.val)
        end
        log.info("[debug][wpn_info] Applied "..tostring(v.val).." at "..string.format("0x%x", v.offset))
    end
end


local myTab = gui.get_tab("Debug")
local lookup = transform(collect(weaponsmeta))
local prev_weapon = nil
myTab:add_button("reload", function()
    lookup = transform(collect(weaponsmeta))
    prev_weapon = nil
    world_ptr = get_world_addr()
    log.info("[weaponsmeta] reloaded.")
end)

script.register_looped("weaponloop", function (script)
    -- on weapon changed
    local playerPed = PLAYER.PLAYER_PED_ID()
    local curr_weap = 0
    local has_weap, curr_weap = WEAPON.GET_CURRENT_PED_WEAPON(playerPed, curr_weap)
    if has_weap and curr_weap ~= prev_weapon and lookup.CWeaponInfo[curr_weap] ~= nil then
        apply_weapons_meta(script, lookup, curr_weap)
        log.info("Applied all weapon stats for: "..tostring(curr_weap))
        prev_weapon = curr_weap
    end
end)