extends CharacterBody2D

@export var speed: float = 300

var original_position: Vector2

func _ready():
	original_position = position
	
func reset():
	position = original_position

func _process(_delta: float) -> void:
	var dir = 0
	if Input.is_action_pressed("enemy_down"):
		dir += 1
	if Input.is_action_pressed("enemy_up"):
		dir -= 1
	velocity.y = dir * speed
	move_and_slide()
