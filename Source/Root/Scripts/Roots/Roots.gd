extends Area2D

func _on_Root_body_entered(body):
	if body.is_in_group("fire"):
		queue_free()
	pass
