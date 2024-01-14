extends RigidBody2D
class_name BallBody

var initial_ball_speed : float = 500
var speed_reduction : float = 50
var velocity : Vector2 = Vector2.ZERO

var initial_player_x : float = 0
var initial_player_y : float = 0

var collision_count : int = 0

var initial_position : Vector2

func _ready():
	visible = true
	initial_position = position
	DoorGlobal.connect("reset_ball_position", reset_to_initial_position)
	Global.connect("reset_ball_position", reset_to_initial_position)
	print(Global.balls)
	Global.max_ball_count += 1
	Global.set_ball_reference(self)


func _process(delta):
	if not is_player_valid():
		velocity = Vector2.ZERO
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= 1
		velocity.y *= 1
		print(velocity)
		
		if not $Bounce.is_playing():
			$Bounce.play()
		
		var current_speed = velocity.length()
		
		if current_speed > initial_ball_speed:
			velocity = velocity.normalized() * initial_ball_speed
			if current_speed > initial_ball_speed:
				velocity = velocity.normalized() * initial_ball_speed



func _integrate_forces(state):
	state.linear_velocity = velocity


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player") and not Global.mana_count == 0:
		$BallPickUp.play()
		Global.decrease_player_mana()
		print("Player has_Ball: ", Global.has_ball())
		reset_to_initial_position()

func reset_to_initial_position():
	position = initial_position
	velocity = Vector2.ZERO
	visible = true
	Global.add_ball(self)
	print(Global.max_ball_count)

func _on_enemy_hit_area_entered(area):
	if area.is_in_group("Enemy"):
		print("Enemy Hit")
		$EnemyHit2.play()

func is_player_valid() -> bool:
	return Global.get_player_reference() != null

func get_initial_position() -> Vector2:
	return initial_position
