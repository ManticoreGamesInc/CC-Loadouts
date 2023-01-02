local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local WRAPPER = script:GetCustomProperty("Wrapper"):WaitForObject()
local LOADOUTS_LIST = script:GetCustomProperty("LoadoutItems"):WaitForObject()
local LOADOUT_ITEM = ROOT:GetCustomProperty("LoadoutItem")
local LOADOUTS = require(ROOT:GetCustomProperty("Loadouts"))

local SELECTED_COLOR = ROOT:GetCustomProperty("SelectedColor")
local NORMAL_COLOR = ROOT:GetCustomProperty("NormalColor")

local offset_y = 4
local is_open = false
local total_height = 0
local loadouts = {}
local n = -1
local selected = -1

local function on_loadout_selected(button, index, broadcast)
	if(selected == index) then
		return
	end

	if(loadouts[selected] ~= nil) then
		loadouts[selected].item:SetButtonColor(NORMAL_COLOR)
		loadouts[selected].star.visibility = Visibility.FORCE_OFF
	end

	selected = index
	
	loadouts[selected].item:SetButtonColor(SELECTED_COLOR)
	loadouts[selected].star.visibility = Visibility.INHERIT

	Events.Broadcast("Hotbar.Update", selected)

	if(broadcast) then
		Events.BroadcastToServer("Loadout.Select", selected)
	end
end

local function on_action_pressed(player, action)
	if(action == "Open/Close") then
		if(is_open) then
			WRAPPER.visibility = Visibility.FORCE_OFF
			is_open = false
			UI.SetCanCursorInteractWithUI(false)
			UI.SetCursorVisible(false)
		else
			WRAPPER.visibility = Visibility.FORCE_ON
			is_open = true
			UI.SetCanCursorInteractWithUI(true)
			UI.SetCursorVisible(true)
		end
	end
end

local function update(index, broadcast)
	on_loadout_selected(nil, index, broadcast)
end

for index, loadout in ipairs(LOADOUTS) do
	local item = World.SpawnAsset(LOADOUT_ITEM, { parent = LOADOUTS_LIST })
	local name = item:FindChildByName("Name")
	local star = item:FindChildByName("Star")

	item.pressedEvent:Connect(on_loadout_selected, index, true)
	name.text = loadout.Name

	loadouts[#loadouts + 1] = {

		index = index,
		loadout = loadout,
		item = item,
		name = name,
		star = star

	}

	item.y = offset_y
	offset_y = offset_y + item.height
	total_height = item.y + item.height
end

WRAPPER.height = total_height + 56

Input.actionPressedEvent:Connect(on_action_pressed)
Events.Connect("Loadouts.Update", update)