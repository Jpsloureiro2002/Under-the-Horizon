extends Area2D
var g;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	g = get_node("/root/Player")
	if !g.Fire:
		global_position = get_node("../power_fire").global_position

func _on_PowerUpDashArea2D_body_entered(body):
	if body.is_in_group("Player"):
		$AudioStreamPlayer2D.stream = preload("res://assets/Sounds/Stingers/GainColorFx.wav")
		g.Fire = true;
		queue_free();
