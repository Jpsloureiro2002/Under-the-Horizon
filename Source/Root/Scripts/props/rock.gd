extends KinematicBody2D




export (int) var gravity = 800

export (int) var weightmuliplier = 1000

var tempx = 0
var on_top = false
var speed = 0
var velocity = Vector2.ZERO
var slide = false

func _physics_process(delta):
		velocity.y += delta * gravity
		tempx = velocity.x
		tempx = tempx * (0.89)
		if tempx < 0:
			tempx += 1
		if tempx > 0:
			tempx -= 1
			
		if tempx == 0:
			tempx -= 0
		velocity = move_and_slide(velocity, Vector2(0, -1))

		velocity = move_and_slide(Vector2(0,velocity.y), Vector2(0, -1))


