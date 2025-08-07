class_name ItemNotification extends Control

@export var item_received_label : String = "You have acquired "
@export var item_removed_label : String = " removed"
@export var notification_duration : float = 5.0

@export_group("Default values; Do not touch")
@export var notification_label : RichTextLabel
@export var notification_timer : Timer

func _show_item_received(item_received: String, duration: float = notification_duration) -> void:
	notification_label.text = item_received_label + item_received
	_timer_start(duration)


func _show_item_removed(item_removed: String, duration: float = notification_duration) -> void:
	notification_label.text = item_received_label + item_removed
	_timer_start(duration)


func _timer_start(duration: float) -> void:
	notification_timer.start(duration)


func _hide_notification() -> void:
	notification_label.text = ""

	## Should probably make it not visible too
	## But we'll see if we can get away with it


func _on_timer_timeout() -> void:
	_hide_notification()
