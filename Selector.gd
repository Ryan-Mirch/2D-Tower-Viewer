extends VBoxContainer

@export_dir var directory
@export_node_path(Sprite2D) var sprite
@onready var label = $Label
@onready var optionsDropdown:OptionButton = $Options
@onready var variationsDropdown:OptionButton = $Variations


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = name
	sprite = get_node(sprite)
	
	populate_options()
	populate_variations()
	update_sprite()
	
func update_sprite():
	var path = directory + "/"
	path += optionsDropdown.get_item_text(optionsDropdown.selected) + "/"
	path += variationsDropdown.get_item_text(variationsDropdown.selected)
	sprite.texture = load(path)
	
func populate_options():
	optionsDropdown.clear()
	for option in list_files_in_directory(directory):
		optionsDropdown.add_item(option)
		
func populate_variations():
	variationsDropdown.clear()
	for variation in list_files_in_directory(directory + "/" + optionsDropdown.get_item_text(optionsDropdown.selected)):
		if !variation.ends_with(".import"):
			var path = directory + "/"
			path += optionsDropdown.get_item_text(optionsDropdown.selected) + "/"
			path += variation
			
			var texture = ImageTexture.new()
			var image = Image.new()
			image.load(path)
			texture.create_from_image(image)
			texture.set_size_override(Vector2(100,100))
			
			variationsDropdown.add_icon_item(texture,variation)
			
			


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func _on_variations_item_selected(index):
	update_sprite()
	
func _on_options_item_selected(index):
	populate_variations()
	update_sprite()
