extends Area2D
var g
func _ready():
	g = get_node("/root/Player")
	pass

func _on_Inicio_body_entered(body):
	if body.is_in_group("Player"):
		g.Last_Enter = 2
		get_tree().change_scene("res://Cenas/Level/level_5.tscn")
		


func _on_Fim_body_entered(body):
	if body.is_in_group("Player"):
		g.Last_Enter = 1
		get_tree().change_scene("res://Cenas/Level/Level_7.tscn")
	pass


func _on_Fim2_body_entered(body):
	if body.is_in_group("Player"):
		g.Last_Enter = 1
		get_tree().change_scene("res://Cenas/Level/Level_8.tscn")
	pass
