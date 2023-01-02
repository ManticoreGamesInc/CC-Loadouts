local ROOT = script:GetCustomProperty("Root"):WaitForObject()
local HOTBAR = script:GetCustomProperty("Hotbar"):WaitForObject()
local SLOT_NORMAL_COLOR = ROOT:GetCustomProperty("SlotNormalColor")
local SLOT_ACTIVE_COLOR = ROOT:GetCustomProperty("SlotActiveColor")
local LOADOUTS = require(ROOT:GetCustomProperty("Loadouts"))
local ENABLE_HOTBAR = ROOT:GetCustomProperty("EnableHotbar")

if(ENABLE_HOTBAR) then
	HOTBAR.visibility = Visibility.INHERIT
end

local slots = {

	{
		
		icon = script:GetCustomProperty("PrimaryIcon"):WaitForObject(),
		border = script:GetCustomProperty("PrimaryBorder"):WaitForObject(),
		key = script:GetCustomProperty("PrimaryKey"):WaitForObject()

	},

	{
		
		icon = script:GetCustomProperty("SecondaryIcon"):WaitForObject(),
		border = script:GetCustomProperty("SecondaryBorder"):WaitForObject(),
		key = script:GetCustomProperty("SecondaryKey"):WaitForObject()

	},

	{
		
		icon = script:GetCustomProperty("TertiaryIcon"):WaitForObject(),
		border = script:GetCustomProperty("TertiaryBorder"):WaitForObject(),
		key = script:GetCustomProperty("TertiaryKey"):WaitForObject()

	}

}

local active_slot_index = -1
local active_loadout_index = 1

local function select_slot(slot_index, broadcast)
	if(active_slot_index ~= slot_index and slot_index ~= -1) then
		if(active_slot_index > -1 and slots[active_slot_index] ~= nil) then
			slots[active_slot_index].border:SetColor(SLOT_NORMAL_COLOR)
			slots[active_slot_index].key.parent:FindChildByName("Border"):SetColor(SLOT_NORMAL_COLOR)
		end

		if(slots[slot_index] ~= nil) then
			slots[slot_index].border:SetColor(SLOT_ACTIVE_COLOR)
			slots[slot_index].key.parent:FindChildByName("Border"):SetColor(SLOT_ACTIVE_COLOR)
			active_slot_index = slot_index

			if(broadcast) then
				Events.BroadcastToServer("Hotbar.Select", slot_index)
			end
		end
	end
end

local function update(selected, item_index)
	active_loadout_index = selected

	if(LOADOUTS[active_loadout_index] == nil) then
		return
	end

	if(LOADOUTS[active_loadout_index].PrimaryIcon) then
		slots[1].icon:SetImage(LOADOUTS[active_loadout_index].PrimaryIcon)
		slots[1].icon.visibility = Visibility.INHERIT
	end

	if(LOADOUTS[active_loadout_index].SecondaryIcon) then
		slots[2].icon:SetImage(LOADOUTS[active_loadout_index].SecondaryIcon)
		slots[2].icon.visibility = Visibility.INHERIT
	end

	if(LOADOUTS[active_loadout_index].TertiaryIcon) then
		slots[3].icon:SetImage(LOADOUTS[active_loadout_index].TertiaryIcon)
		slots[3].icon.visibility = Visibility.INHERIT
	end

	select_slot(1, false)
end

local function on_action_pressed(player, action, value)
	if(action == "Hotbar Scroll" and ENABLE_HOTBAR) then
		local slot_index = active_slot_index

		slot_index = slot_index + value

		if(slot_index == 0) then
			slot_index = 3
		elseif(slot_index == 4) then
			slot_index = 1
		end

		select_slot(slot_index, true)
	elseif(action == "Slot 1") then
		select_slot(1, true)
	elseif(action == "Slot 2") then
		select_slot(2, true)
	elseif(action == "Slot 3") then
		select_slot(3, true)
	end
end

local function set_action_labels()
	for i, slot in ipairs(slots) do
		local action = Input.GetActionInputLabel("Slot " .. tostring(i))

		if(action ~= nil) then
			slot.key.text = action
		end
	end
end

Events.Connect("Hotbar.Update", update)

set_action_labels()

Input.actionPressedEvent:Connect(on_action_pressed)

Task.Wait()
Events.BroadcastToServer("Hotbar.Ready")