@tool
class_name Interactable extends Node

## For now, this is just to make it so that 
## player can interact with something, and then
## a dialogue will play
@export var rotate_to_player : bool = false

## Player will focus on this, just a Node3D
@export var focus_target : Node3D :
	set(new_fc):
		focus_target = new_fc
		update_configuration_warnings()


@export var start_node : InteractableAction:
	set(new_sn):
		start_node = new_sn
		update_configuration_warnings()


var player_node : PlayerController
var parent_node : Node3D

func _ready() -> void:
	if !Engine.is_editor_hint():
		if !focus_target:
			printerr("You forgot to set focus_target for " + get_parent().name)

		parent_node = get_parent()

		## We use Layer 3 for Interactable collision mask
		## Change as you need
		if parent_node is CharacterBody3D or parent_node is StaticBody3D: 
			parent_node.set_collision_layer_value(3, true)


# func _physics_process(delta: float) -> void:
# 	if !Engine.is_editor_hint():
# 		## Turn slowly towards the player
# 		if is_being_interacted:
# 			pass


func _start_interact() -> void:
	if start_node:
		start_node._start_action()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	var found_action : bool = false
	for child in get_children():
		if child is InteractableAction:
			found_action = true
			break

	if !focus_target:
		warnings.append("Warning: Please add a Node3D and set it as FocusTarget")
			
	if !found_action:
		warnings.append("Warning: Please add InteractableAction node as a child")

	if !start_node:
		warnings.append("Warning: Please add an InteractableAction as a start_node!")

	return warnings
