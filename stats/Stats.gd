extends Node
class_name stats

@export_category("core_stats")
var base_max_health : int = 50
var modified_max_health : int = 0
var base_max_stamina : int = 50
var modified_max_stamina : int = 0
var base_max_plasma : int = 50
var modified_max_plasma : int = 0
var core_stats = {
	"health" : 0,
	"stamina" : 0,
	"plasma" : 0
}

@export_category("attributes_stats")
var attributes_stats = {
	"att_stats_points" : 0,
	"base_str" : 0,
	"base_dex" : 0, 
	"base_int" : 0,
	"base_end" : 0,
	"base_agi" : 0,
	"base_wil" : 0
}
const att_stats_cap : int = 10
const att_stats_base : int = 5
var modified_str : int
var modified_dex : int
var modified_int
var modified_end : int
var modified_agi : int
var modified_wil : int

@export_category("talent_stats")
var talent_stats = {
	"talent_stats_points" : 0,
	"base_guns" : 0,
	"base_energy" : 0,
	"base_melee" : 0,
	"base_mutation" : 0,
	"base_bujiin" : 0,
	"base_heavy_arms" : 0,
	"base_explosives" : 0,
	"base_lockpick" : 0,
	"base_science" : 0,
	"base_survival" : 0,
	"base_first_aid" : 0,
	"base_crafting" : 0,
	"base_scavenging" : 0,
	"base_dodge" : 0, 
	"base_armor_use" : 0,
}
const talent_stats_cap : int = 100
const talent_stats_base : int = 15
var modified_guns : int = 0
var guns_cap : int = 0
var modified_energy : int = 0
var energy_cap : int = 0
var modified_melee : int = 0
var melee_cap : int = 0
var modified_mutation : int = 0
var mutation_cap : int = 0
var modified_bujiin : int = 0
var bujiin_cap : int = 0
var modified_heavy_arms : int = 0
var heavy_arms_cap : int = 0
var modified_explosives : int = 0
var explosives_cap : int = 0
var modified_lockpick : int = 0
var lockpick_cap : int = 0
var modified_science : int = 0
var science_cap : int = 0
var modified_survival : int = 0 
var survival_cap : int = 0
var modified_first_aid : int = 0
var first_aid_cap : int = 0
var modified_crafting : int = 0
var crafting_cap : int = 0
var modified_scavenging : int = 0
var scavenging_cap : int = 0
var modified_dodge : int = 0
var dodge_cap : int = 0
var modified_armor_use : int = 0
var armor_use_cap : int = 0

func update_core_stats():
	modified_max_health = base_max_health + (modified_str * 10) + (modified_end * 30)
	modified_max_stamina = base_max_stamina + (modified_end * 10) + (modified_agi * 30)
	modified_max_plasma = base_max_plasma + (modified_int * 10) + (modified_wil * 30)
	
func update_attributes_stats():
	modified_str = attributes_stats["base_str"]
	modified_dex = attributes_stats["base_dex"]
	modified_int = attributes_stats["base_int"]
	modified_end = attributes_stats["base_end"]
	modified_agi = attributes_stats["base_agi"]
	modified_wil = attributes_stats["base_wil"]
	
func update_talent_stats():
	update_talent_caps()

func update_talent_caps():
	guns_cap = update_talent_cap(guns_cap, modified_dex, modified_agi)
	energy_cap = update_talent_cap(energy_cap, modified_int, modified_dex)
	melee_cap = update_talent_cap(melee_cap, modified_str, modified_end)
	mutation_cap = update_talent_cap(mutation_cap, modified_wil, modified_int)
	bujiin_cap = update_talent_cap(bujiin_cap, modified_agi, modified_dex)
	heavy_arms_cap = update_talent_cap(heavy_arms_cap, modified_str, modified_dex)
	explosives_cap = update_talent_cap(explosives_cap, modified_dex, modified_int)
	
func update_talent_cap(talent_cap, firststat, secondstat):
	talent_cap = (firststat * 10) + (secondstat * 5)
	talent_cap = (clamp(talent_cap, 0, talent_stats_cap))
	return talent_cap
	
func new_stats():
	attributes_stats["att_stats_points"] = 5
	for attribute_stat in attributes_stats:
		if !attribute_stat.contains("att"):
			attributes_stats[attribute_stat] = att_stats_base
	talent_stats["talent_stats_points"] = 45
	for talent_stat in talent_stats:
		if !talent_stat.contains("talent"):
			talent_stats[talent_stat] = talent_stats_base
			
			
	update_attributes_stats()
	update_talent_caps()
	update_talent_stats()
	update_core_stats()
	
func load_stats():
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")
	if err != OK:
		return
	for core_stat in config.get_section_keys("core_stats"):
		core_stats[core_stat] = config.get_value("core_stats", core_stat)
	for attribute_stat in config.get_section_keys("attributes_stats"):
		attributes_stats[attribute_stat] = config.get_value("attributes_stats", attribute_stat)
	
func save_stats():
	var time = Time.get_datetime_dict_from_system()
	var config = ConfigFile.new()
	for core_stat in core_stats:
		config.set_value("core_stats", core_stat, core_stats[core_stat])
	for attribute_stat in attributes_stats:
		config.set_value("attributes_stats", attribute_stat, attributes_stats[attribute_stat])
	for talent_stat in talent_stats:
		config.set_value("talent_stats", talent_stat, talent_stats[talent_stat])
	
	var save_name : String = str(time["hour"]) + "_" + str(time["minute"]) + "_" + str(time["month"]) + "_" + str(time["day"]) + "_" + str(time["year"])
	print(save_name)
	#config.save("user://save" + save_name + ".cfg")
	config.save("user://save.cfg")

func _ready():
	new_stats()
	save_stats()
	load_stats()
