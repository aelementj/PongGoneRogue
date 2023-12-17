extends CharacterBody2D

class_name Ballv2

@export var initial_ball_speed: float = 20
@export var speed_multiplier: float = 1.01
@export var max_speed: float = 100

var ball_speed: float = initial_ball_speed
var initial_position: Vector2

# Accessing values from the room scene
var roomScene = preload("res://dungeon_crawler.tscn").instantiate()
var width = roomScene.getRoomWidth()
var length = roomScene.getRoomLength()
var size = roomScene.getTileSize()


func initialize_ball(player_position: Vector2, room_length: int, tile_size: float) -> void:
	# Set the ball's initial position right above the player
	initial_position = player_position + Vector2(0, -room_length * tile_size / 20)
	global_position = initial_position

	# Set the initial velocity
	velocity.x = [0.8, -0.8][randi() % 2]
	velocity.y = initial_ball_speed

func _ready():
	initialize_ball(Vector2.ZERO, length, size)  # You might want to pass the actual values here
	

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta * initial_ball_speed)
	if collision_info:
		var collision_normal = collision_info.get_normal()
		velocity = velocity.bounce(collision_normal)
		velocity.x *= speed_multiplier
		velocity.y *= speed_multiplier

		# Check and clamp the magnitude of the velocity
		var current_speed = velocity.length()

		if current_speed > max_speed:
			velocity = velocity.normalized() * max_speed

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		print("Hit enemy!")

	if area.is_in_group("ball_catcher"):
		print("Caught by ball_catcher!")
		initialize_ball(Vector2.ZERO, length, size) 
