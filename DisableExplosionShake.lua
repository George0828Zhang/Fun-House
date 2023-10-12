-- Author: George Chang (George0828Zhang)

enabled = true
debug = false

pattern = "4C 8B 0D ? ? ? ? 44 ? ? 05 ? ? ? ? 48 8D 15"
m_name = 0x0
m_cam_shake_name = 0x7c
struct_size = 0x88
patch_registry = {}

script.run_in_fiber(function(script)
    CExplosionInfoManager = memory.scan_pattern(pattern):add(3):rip()
    exp_list_base = CExplosionInfoManager:deref()
    exp_count = CExplosionInfoManager:add(0x8):get_word()

    for i=0,exp_count-1 do
        local exp_base = exp_list_base:add(struct_size * i)
        if debug then
            local orig = exp_base:add(m_cam_shake_name):get_dword()
            log.debug("found explosion tag: "..exp_base:add(m_name):deref():get_string().." value = "..tostring(orig))
        end
        local p = exp_base:add(m_cam_shake_name):patch_dword(0)
        if enabled then p:apply() end
        table.insert(patch_registry, p)
    end
    log.info((enabled and "Blocked " or "Found ")..tostring(exp_count).." explosion shakes.")
end)

myTab = gui.get_tab("GUI_TAB_PROTECTION_SETTINGS")
myTab:add_imgui(function()
    enabled, Toggled = ImGui.Checkbox("Block Explosion Shake", enabled)

    if Toggled then
        local i = 0
        for _, p in ipairs(patch_registry) do
            if enabled then p:apply() else p:restore() end
            i = i + 1
        end
        log.debug((enabled and "Block" or "Restor").."ed "..tostring(i).." explosion shakes.")
    end
end)
