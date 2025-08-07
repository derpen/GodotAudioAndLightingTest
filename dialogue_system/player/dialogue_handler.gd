class_name DialogueHandler extends Control

@export var character_cooldown : float = 0.01 ## How long before showing the next character
@export var sentence_cooldown : float = 1.0 ## How long before showing the next sentence

@export_group("Default values; Do not touch")
@export var dialogue_label : RichTextLabel
@export var choice_container : Control
@export var button_container : HBoxContainer
@export var player_character : PlayerController

var current_interact_node : InteractableAction

func _dialogue_play(dialogues: Array[String]) -> void:
	for sentence in dialogues:
		dialogue_label.text = ""
		await _show_characters(sentence)
		await get_tree().create_timer(sentence_cooldown).timeout

	dialogue_label.text = ""
	current_interact_node._start_next_action()


func _show_characters(sentence: String) -> void:
	for characters in sentence:
		dialogue_label.text += characters
		await get_tree().create_timer(character_cooldown).timeout


var new_choices : Dictionary
var choices_button : Array[Button]
func _choices_show(choices_values: Dictionary) -> void:
	## Clear all previous buttons first
	if !choices_button.is_empty():
		for old_choice in choices_button:
			old_choice.queue_free()

		choices_button.clear()

	player_character._change_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	choice_container.visible = true
	new_choices = choices_values

	## Programatically spawn button and handle signal properly
	for choice in choices_values.keys():
		var new_button : Button = Button.new()
		new_button.text = choice
		new_button.pressed.connect(func(): _choices_pick(choices_values[choice]))

		button_container.add_child(new_button)
		choices_button.append(new_button)


func _choices_pick(which_choice: NodePath) -> void:
	player_character._change_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_interact_node._action_handle_choice_picked(which_choice)
	choice_container.visible = false
