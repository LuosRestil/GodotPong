extends Node2D

@onready var player_score_label: Label = $UI/PlayerScore
@onready var enemy_score_label: Label = $UI/EnemyScore
@onready var ball: Ball = $Ball
@onready var player: CharacterBody2D = $Player
@onready var enemy: CharacterBody2D = $Enemy
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var countdown_label: Label = $UI/Countdown
@onready var flash_timer: Timer = $FlashTimer
@onready var play_again_timer: Timer = $PlayAgainTimer
@onready var goal_sound: AudioStreamPlayer = $GoalSound
@onready var countdown_low_sound: AudioStreamPlayer = $CountdownLowSound
@onready var countdown_high_sound: AudioStreamPlayer = $CountdownHighSound
@onready var replay_modal: Panel = $UI/ReplayModal
@onready var winner_text: Label = $UI/ReplayModal/WinnerText
@onready var play_again_text: Label = $UI/ReplayModal/PlayAgainText

var player_score := 0:
	set(score):
		player_score = score
		player_score_label.text = str(score)
var enemy_score := 0:
	set(score):
		enemy_score = score
		enemy_score_label.text = str(score)
		
var play_again_enabled = false
var play_to := 7

func _ready():
	countdown()
	
func _process(_delta: float) -> void:
	if play_again_enabled and Input.is_anything_pressed():
		play_again_enabled = false
		flash_timer.stop()
		play_again_text.visible = false
		winner_text.visible = false
		replay_modal.visible = false
		player_score = 0
		enemy_score = 0
		reset()
		countdown()
	
func countdown():
	disable_movers()
	ball.visible = false
	var tween = create_tween()
	countdown_label.text = "3"
	tween.tween_property(countdown_label.label_settings, "font_size", 256, 0.3).from(1)
	await tween.finished
	countdown_low_sound.play()
	await get_tree().create_timer(0.7).timeout
	tween = create_tween()
	countdown_label.text = "2"
	tween.tween_property(countdown_label.label_settings, "font_size", 256, 0.3).from(1)
	await tween.finished
	countdown_low_sound.play()
	await get_tree().create_timer(0.7).timeout
	tween = create_tween()
	countdown_label.text = "1"
	tween.tween_property(countdown_label.label_settings, "font_size", 256, 0.3).from(1)
	await tween.finished
	countdown_low_sound.play()
	await get_tree().create_timer(0.7).timeout
	tween = create_tween()
	countdown_label.text = "GO!"
	tween.tween_property(countdown_label.label_settings, "font_size", 256, 0.3).from(1)
	await tween.finished
	countdown_high_sound.play()
	await get_tree().create_timer(0.7).timeout
	countdown_label.text = ""
	enable_movers()
	ball.visible = true
		
func disable_movers():
	var movers = get_tree().get_nodes_in_group("Mover")
	for mover in movers:
		mover.set_process(false)
		mover.set_physics_process(false)
		
func enable_movers():
	var movers = get_tree().get_nodes_in_group("Mover")
	for mover in movers:
		mover.set_process(true)
		mover.set_physics_process(true)
		
func reset():
	ball.reset()
	player.reset()
	enemy.reset()
	
func end(player_number: String):
	disable_movers()
	reset()
	winner_text.text = "Player " + player_number + " wins!"
	replay_modal.size = Vector2(1, 1)
	replay_modal.visible = true
	var tween = create_tween()
	tween.tween_property(replay_modal, "size", Vector2(600, 600), 0.3)
	await tween.finished
	winner_text.visible = true
	play_again_timer.start()

func _on_left_area_entered(_area: Area2D) -> void:
	goal_sound.play()
	enemy_score += 1
	if enemy_score == play_to:
		end("2")
	else:
		reset()
		countdown()

func _on_right_area_entered(_area: Area2D) -> void:
	goal_sound.play()
	player_score += 1
	if player_score == play_to:
		end("1")
	else:
		reset()
		countdown()

func _on_flash_timer_timeout() -> void:
	play_again_text.visible = not play_again_text.visible

func _on_play_again_timer_timeout() -> void:
	play_again_enabled = true
	play_again_text.visible = true
	flash_timer.start()
