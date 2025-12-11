# Updated GameManager.gd
extends Node

signal candy_changed(candy_count)

var candy_count: int = 0

# 添加糖果
func add_candy(amount: int):
	candy_count += amount
	candy_changed.emit(candy_count)
	print("Total Candy: ", candy_count)
	
# 移除糖果
func remove_candy(amount: int) -> bool:
	if candy_count >= amount:
		candy_count -= amount
		candy_changed.emit(candy_count)
		return true
	return false

# ⚡ 新增：重置糖果数
func reset_candy():
	candy_count = 0
	candy_changed.emit(candy_count)
	print("Candy reset to 0")
