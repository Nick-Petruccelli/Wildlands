extends Node2D

var item_data: Dictionary = {}
var environment_data: Dictionary = {}

func _ready() -> void:
	load_item_data()
	load_environment_data()
	for key in environment_data:
		print(environment_data[key])

func load_item_data() -> void:
	var item_data_path = "res://GameData/Items/"
	var data_dir = open_dir(item_data_path)
	if data_dir == null:
		return
	var data_files = data_dir.get_files()
	for file_name in data_files:
		var file = FileAccess.open(item_data_path+file_name, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		add_to_item_data(data)
		
func add_to_item_data(data: Dictionary) -> void:
	if item_data.has(data["id"]):
		print("Error: loading item data, item id alredy in use.")
		return
	item_data[data["id"]] = data

func load_environment_data() -> void:
	var environment_data_path = "res://GameData/Environment/"
	var data_dir = open_dir(environment_data_path)
	if data_dir == null:
		return
	var data_dirs = data_dir.get_directories()
	for dir_name in data_dirs:
		var dir = open_dir(environment_data_path+dir_name)
		var data_files = dir.get_files()
		for file_name in data_files:
			var file = FileAccess.open(environment_data_path+dir_name+"/"+file_name, FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			add_to_environment_data(data)
		
func add_to_environment_data(data: Dictionary) -> void:
	if environment_data.has(data["id"]):
		print("Error: loading item data, item id alredy in use.")
		return
	environment_data[data["id"]] = data
	
func open_dir(path: String) -> DirAccess:
	var dir = DirAccess.open(path)
	if dir == null:
		print("ERROR: failed to open directory at: ", path)
	return dir
