extends ProgressBar

@onready var boss_type_3 = $"../BossType3"




func _process(delta):
	if value > 0:
		global_position = boss_type_3.position + Vector2(-54, 48)
		value = boss_type_3.lives
	else:
		queue_free()

