-- CREDITS goes to 
-- DMKiller https://www.unknowncheats.me/forum/grand-theft-auto-v/591199-gtav-lazer-hydra-cannon-nerf-bypass.html
-- nloginov https://www.unknowncheats.me/forum/3831929-post14416.html

-- local tabName = "Jet"
-- local myTab = gui.get_tab(tabName)
local target = {0, -1, 0.03999999911}
local nerfed = {85, 0.125, 0.125}

function patch(a, b, c)
    local exp_typ_base = memory.scan_pattern("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? B8")
    exp_typ_ptr = exp_typ_base:add(0x10)

    local alt_time_base = memory.scan_pattern("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? ? ? F3 0F 10 05 ? ? ? ? ? ? F3 0F 10 83 50")
    local alt_time_offset = alt_time_base:add(0x15):get_dword()
    alt_time_ptr = alt_time_base:add(alt_time_offset + 0x19)

    local time_bt_shot_base = memory.scan_pattern("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? ? ? F3 0F 10 05 ? ? ? ? ? ? F3 0F 10 83 3C")
    local time_bt_shot_offset = time_bt_shot_base:add(0x15):get_dword()
    time_bt_shot_ptr = time_bt_shot_base:add(time_bt_shot_offset + 0x19)

    exp_typ_ptr:set_dword(a)
    alt_time_ptr:set_float(b)
    time_bt_shot_ptr:set_float(c)
end


script.run_in_fiber(function (script)
    patch(0, -1, 0.03999999911)
end)