class_name Ball extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var paddle_sound: AudioStreamPlayer = $PaddleSound
@onready var wall_sound: AudioStreamPlayer = $WallSound

var direction: Vector2
var start_pos: Vector2
var prev_pos: Vector2
var height: float
var speed := 800

func _ready():
	height = collision_shape_2d.shape.size.y
	start_pos = position
	prev_pos = global_position
	reset()

func _physics_process(delta: float) -> void:
	position += speed * delta * direction
	prev_pos = global_position

func reset():
	position = start_pos
	prev_pos = start_pos
	var angle = 0
	if (randf() < 0.5): angle += PI
	direction = Vector2.from_angle(angle)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Paddle"):
		paddle_sound.play()
		var dist_from_center = body.global_position.y - global_position.y
		var half_height = body.get_node("CollisionShape2D").shape.size.y / 2 + height / 2
		var reflection_angle: float = dist_from_center / half_height * PI / 4
		# flip for enemy paddle
		if body.global_position.x > prev_pos.x:
			reflection_angle += PI
		else:
			reflection_angle *= -1
		direction = Vector2.from_angle(reflection_angle)
	else:
		wall_sound.play()
		direction.y *= -1
