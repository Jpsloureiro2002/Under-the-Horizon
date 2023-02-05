extends Area2D
var g
func _ready():
	g = get_node("/root/Player")
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		get_node("../Control").visible = true
		get_node("../Control/Camera2D").current = true
	pass
