extends KinematicBody2D

var velocitys = Vector2()
export var speed = 600

func _ready():
	$Timer.start()
func _physics_process(delta):
	
	var collision_info = move_and_collide(velocitys.normalized() * delta * speed)
	if collision_info:
		print(collision_info)
		queue_free()
	



func _on_Timer_timeout():
	queue_free()
	pass
