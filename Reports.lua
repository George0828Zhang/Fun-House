local tab = gui.get_tab("GUI_TAB_NETWORK"):add_tab("Reports")

function STAT_GET_INT(statName)
    return stats.get_int(joaat(statName))
end
function STAT_GET_BOOL(statName)
    return stats.get_bool(joaat(statName))
end
function STAT_SET_INT(statName, value)
    stats.set_int(joaat(statName), value)
end
function STAT_SET_BOOL(statName, value)
    stats.set_bool(joaat(statName), value)
end

local arr = {}
arr[1] = {"Griefing", "MPPLY_GRIEFING"}
arr[2] = {"Exploits", "MPPLY_EXPLOITS"}
arr[3] = {"Bug Exploits", "MPPLY_GAME_EXPLOITS"}
arr[4] = {"Text Chat:Annoying Me", "MPPLY_TC_ANNOYINGME"}
arr[5] = {"Text Chat:Using Hate Speech", "MPPLY_TC_HATE"}
arr[6] = {"Voice Chat:Annoying Me", "MPPLY_VC_ANNOYINGME"}
arr[7] = {"Voice Chat:Using Hate Speech", "MPPLY_VC_HATE"}
arr[8] = {"Offensive Language", "MPPLY_OFFENSIVE_LANGUAGE"}
arr[9] = {"Offensive Tagplate", "MPPLY_OFFENSIVE_TAGPLATE"}
arr[10] = {"Offensive Content", "MPPLY_OFFENSIVE_UGC"}
arr[11] = {"Bad Crew Name", "MPPLY_BAD_CREW_NAME"}
arr[12] = {"Bad Crew Motto", "MPPLY_BAD_CREW_MOTTO"}
arr[13] = {"Bad Crew Status", "MPPLY_BAD_CREW_STATUS"}
arr[14] = {"Bad Crew Emblem", "MPPLY_BAD_CREW_EMBLEM"}
arr[15] = {"Friendly", "MPPLY_FRIENDLY"}
arr[16] = {"Helpful", "MPPLY_HELPFUL"}
arr[17] = {"Report Strength", "MPPLY_REPORT_STRENGTH"}
arr[18] = {"Commend Strength", "MPPLY_COMMEND_STRENGTH"}
arr[19] = {"Became Badsport Num", "MPPLY_BECAME_BADSPORT_NUM"}
arr[20] = {"Destroyed PV", "MPPLY_DESTROYED_PVEHICLES"}
arr[21] = {"Became Cheater Num", "MPPLY_BECAME_CHEATER_NUM"}
arr[22] = {"Badsport Message", "MPPLY_BADSPORT_MESSAGE"}
arr[24] = {"Mental State", "MPPLY_PLAYER_MENTAL_STATE"}
arr[25] = {"Playermade Title", "MPPLY_PLAYERMADE_TITLE"}
arr[26] = {"Playermade Desc", "MPPLY_PLAYERMADE_DESC"}
arr[27] = {"Overall Badsport", "MPPLY_OVERALL_BADSPORT"}
arr[28] = {"Overall Cheat", "MPPLY_OVERALL_CHEAT"}

local arrbool = {
    [1] = {"Is Punished", "MPPLY_ISPUNISHED"},
    [2] = {"Was I Badsport", "MPPLY_WAS_I_BAD_SPORT"},
    [3] = {"Was I Cheater", "MPPLY_WAS_I_CHEATER"},
    [4] = {"Was Character Badsport", "MPPLY_CHAR_IS_BADSPORT"},
}

function RELOAD_STATS()
    for k, v in pairs(arr) do
        local elem = v[3]
        elem:set_text(v[1] .. ": " .. tostring(STAT_GET_INT(v[2])))
    end
    for k, v in pairs(arrbool) do
        local elem = v[3]
        elem:set_text(v[1] .. ": " .. tostring(STAT_GET_BOOL(v[2])))
    end
end
tab:add_button("Reload", RELOAD_STATS)

function CLEAR_STATS()
    for k, v in pairs(arr) do
        STAT_SET_INT(v[2], 0)
    end
    for k, v in pairs(arrbool) do
        STAT_SET_BOOL(v[2], false)
    end
end
tab:add_sameline()
tab:add_button("Clear", CLEAR_STATS)

for k, v in pairs(arr) do
    local elem = tab:add_text(v[1] .. ": ?")
    arr[k] = {v[1], v[2], elem}
end
for k, v in pairs(arrbool) do
    local elem = tab:add_text(v[1] .. ": ?")
    arrbool[k] = {v[1], v[2], elem}
end
-- RELOAD_STATS()



