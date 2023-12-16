extends RigidBody2D

# Exported property for easy tweaking in the Godot editor
@export var speed: float = 100

# Property with setter and getter
var _velocity: Vector2 = Vector2(0, 0)

func set_velocity(value):
	_velocity = value

func get_velocity():
	return _velocity

func _ready():
	# Apply initial velocity
	linear_velocity = get_velocity()

func _process(delta):
	# Check if the bullet is below the screen and queue_free it
	if global_position.y > get_viewport_rect().size.y:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		# Handle collision with the player
		queue_free()
