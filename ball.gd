extends CharacterBody2D

class_name Ball

@export var initial_ball_speed = 15
@export var speed_multiplier = 1.05


var ball_speed = initial_ball_speed

func _ready():
	start_ball()
	

func _physics_process(delta):
	var collision = move_and_collide(velocity * ball_speed * delta)
	if(collision):
		velocity = velocity.bounce(collision.get_normal()) * speed_multiplier


func start_ball():
	velocity.x = [0.2,-0.2][randi() % 2]
	velocity.y = initial_ball_speed

