extends KinematicBody2D

export (int) var Walk_speed = 200
export (int) var jump_speed = -500
export (int) var gravity_Max = 800
export (int) var Run_Speed = 300

onready var Sound = get_node("AudioStreamPlayer2D")
export var Bullet = preload("res://Cenas/Prefabs/Stone.tscn")
export var canShoot = true

export (int) var Grav_Wall_Modifire = 600
export (int) var Craw_Speed = 100
export (bool) var is_crowling = false
export (bool) var can_dash = false

export (int) var Max_jumps = 1
export (int) var number_of_dash = 1
export (int) var force = 10000
#player global Var (g)

var Jumped = false
var g
var dash_sprite
var last_jumped 
var play_one = false
var charj = true
var can_jump = true
var cand_slide = true
var speed = 0
var velocity = Vector2()
var jumping = false
var jumps = 0
var temp_dash = 0
var pushing = false
var pushing_speed = 0
var bis_on_wall_left = false
var bis_on_wall_right = false
var is_on_w = false
var gravity
var orient = 0
onready var player = get_node("../AnimationPlayer")




func _ready():
	
	dash_sprite = true
	last_jumped = 0
	speed = Walk_speed
	jumps = Max_jumps
	temp_dash = 500
	gravity = gravity_Max
	g = get_node("/root/Player")
	var spawn = get_node("../../SpawnPoint"+ str(g.Last_Enter))
	print (spawn.global_position)
	
	global_position = spawn.global_position
	print (position)
	#Get the Player global var
	player.play("Idle")



func get_input():
	velocity.x = 0
	
	if Input.is_action_just_pressed('ui_select') and jumps > 0 and !is_on_wall():
		jumping = true
		jumps -= 1
		velocity.y = jump_speed
		player.stop()
		player.play("Jump")
	if Input.is_action_pressed("crawl") and is_on_floor():
		is_crowling = true
		speed = Craw_Speed
		$Sprite.scale.y = 3.5
	else:
		is_crowling = false
		speed = Walk_speed
		$Sprite.scale.y = 4
	
	if Input.is_action_pressed("ui_left"):
		if pushing:
			speed = pushing_speed
		velocity.x -= speed
		$Sprite.flip_h = true
		orient = 1
		
	elif Input.is_action_pressed("ui_right"):
		if pushing:
			speed = pushing_speed
		velocity.x += speed
		$Sprite.flip_h = false
		orient = 0
		
	if Input.is_action_pressed("ui_right") and Input.is_action_just_pressed("Sprint_And_Dash") and g.Dash:
		if can_dash and number_of_dash > 0:
			number_of_dash -= 1;
			velocity.x += force;
			dash_sprite = false

			Sound.stream = preload("res://assets/Sounds/Player/Actions/dash.wav")
			if !Sound.playing:
				Sound.play()
			$dash_cooldown.start()

	elif Input.is_action_pressed("ui_left") and Input.is_action_just_pressed("Sprint_And_Dash") and g.Dash:
		if can_dash and number_of_dash > 0:
			number_of_dash -= 1;
			velocity.x -= force;
			dash_sprite = false
			player.stop()
			player.play("Dash")
			$dash_cooldown.start()
func _process(delta):
	update()
	var Max_angle_right = -31.6
	var Max_angle_left = +206.5
	var def = -90
	var start_dir = 0
	var start_left = 180
	
	if Input.is_action_just_pressed("player_shoot"):
		if canShoot:
			if charj:
				player.stop()
				player.play("Arremcar")
				shoot()
				$Hand/Timer.start()
				charj = false
				
	$Hand.look_at(get_global_mouse_position())
func _physics_process(delta):
	if is_on_floor():
		jumps = Max_jumps
		play_one = false
	get_input()
	if jumping and is_on_floor():
		jumping = false
	#Dentro do is_on_floor que já existe colocar assim
	if is_on_floor():
		bis_on_wall_left = true
		bis_on_wall_right = true
		is_on_w = true
		jumps = Max_jumps

#Codigo do wall jump
	if is_on_wall() and cand_slide:
		velocity.y = delta * Grav_Wall_Modifire;
		jumps = 1
	if is_on_wall() and Input.is_action_pressed("ui_right") and cand_slide:
		if bis_on_wall_right == true:
			bis_on_wall_right = false
			bis_on_wall_left = true
			if last_jumped == 1:
				jumps = -1
				velocity.y = delta * Grav_Wall_Modifire;
			else:
				if can_jump:
					jumps = 1;
					velocity.y = delta * Grav_Wall_Modifire
					gravity = 0
					$Jump_Colldown.start()
			last_jumped = 1
	
	elif is_on_wall() and Input.is_action_pressed("ui_left") and cand_slide:
		if bis_on_wall_left == true:
			bis_on_wall_left = false
			bis_on_wall_right = true
			if last_jumped == 2:
				jumps = -1
				velocity.y = delta * Grav_Wall_Modifire;
			else:
				if can_jump:
					jumps = 1
					velocity.y = delta * Grav_Wall_Modifire;
			last_jumped = 2
			

			gravity = 0
			$Jump_Colldown.start()
			print(jumps)
		
	elif is_on_wall() and cand_slide:
		if is_on_w == true:
			is_on_w = false
			velocity.y = 0;
		velocity.y = delta * gravity
		

	else:
		velocity.y += delta * gravity
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Pushable") and is_on_floor():
			var col = collision.collider
			col.velocity.x = velocity.x
			col.velocity.y -= 1
			if velocity.x < 0:
				pushing_speed = Walk_speed - col.weightmuliplier
				print(speed - collision.collider.weightmuliplier)
			
			if velocity.x > 0:
				pushing_speed = Walk_speed - col.weightmuliplier
				pass
				
	if is_crowling:
		$Normal.disabled = true
		$Crawl.disabled = false
	else:
		$Normal.disabled = false
		$Crawl.disabled = true
	velocity = move_and_slide(velocity, Vector2(0, -1))
	#print(cand_slide)


func _on_Grabable_area_body_entered(body):

	if body.is_in_group("Pushable") and is_on_floor():

		var colision = body
		
		colision.velocity.x = velocity.x
		if velocity.x < 0:
			pushing_speed = Walk_speed - body.weightmuliplier
			pushing = true

		if velocity.x > 0:
			pushing_speed = Walk_speed - body.weightmuliplier
			pushing = true
	if body.is_in_group("Pushable"):
		cand_slide = false
	if body.is_in_group("Block"):
		cand_slide = false
	if body.is_in_group("Top"):
		cand_slide = true
		speed = Walk_speed
		
func update():
	powers()
	#$Camera2D/Vida.text = "Vida: " + str(g.MAX_VIDA) + "/" + str(g.VIDA)
	if !player.current_animation == "Arremcar":
		if velocity.x != 0 and is_on_floor() and !is_crowling and !pushing:
			player.play("Walk")
		elif is_crowling and !pushing:
			player.play("Agachar")
		elif !is_crowling and pushing:
			player.play("WalkPush")
		else:
			if player.current_animation != "Jump":
				player.play("Idle")
	
func _on_Grabable_area_body_exited(body):
	if body.is_in_group("Pushable"):
		speed = Walk_speed
		pushing = false
		cand_slide = true
	if body.is_in_group("Block"):
		cand_slide = true
	pass # Replace with function body.
	


func _on_Jump_Colldown_timeout():
	gravity = gravity_Max
	
#Player Shoot

func shoot():
	if g.Fire and g.FIRE_BALL > 0:
		var shoot = Bullet.instance()
		get_parent().add_child(shoot)
		shoot.global_position = get_node("Hand/Position2D").global_position
		
		shoot.velocitys = get_global_mouse_position() - shoot.global_position
		g.FIRE_BALL -= 1


func _on_Timer_timeout():
	charj = true
	pass 


func _on_Unshuteble_area_mouse_entered():
	canShoot = false
	pass

func powers():
	if g.Dash:
		$Camera2D/Dash.visible = true
		if dash_sprite:
			get_node("../Dash").play("Dash")
		else:
			get_node("../Dash").play("Dash_off")
	else:
		$Camera2D/Dash.visible = false
	if g.Fire:
		$Camera2D/Fire.visible = true
		if charj:
			get_node("../Fire").play("Fire")
		else:
			get_node("../Fire").play("Fire_off")
	else:
		$Camera2D/Fire.visible = false
		
	if g.Extra:
		$Camera2D/Life.visible = true
	else:
		$Camera2D/Life.visible = false
func _on_Unshuteble_area_mouse_exited():
	canShoot = true
	pass


func _on_dash_cooldown_timeout():
	dash_sprite = true
	number_of_dash = 1
	pass 
