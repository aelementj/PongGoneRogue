extends RigidBody2D
class_name BallBody

var initial_ball_speed : float = 500
var speed_reduction : float = 50
var velocity : Vector2 = Vector2.ZERO


var initial_player_x : float = 0
var initial_player_y : float = 0

var collision_count : int = 0

func _ready():
	visible = false
	get_parent().get_node("PlayerBody").connect("shoot_ball", _on_player_shoot_ball)
	update_size()


func _process(delta):
	if not is_player_valid():
		velocity = Vector2.ZERO
	
	update_scale()
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= 1
		velocity.y *= 1
		print(velocity)

		var current_speed = velocity.length()
		$Bounce.play()

		if current_speed > initial_ball_speed:
			velocity = velocity.normalized() * initial_ball_speed

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
		Global.set_ball_reference(self)


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		$BallPickUp.play()
		hide()
		Global.add_ball()
		print("Player has_Ball: ", Global.has_ball())

func _on_enemy_hit_area_entered(area):
	if area.is_in_group("Enemy"):
		print("Enemy Hit")
		$EnemyHit2.play()

func is_player_valid() -> bool:
	return Global.get_player_reference() != null


