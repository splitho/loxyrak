extends Control

@export var inv_grid_visual : TextureRect
@export var inv_item_entity_scene : PackedScene
var inv_slots : Dictionary = {}
var inv_size = Vector2(10, 7)
var inv_cell_size = 20
#y = height
#x = length

func _ready():
	create_inv_slots()

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		if is_mouse_over_inv():
			print(str(find_inv_slot_under_mouse()))
	
func create_inv_slots():
	inv_grid_visual.size.y = inv_size.y * inv_cell_size
	inv_grid_visual.size.x = inv_size.x * inv_cell_size
	for x in range(inv_size.x):
		for y in range(inv_size.y):
			var new_inv_slot = {
				"item_entity" = null
			}
			inv_slots[Vector2(x, y)] = new_inv_slot
			
func find_inv_slot_under_mouse():
	var mouse_position = get_viewport().get_mouse_position()
	var inv_slot_key = Vector2()
	inv_slot_key.x = (mouse_position.x - inv_grid_visual.position.x) / inv_cell_size
	inv_slot_key.x = floor(inv_slot_key.x)
	inv_slot_key.y = (mouse_position.y - inv_grid_visual.position.y) / inv_cell_size
	inv_slot_key.y = floor(inv_slot_key.y)
	return inv_slot_key
	
func is_mouse_over_inv():
	var mouse_position = get_viewport().get_mouse_position()
	var inv_rect = Rect2(inv_grid_visual.position, Vector2(inv_size.x * inv_cell_size,inv_size.y * inv_cell_size))
	if inv_rect.has_point(mouse_position):
		return true
	else:
		return false
		
func can_item_fit(inv_slot_under_mouse, item_entity):
	for x in range(inv_slot_under_mouse.x, inv_slot_under_mouse.x +  item_entity.size.x):
		for y in range(inv_slot_under_mouse.y, inv_slot_under_mouse.y +  item_entity.size.y):
			if !inv_slots[Vector2(x, y)]["item_entity"] == null:
				return false		
	return true
