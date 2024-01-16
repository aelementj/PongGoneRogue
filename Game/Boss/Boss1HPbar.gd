extends ProgressBar

@onready var boss_type_1 = $"../BossType1"



func _process(delta):
	if value > 0:
		global_position = boss_type_1.position + Vector2(-32, 24)
		value = boss_type_1.lives
	else:
		queue_free()

