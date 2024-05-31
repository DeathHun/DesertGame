extends Node2D
class_name Checkpoint


@export var spawnpoint : bool = false

var activated : bool = false

func _ready():
	if spawnpoint:
		activate()
	#If you wanna set a specific checkpoint at the start of the game
	#%Checkpoint.spawnpoint = true
	#activate()



func activate():
	GameManager.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("Activated")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated :
		activate()
