extends RigidBody2D
class_name BallBody

var initial_ball_speed : float = 500
var min_ball_speed : float = 300
var speed_reduction : float = 50
var speed_multiplier : float = 1.015
var max_speed : float = 1000
var velocity : Vector2 = Vector2.ZERO

var initial_player_x : float = 0
var initial_player_y : float = 0

var collision_count : int = 0


func _ready():
	visible = false
	# Connect the shoot_ball signal from the player
	get_parent().get_node("PlayerBody").connect("shoot_ball", _on_player_shoot_ball)
	get_parent().connect("reset_speed", reset_initial_ball_speed)

func _process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier

		var current_speed = velocity.length()

		if current_speed > max_speed:
			velocity = velocity.normalized() * max_speed

		if initial_ball_speed > min_ball_speed:
			collision_count += 1
			print("Current Ball Speed:", initial_ball_speed)
			if collision_count % 1 == 0:
				initial_ball_speed -= speed_reduction
				velocity = velocity.normalized() * initial_ball_speed
		else:
			velocity *= speed_multiplier
			#print("Current Ball Speed:", velocity)


func _integrate_forces(state):
	state.linear_velocity = velocity

func _on_player_shoot_ball():
	if velocity == Vector2.ZERO:
		initial_player_x = get_parent().get_node("PlayerBody").position.x
		position.x = initial_player_x
		initial_player_y = get_parent().get_node("PlayerBody").position.y
		position.y = initial_player_y - 60
		
		velocity = Vector2(0, initial_ball_speed)
		visible = true


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		hide()
		Global.add_ball()
		print("Player has_Ball: ", Global.has_ball())

func _on_enemy_hit_area_entered(area):
	if area.is_in_group("Enemy"):
		print("Enemy Hit")

func reset_initial_ball_speed():
	initial_ball_speed = 500
