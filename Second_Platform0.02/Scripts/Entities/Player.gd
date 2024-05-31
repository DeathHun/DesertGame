extends CharacterBody2D
class_name Player

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite :Sprite2D = $Sprite2D
@onready var coyote_timer = $CoyoteTimer

@export var attacking = false
@export var speed  = 200.0
@export var jump_velocity = -400.0
@export var friction = 3000
@export var air_resistance = 3000
@export var Coyote_Time : float = 0.2

var has_timer_start : bool = false
var air_jump : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_jump : bool = false
var wall_normal : Vector2
var jump_available : bool = true

func _ready():
	GameManager.player = self

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()


func _physics_process(delta):
	
	add_gravity(delta)
	jump_action()
	movement(delta)
	handle_wall_jump()
	update_animation()
	
	move_and_slide()
	
	if position.y > 900:
		death()
	

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += 1.25 * gravity * delta

func movement(delta):
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = speed*direction

	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, delta*air_resistance)

		else:
			velocity.x = move_toward(velocity.x, 0, delta*friction)

func jump_action():
	if is_on_floor():
		air_jump = false
		jump_available = true
		coyote_timer.stop()
	
	if not is_on_floor():
		if jump_available:
			if coyote_timer.is_stopped():
				air_jump = true
				coyote_timer.start(Coyote_Time)
			

	
	if Input.is_action_just_pressed("jump") and jump_available:
			velocity.y = jump_velocity
			air_jump = true
			jump_available = false
	
	elif Input.is_action_just_pressed("jump") and air_jump == true:
		velocity.y = jump_velocity
		air_jump = false

func Coyote_Timeout():
	jump_available = false

func handle_wall_jump():
	if not is_on_wall(): return
	if is_on_wall_only() and Input.is_action_just_pressed("right"):
		wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * speed 
		velocity.y = jump_velocity

	if is_on_wall_only() and Input.is_action_just_pressed("left"):
		wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * speed 
		velocity.y = jump_velocity

func update_animation():
	if !attacking:
		if Input.is_action_just_pressed("left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
			$Area2D.scale.x = abs($Area2D.scale.x) * -1
			$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		if Input.is_action_just_pressed("right"):
			sprite.scale.x = abs(sprite.scale.x)
			$Area2D.scale.x = abs($Area2D.scale.x)
			$AttackArea.scale.x = abs($AttackArea.scale.x) 
			
		if velocity.x != 0 and is_on_floor():
			animation.play("Run")
		if velocity.x == 0 and is_on_floor():
			animation.play("Idle")
		if velocity.y < 0 and not is_on_floor():
			animation.play("Jump")
		if velocity.y > 0 and not is_on_floor():
			animation.play("Fall")

func crouch():
	pass

func death():
	GameManager.respawn_player()

func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	attacking = true
	animation.play("Attack")
