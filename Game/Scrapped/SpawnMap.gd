extends TileMap

var target_layer_index : int = 0
var atlas_coords_changes : Dictionary = {
	Vector2i(7, 8): Vector2i(7, 6),
	Vector2i(7, 9): Vector2i(7, 7),
	Vector2i(8, 8): Vector2i(8, 6),
	Vector2i(8, 9): Vector2i(8, 7)
}

func _ready():
	pass

func _process(delta: float):
	# Check for the condition (e.g., pressing the down button)
	if Input.is_action_pressed("ui_down"):
		# Get the cells in the target layer
		var cells = get_used_cells(target_layer_index)

		# Iterate through each cell in the target layer
		for cell in cells:
			# Get the atlas coordinates of the tile in the tileset for the current cell
			var current_atlas_coords = get_cell_atlas_coords(target_layer_index, cell)

			# Check if the current atlas coordinates need to be changed
			if atlas_coords_changes.has(current_atlas_coords):
				# Get the new atlas coordinates for the tile
				var new_atlas_coords = atlas_coords_changes[current_atlas_coords]

				# Get the source ID of the tile in the tileset
				var source_id = get_cell_source_id(target_layer_index, cell)

				# Set the new atlas coordinates for the tile
				set_cell(target_layer_index, cell, source_id, new_atlas_coords, 1)
