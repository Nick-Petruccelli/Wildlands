extends VBoxContainer

@onready var _name: Label = $Name
@onready var picture: TextureRect = $HBoxContainer2/Picture
@onready var stats: GridContainer = $HBoxContainer/Stats
@onready var head_item: Label = $HBoxContainer2/VBoxContainer/GridContainer/HeadItem
@onready var body_item: Label = $HBoxContainer2/VBoxContainer/GridContainer/BodyItem
@onready var legs_item: Label = $HBoxContainer2/VBoxContainer/GridContainer/LegsItem
@onready var main_hand_item: Label = $HBoxContainer2/VBoxContainer/GridContainer/MainHandItem
@onready var off_hand_item: Label = $HBoxContainer2/VBoxContainer/GridContainer/OffHandItem
@onready var character_display: VBoxContainer = $"."


func show_character(character) -> void:
	load_name(character.name)
	load_picture(character.animated_sprite_2d)
	load_equipment(character.equipment)
	load_stats(character.stats)
	character_display.visible = true
	
	
func load_name(new_name: String) -> void:
	_name.text = new_name

func load_picture(char_sprite: AnimatedSprite2D) -> void:
	var frameIndex: int = char_sprite.get_frame()
	var animationName: String = char_sprite.animation
	var spriteFrames: SpriteFrames = char_sprite.get_sprite_frames()
	picture.texture = spriteFrames.get_frame_texture(animationName, frameIndex)

func load_equipment(char_equip: Equipment) -> void:
	var item_data = get_tree().get_first_node_in_group("gamedata").item_data
	var equip = char_equip._equipment
	head_item.text = item_data[equip["head"]]["name"] if equip["head"] > 0 else "none"
	body_item.text = item_data[equip["body"]]["name"] if equip["body"] > 0 else "none"
	legs_item.text = item_data[equip["legs"]]["name"] if equip["legs"] > 0 else "none"
	main_hand_item.text = item_data[equip["main_hand"]]["name"] if equip["main_hand"] > 0 else "none"
	off_hand_item.text = item_data[equip["off_hand"]]["name"] if equip["off_hand"] > 0 else "none"

func load_stats(char_stats: CharacterStats) -> void:
	for stat in stats.get_children():
		stat.queue_free()
	var stats_dict = char_stats.stats
	for stat in stats_dict:
		if stat == "skills":
			break
		add_stat(stat, stats_dict[stat])
	for skill in stats_dict["skills"]:
		add_stat(skill, stats_dict["skills"][skill])

		
func add_stat(_name: String, level: int) -> void:
	var container = HBoxContainer.new()
	var stat_name = Label.new()
	var stat_level = Label.new()
	stat_name.text = _name
	stat_name.add_theme_font_size_override("font_size", 12)
	stat_level.text = str(level)
	stat_level.add_theme_font_size_override("font_size", 12)
	container.add_child(stat_name)
	container.add_child(stat_level)
	stats.add_child(container)
