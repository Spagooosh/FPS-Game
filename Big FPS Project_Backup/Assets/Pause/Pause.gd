extends Control


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
