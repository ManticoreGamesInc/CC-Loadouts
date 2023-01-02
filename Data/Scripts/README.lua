--[[
  _                     _             _
 | |                   | |           | |
 | |     ___   __ _  __| | ___  _   _| |_ ___
 | |    / _ \ / _` |/ _` |/ _ \| | | | __/ __|
 | |___| (_) | (_| | (_| | (_) | |_| | |_\__ \
 |______\___/ \__,_|\__,_|\___/ \__,_|\__|___/
----------------------------------------------

====
NOTE
====

The Loadouts component will give players the ability to switch their loadout in game. It comes with a
simple loadout menu for players to select which loadout they want. It also contains a hotbar to allow
for quick switching of their weapon/equipment.

-----------------------------------------------------------------------------------------------------------------

==========
How to use
==========

Add the Loadouts template to the hierarchy.

There is a data table that comes with the component called Loadouts. This can be modified to load
the weapons/equipment you want players to use. You can easily add more rows to the data table for
more loadouts for players to select from.

There are also several custom properties that can be changed on the root of the template.

Note: Player Storage should be enabled if you want to save the last loadout selected for the player.

- NormalColor
	The normal color of the slot loadout when not hovered over it.

- SelectedColor
	The selected color of a loadout slot.

- SaveLoadout
	If enabled, when a player selects a loadout, it will be saved and loaded for their next session.

- EnableHotbar
	If enabled, the player can use the hotbar to switch between their equipment using the scroll wheel.

- SlotActiveColor
	The color of the active slot in the hotbar.

- SlotNormalColor
	The normal color of a slot in the hotbar.

--]]
