local myTab = gui.get_tab("GUI_TAB_VEHICLE")
local appear = joaat("freight")
-- local base = joaat("phantom2")
-- local offset = vec3:new(0.2, -1.25, 0.4)
local base = joaat("brickade2")
local offset = vec3:new(0, -3.75, 0.15)
local rot = vec3:new(0, 0, 0)
local invisible_base = false


function spawn_vehicle(script, playerPed, hash)
	STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do script:yield() end
    local pj_coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0, 10, 1)
	local isNetwork = true
	local bScriptHostVeh = true
	local vehicle = VEHICLE.CREATE_VEHICLE(
		hash, pj_coords.x, pj_coords.y, pj_coords.z, 0, isNetwork, bScriptHostVeh, true)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
	if hash == joaat("brickade2") then
		-- adds heavy scoop
		VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
		VEHICLE.SET_VEHICLE_MOD(vehicle, 42, 3, false)
	end
	VEHICLE.SET_VEHICLE_STRONG(vehicle, true)
	return vehicle
end

function spawn_train(script, playerPed, hash, entity)
	local frieght = spawn_vehicle(script, playerPed, hash)

	ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(friegh, entity, false)
	ENTITY.SET_ENTITY_COLLISION(frieght, false, false)
	ENTITY.FREEZE_ENTITY_POSITION(frieght, true)
	-- ENTITY.ENABLE_ENTITY_BULLET_COLLISION(frieght) -- necessary?
	ENTITY.SET_ALLOW_MIGRATE_TO_SPECTATOR(frieght, 1) -- necessary?
	if invisible_base then
		ENTITY.SET_ENTITY_VISIBLE(entity, false, false)
		ENTITY.SET_ENTITY_ALPHA(entity, 0, false)
	end

	ENTITY.ATTACH_ENTITY_TO_ENTITY(frieght, entity, 0, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)
	ENTITY.PROCESS_ENTITY_ATTACHMENTS(entity) -- necessary?

	ENTITY.SET_ENTITY_LOD_DIST(frieght, ENTITY.GET_ENTITY_LOD_DIST(entity))	
	VEHICLE.SET_VEHICLE_GRAVITY(frieght, false)

	local unk = NETWORK.VEH_TO_NET(frieght) -- necessary?
	return frieght
end


local clicked_freight = false
myTab:add_imgui(function()
	clicked_freight = ImGui.Button("Get Freight")
end)
script.register_looped("freight loop", function (script)	
	if clicked_freight then
		local playerPed = PLAYER.PLAYER_PED_ID()
		-- local basecar = PED.GET_VEHICLE_PED_IS_IN(playerPed)
		local basecar = spawn_vehicle(script, playerPed, base)
		VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY(basecar)
		script:sleep(200)
		if basecar ~= nil and ENTITY.DOES_ENTITY_EXIST(basecar) then
			local train = spawn_train(script, playerPed, appear, basecar)
			ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(train)
			ENTITY.SET_ENTITY_AS_NO_LONGER_NEEDED(basecar)
		end
	end
end)
