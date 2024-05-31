extends Node2D

func _ready():
	$AnimationPlayer.play("Idle")

func _on_area_2d_area_entered(area):
	GameManager.gain_coin(1)
	print(area)
	queue_free()
