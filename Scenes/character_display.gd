extends VBoxContainer

@onready var _name: Label = $Name
@onready var picture: TextureRect = $Picture
@onready var stats: GridContainer = $HBoxContainer/Stats


func show_character(character) -> void:
	load_name(character.name)
	load_picture(character.animated_sprite_2d)
	load_stats(character.stats)
	
	
func load_name(new_name: String) -> void:
	_name.text = new_name

func load_picture(char_sprite: AnimatedSprite2D) -> void:
	var frameIndex: int = char_sprite.get_frame()
	var animationName: String = char_sprite.animation
	var spriteFrames: SpriteFrames = char_sprite.get_sprite_frames()
	picture.texture = spriteFrames.get_frame_texture(animationName, frameIndex)

func load_stats(char_stats: CharacterStats) -> void:
	var stats = char_stats.stats
	for stat in stats:
		if stat == "skills":
			break
		add_stat(stat, stats[stat])
	for skill in stats["skills"]:
		add_stat(skill, stats["skills"][skill])

		
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
