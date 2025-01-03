extends Node2D
class_name CharacterStats

var skills: Dictionary = {
	"construction": 5,
	"mining": 5,
	"arbory": 5,
	"hunting": 5,
	"farming": 5,
	"animal_handaling": 5,
	"crafting": 5,
	"cooking": 5,
	"melee": 5,
	"ranged": 5,
}
var stats: Dictionary = {
	"max_health": 100,
	"cur_health": 100,
	"speed": 20,
	"strength": 5,
	"constitution": 5,
	"inteligence": 5,
	"skills": skills,
}

func _ready() -> void:
	skills = stats["skills"]
	var rng = RandomNumberGenerator.new()
	rng.randomize() 
	stats["max_health"] = int(clamp(rng.randfn(100, 5), 0, 200))
	stats["cur_health"] = stats["max_health"]
	stats["speed"] = int(clamp(rng.randfn(25, 2.5), 20, 30))
	stats["strength"] = int(clamp(rng.randfn(5, 1.5), 0, 10))
	stats["constitution"] = int(clamp(rng.randfn(5, 1.5), 0, 10))
	stats["inteligence"] = int(clamp(rng.randfn(5, 1.5), 0, 10))
	for skill in skills:
		var val = rng.randfn(5, 1.5) 
		skills[skill] = int(clamp(val, 0, 10))
	
