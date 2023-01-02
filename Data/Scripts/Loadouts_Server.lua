local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local LOADOUTS = require(ROOT:GetCustomProperty("Loadouts"))
local SAVE_LOADOUT = ROOT:GetCustomProperty("SaveLoadout")

local players = {}

local function clean_up(player)
	if(players[player] ~= nil and players[player].active ~= nil and Object.IsValid(players[player].active)) then
		players[player].active:Unequip()

		if(Object.IsValid(players[player].active)) then
			players[player].active:Destroy()
		end
	end
end

local function equip_item(player, item_index)
	local key = "Primary"

	if(item_index == 2) then
		key = "Secondary"
	elseif(item_index == 3) then
		key = "Tertiary"
	end

	players[player].active = World.SpawnAsset(players[player].loadout[key], {

		networkContext = NetworkContextType.NETWORKED

	})

	players[player].active:Equip(player)
end

local function save_data(player)
	if(not SAVE_LOADOUT) then
		return
	end

	if(players[player] ~= nil and players[player].loadout_index ~= nil) then
		local data = {}
		
		pcall(function()
			data = Storage.GetPlayerData(player)
		end)

		data.loadout = players[player].loadout_index

		pcall(function()
			Storage.SetPlayerData(player, data)
		end)
	end
end

local function select_loadout(player, index)
	clean_up(player)

	if(LOADOUTS[index] ~= nil and players[player] ~= nil) then
		players[player].loadout_index = index
		players[player].loadout = LOADOUTS[index]
		equip_item(player, 1)
		save_data(player)

		Events.BroadcastToPlayer(player, "Loadouts.Update", players[player].loadout_index)
	end
end

local function equip_default(player)
	for index, row in ipairs(LOADOUTS) do
		if(row.Default) then
			select_loadout(player, index)
			break
		end
	end
end

local function on_player_joined(player)
	local data = {}
	
	players[player] = {}

	if(SAVE_LOADOUT) then
		if(not pcall(function()
			data = Storage.GetPlayerData(player)
		end)) then
			players[player].loadout_index = data.loadout or 1
			players[player].loadout = LOADOUTS[players[player].loadout_index]

			warn("Loadouts: Player Storage is disabled. Please use Game Settings object to enable this service.")
		end
	end

	if(SAVE_LOADOUT and data.loadout) then
		players[player].loadout_index = data.loadout or 1
		players[player].loadout = LOADOUTS[players[player].loadout_index]
	end
end

local function on_player_left(player)
	if(players[player]) then
		clean_up(player)
		players[player] = nil
	end
end

local function ready(player)
	if(players[player] ~= nil and players[player].loadout_index) then
		select_loadout(player, players[player].loadout_index)
	else
		equip_default(player)
	end
end

local function select_item(player, item_idex)
	clean_up(player)
	equip_item(player, item_idex)
	save_data(player)
end

Events.ConnectForPlayer("Loadout.Select", select_loadout)
Events.ConnectForPlayer("Hotbar.Ready", ready)
Events.ConnectForPlayer("Hotbar.Select", select_item)

Game.playerJoinedEvent:Connect(on_player_joined)
Game.playerLeftEvent:Connect(on_player_left)