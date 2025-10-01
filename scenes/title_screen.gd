extends CanvasLayer

@onready var instruction: Label = $Instruction
const GAME = preload("res://scenes/game.tscn")

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/game.tscn")
		pass

func _on_flash_timer_timeout() -> void:
	instruction.visible = not instruction.visible
