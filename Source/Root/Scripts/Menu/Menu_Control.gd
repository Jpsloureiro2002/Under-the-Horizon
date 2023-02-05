extends Control

export var Select = 0

func _ready():
	OS.window_fullscreen = !OS.window_fullscreen
	OS.set_window_size(Vector2(1024,600))
func _process(delta):
	if get_input():
		if Select == 1:
			
			get_tree().quit()
			
		if Select == 2:
			OS.window_fullscreen = !OS.window_fullscreen
			get_tree().change_scene("res://Cenas/Level/Level_0.tscn")
		pass

func get_input():
	if Input.is_action_just_pressed("ui_accept"):
		return true
	else:
		return false
		pass

func _on_Btn_Quit_mouse_entered():
	Select = 1

func _on_Btn_Quit_mouse_exited():
	Select = 0



func _on_Btn_Play_mouse_entered():
	Select = 2
	pass 


func _on_Btn_Play_mouse_exited():
	Select = 0
	pass
