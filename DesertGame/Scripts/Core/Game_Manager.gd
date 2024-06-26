extends Node

signal gained_coins(int)

var coins : int = 0
var current_checkpoint : Checkpoint
var player : Player


func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_coin(coins_gained : int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)

