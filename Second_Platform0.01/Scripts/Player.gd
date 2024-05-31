extends CharacterBody2D

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite :Sprite2D = $Sprite2D


@export var speed  = 280.0
@export var jump_velocity = -400.0
@export var friction = 800
@export var air_resistance = 300

var air_jump : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	add_gravity(delta)
	jump_action()
	movement(delta)
	update_animation()
	
	move_and_slide()

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, delta*air_resistance)
		else:
			velocity.x = move_toward(velocity.x, 0, delta*friction)
func jump_action():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		air_jump = true
	elif Input.is_action_just_pressed("jump") and air_jump == true:
		velocity.y = jump_velocity
		air_jump = false
func update_animation():
	if Input.is_action_just_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x)
	if velocity.x != 0 and is_on_floor():
		animation.play("Run")
	if velocity.x == 0 and is_on_floor():
		animation.play("Idle")
	if velocity.y < 0 and not is_on_floor():
		animation.play("Jump")
	if velocity.y > 0 and not is_on_floor():
		animation.play("Fall")

