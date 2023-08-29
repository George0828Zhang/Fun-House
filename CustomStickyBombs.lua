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

local before = joaat("w_ex_pe") -- 3184763647 -- 
local after = joaat(c4_md_presets[c4_md_choice][1])
local offset = c4_md_presets[c4_md_choice][2]
local rot = c4_md_presets[c4_md_choice][3]

local c4_exp_presets = {
	[-1] = "Disabled",
	[0] = "GRENADE",
	-- See https://altv.stuyk.com/docs/articles/tables/explosions.html
	"GRENADELAUNCHER","STICKYBOMB","MOLOTOV","ROCKET","TANKSHELL","HI_OCTANE","CAR","PLANE","PETROL_PUMP","BIKE","STEAM","FLAME","WATER_HYDRANT","GAS_CANISTER","BOAT","SHIP_DESTROY","TRUCK","BULLET","SMOKEGRENADELAUNCHER","SMOKEGRENADE","BZGAS","FLARE","GAS_CANISTER","EXTINGUISHER","PROGRAMMABLEAR","TRAIN","BARREL","PROPANE","BLIMP","FLAME_EXPLODE","TANKER","PLANE_ROCKET","VEHICLE_BULLET","GAS_TANK","BIRD_CRAP","RAILGUN","BLIMP2","FIREWORK","SNOWBALL","PROXMINE","VALKYRIE_CANNON","AIR_DEFENSE","PIPEBOMB","VEHICLEMINE","EXPLOSIVEAMMO","APCSHELL","BOMB_CLUSTER","BOMB_GAS","BOMB_INCENDIARY","BOMB_STANDARD","TORPEDO","TORPEDO_UNDERWATER","BOMBUSHKA_CANNON","BOMB_CLUSTER_SECONDARY","HUNTER_BARRAGE","HUNTER_CANNON","ROGUE_CANNON","MINE_UNDERWATER","ORBITAL_CANNON","BOMB_STANDARD_WIDE","EXPLOSIVEAMMO_SHOTGUN","OPPRESSOR2_CANNON","MORTAR_KINETIC","VEHICLEMINE_KINETIC","VEHICLEMINE_EMP","VEHICLEMINE_SPIKE","VEHICLEMINE_SLICK","VEHICLEMINE_TAR","SCRIPT_DRONE","RAYGUN","BURIEDMINE","SCRIPT_MISSILE"
}
local c4_exp_choice = -1 --60
local explode_thres = 975

log.info("Hash "..tostring(c4_md_presets[c4_md_choice][1]).." valid: "..tostring(STREAMING.IS_MODEL_VALID(after)))

local tabName = "GUI_TAB_WEAPONS"
local Tab = gui.get_tab(tabName)

Tab:add_imgui(function()
	ImGui.Text("Customize C4")
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
	if ImGui.BeginCombo("C4 Explosion", tostring(c4_exp_presets[c4_exp_choice]), ImGuiComboFlags.PopupAlignLeft) then
		for k, v in pairs(c4_exp_presets) do
			if ImGui.Selectable(v, k == c4_exp_choice) then
				c4_exp_choice = k
			end
			if k == c4_exp_choice then
				ImGui.SetItemDefaultFocus()
			end
		end
		ImGui.EndCombo()
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

function handle_explode(sc, master, pj, owner)	
	local v_coords = ENTITY.GET_ENTITY_COORDS(pj)
	local trigger_by_master = FIRE.IS_EXPLOSION_IN_SPHERE(2, v_coords.x, v_coords.y, v_coords.z, 3.0)
	local trigger = false
	if ENTITY.GET_ENTITY_HEALTH(pj) <= explode_thres then
		log.info("BOOOOOM by health: "..tostring(pj).." h="..tostring(ENTITY.GET_ENTITY_HEALTH(pj)))
		trigger = true
	elseif trigger_by_master then
		log.info("BOOOOOM by nearby: "..tostring(pj))
		trigger = true
	end
	if not trigger then
		return
	end
	sc:sleep(230) -- when lower than 200 the game ignores the explosion
	local radius = 0.5
	MISC.CLEAR_AREA_OF_PROJECTILES(v_coords.x, v_coords.y, v_coords.z, radius, true)

	if owner ~= nil and ENTITY.IS_ENTITY_A_PED(owner) then
		FIRE.ADD_OWNED_EXPLOSION(owner, v_coords.x, v_coords.y, v_coords.z, c4_exp_choice, 1.0, true, false, false)
	else
		FIRE.ADD_EXPLOSION(v_coords.x, v_coords.y, v_coords.z, c4_exp_choice, 1.0, true, false, false)
	end
	ENTITY.DELETE_ENTITY(pj)
end

local pj_record = {}
script.register_looped("bombloop", function (sc)
    sc:yield() -- necessary for numbers to update
	if c4_md_choice == 0 then
		return
	end

	local playerPed = PLAYER.PLAYER_PED_ID()
	local pl_coords = ENTITY.GET_ENTITY_COORDS(playerPed)
	
	for k, v in pairs(pj_record) do		
		if c4_exp_choice >= 0 and v ~= nil and ENTITY.DOES_ENTITY_EXIST(v) then
			handle_explode(sc, k, v, nil)
		end
		if not ENTITY.DOES_ENTITY_EXIST(k) then
			if v ~= nil and ENTITY.DOES_ENTITY_EXIST(v) then				
				ENTITY.DELETE_ENTITY(v)
			end
			pj_record[k] = nil
		end
	end

	local pj_obj = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(pl_coords.x, pl_coords.y, pl_coords.z, 100, before, false, false, false)
	local has_pj = pj_obj ~= nil and ENTITY.DOES_ENTITY_EXIST(pj_obj)

	if has_pj and pj_record[pj_obj] == nil then
		new_pj = spawn_obj(sc, pj_obj, after, playerPed)
		pj_record[pj_obj] = new_pj
	end
end)