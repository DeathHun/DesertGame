extends CharacterBody2D

var speed = -60

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right =  false

func _ready():
	$AnimationPlayer.play("Run")

func _physics_process(delta):
	
	apply_grav(delta)
	
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
	
	movement()
	
	move_and_slide()


func movement():
	velocity.x = speed

func apply_grav(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
	
