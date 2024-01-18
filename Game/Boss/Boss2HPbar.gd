extends ProgressBar

@onready var boss_type_2 = $"../BossType2"



func _process(delta):
	if value > 0:
		global_position = boss_type_2.position + Vector2(-32, 48)
		value = boss_type_2.lives
	else:
		queue_free()

