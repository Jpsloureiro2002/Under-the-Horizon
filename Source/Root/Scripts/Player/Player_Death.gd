extends Area2D

var g
func _ready():
	g = get_node("/root/Player")


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		g.VIDAS -= 1
		
		get_tree().reload_current_scene()
	pass 
