class_name InteractRaycaster extends RayCast3D

@export_group("Default values; Do not touch")
@export var player_character : PlayerController
@export var crosshair_reticle : TextureRect
@export var crosshair_box : TextureRect
@export var dialogue_handler : DialogueHandler


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if currently_colliding and player_character.player_state == player_character.PLAYER_STATE.WALKING:
			_interact()


func _physics_process(_delta: float) -> void:
	if player_character.player_state == player_character.PLAYER_STATE.WALKING:
		_handle_crosshair()

	## Slowly look at the thing we are interacting with
	else:
		## A bit fucked up, but oh well
		var new_angle_y : Transform3D = player_character.transform.looking_at(interacted_object.global_position)
		player_character.transform = player_character.transform.interpolate_with(new_angle_y, 0.1)
		player_character.rotation.x = 0.0
		player_character.rotation.z = 0.0

		## TODO
		## Trying a hack that fucks up miserably
		# var new_angle_x : Transform3D = player_character.head.transform.looking_at(
		# 	Vector3(
		# 		interacted_object.global_position.x,
		# 		interacted_object.global_position.y,
		# 		interacted_object.global_position.z
		# 	)
		# )

		var new_angle_x : Transform3D = player_character.head.transform.looking_at(interacted_object.global_position)

		player_character.head.transform = player_character.head.transform.interpolate_with(new_angle_x, 0.1)
		player_character.head.rotation.y = 0.0
		player_character.head.rotation.z = 0.0
	

var currently_colliding : bool = false
func _handle_crosshair() -> void:
	## Almost guaranteed to return only 
	## nodes with Interactable, since we are using 
	## Collision Masks
	currently_colliding = is_colliding()
	if currently_colliding:
		crosshair_reticle.visible = false
		crosshair_box.visible = true
	else:
		crosshair_reticle.visible = true
		crosshair_box.visible = false


var interacted_object : Node3D
func _interact() -> void:
	var base_node : Node3D = get_collider()

	for child in base_node.get_children():
		if child is Interactable:
			## It's interactable
			player_character._set_player_state(1) ## Interacting

			## TODO
			## Focus target sometimes still not accurate
			## Might wanna look into it more
			interacted_object = child.focus_target

			## Activate the interact
			child.player_node = player_character
			child._start_interact()

			break


func _interaction_end() -> void:
	interacted_object = null
