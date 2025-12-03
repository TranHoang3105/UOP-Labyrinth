# Updated GameManager.gd
extends Node

signal candy_changed(candy_count)

var candy_count: int = 0

func add_candy(amount: int):
	candy_count += amount
	candy_changed.emit(candy_count)
	print("Total Candy: ", candy_count)
	
func remove_candy(amount: int) -> bool:
	if candy_count >= amount:
		candy_count -= amount
		candy_changed.emit(candy_count)
		return true
	return false
