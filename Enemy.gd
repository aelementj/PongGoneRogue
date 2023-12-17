extends CharacterBody2D

@export var move_speed: float = 30
@export var move_duration: float = 1.0
@export var stop_duration: float = 0.5
@export var initial_hits_to_destroy: int = 3
@export var bullet_spawn_interval: float = 2.0
@export var bullet_speed: float = 100
@export var bullet_scene: PackedScene

var original_direction: Vector2 = Vector2.RIGHT
var current_direction: Vector2 = Vector2.RIGHT
var timer: float = 0.0
var is_moving: bool = true
var hits_remaining: int = 3
var dungeon_generator: Node2D
var initial_move_speed: float
var initial_bullet_spawn_interval: float

func _ready():
	original_direction = [Vector2.RIGHT, Vector2.LEFT][randi() % 2]
	current_direction = original_direction
	$Timer.start()
	bullet_scene = preload("res://Experimental/Bullet.tscn")

	dungeon_generator = get_tree().get_nodes_in_group("dungeon_generator")[0]
	assert(dungeon_generator, "Dungeon generator not found!")

	initial_move_speed = move_speed
	initial_bullet_spawn_interval = bullet_spawn_interval

func _physics_process(delta):
	if is_moving:
		var distance_to_move = move_speed * delta

		# Move in the current direction
		var new_position = position + current_direction * distance_to_move
		var collision_info = move_and_collide(new_position - position)

		if collision_info:
			current_direction *= -1
			is_moving = true

	else:
		# Timer to control the stopping duration
		timer -= delta

		if timer <= 0.0:
			# Change direction and start moving again
			current_direction *= -1
			is_moving = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("ball"):
		is_moving = false
		timer = stop_duration
		hits_remaining -= 1

		if hits_remaining <= 0:
			queue_free()
		else:
			timer = stop_duration
			# Update move_speed and bullet_spawn_interval based on hits_remaining
			update_enemy_parameters()

# Timer callback to spawn bullets
func _on_Timer_timeout():
	spawn_bullet()

func spawn_bullet():
	# Instantiate a bullet
	var bullet = bullet_scene.instantiate()
	# Set the bullet's initial position to the position of the enemy plus an offset to the right
	bullet.global_position = global_position + Vector2(10, dungeon_generator.tileSize * 3)  # Adjust the offset as needed

	get_parent().add_child(bullet)

func update_enemy_parameters():
	# Update move_speed and bullet_spawn_interval based on hits_remaining
	move_speed = initial_move_speed + (initial_move_speed / initial_hits_to_destroy) * (initial_hits_to_destroy - hits_remaining + 1)
	bullet_spawn_interval = initial_bullet_spawn_interval - (initial_bullet_spawn_interval / initial_hits_to_destroy) * (initial_hits_to_destroy - hits_remaining + 1)
	$Timer.wait_time = bullet_spawn_interval
