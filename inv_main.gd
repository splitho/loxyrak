extends Control

@export var inv_grid_visual : TextureRect
@export var inv_item_entity_scene : PackedScene
@export var item_entities : Control
var inv_slots : Dictionary = {}
var inv_size = Vector2(20, 20)
var inv_cell_size = 20
@export var active : bool = false
var cur_held_item_entity = null
#y = height
#x = length

func _ready():
	create_inv_slots()
	add_item_entity(0)
	add_item_entity(0)
	add_item_entity(1)

func _process(delta):
	if !active:
		return
	if Input.is_action_pressed("left_click"):
		if cur_held_item_entity != null:
			pass #move preview under mouse
	if Input.is_action_just_released("left_click"):
		if cur_held_item_entity != null:
			if is_mouse_over_inv():
				var inv_slot_under_mouse = find_inv_slot_under_mouse()
				if can_item_fit(inv_slot_under_mouse, cur_held_item_entity):
					pass
			#if is_mouse_over_equip
			#else: throw on ground
			cur_held_item_entity == null
	if Input.is_action_just_pressed("left_click"):
		if is_mouse_over_inv():
			var inv_slot_under_mouse = find_inv_slot_under_mouse()
			if inv_slot_under_mouse != null:
				cur_held_item_entity = inv_slots[inv_slot_under_mouse]["item_entity"]
	
func create_inv_slots():
	inv_grid_visual.size.y = inv_size.y * inv_cell_size
	inv_grid_visual.size.x = inv_size.x * inv_cell_size
	for x in range(inv_size.x):
		for y in range(inv_size.y):
			inv_slots[Vector2(x, y)] = null

func add_item_entity(db_item_id):
	var db_item_ref = db_items.db_items[db_item_id]
	var inv_item_entity_instance = inv_item_entity_scene.instantiate()
	inv_item_entity_instance.db_item_id = db_item_id
	inv_item_entity_instance.item_size = db_item_ref.item_size
	inv_item_entity_instance.inv_item_entity_icon.texture = db_item_ref.item_icon
	inv_item_entity_instance.inv_item_entity_icon.size = inv_cell_size * db_item_ref.item_size
	var available_slot = find_next_available_slot(inv_item_entity_instance)
	if available_slot != null:
		inv_item_entity_instance.item_position = available_slot
		item_entities.add_child(inv_item_entity_instance)
		#inv_grid_visual.add_child(inv_item_entity_instance)
		add_item_to_slots(available_slot, inv_item_entity_instance, db_item_ref.item_size)
		inv_item_entity_instance.position = available_slot * 20
			
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

func find_next_available_slot(item_entity):
	for x in range(inv_size.x):
		for y in range(inv_size.y):
			if inv_slots[Vector2(x, y)] == null:
				if can_item_fit(Vector2(x, y), item_entity):
					return Vector2(x, y)
	
func can_item_fit(inv_slot_under_mouse, item_entity):
	for x in range(inv_slot_under_mouse.x, inv_slot_under_mouse.x +  item_entity.size.x):
		for y in range(inv_slot_under_mouse.y, inv_slot_under_mouse.y +  item_entity.size.y):
			if !inv_slots[Vector2(x, y)] == null:
				return false		
	return true
	
func add_item_to_slots(inv_slot, item_entity, item_size):
	for x in range(inv_slot.x, inv_slot.x +  item_size.x):
		for y in range(inv_slot.y, inv_slot.y +  item_size.y):
			inv_slots[Vector2(x, y)] = item_entity