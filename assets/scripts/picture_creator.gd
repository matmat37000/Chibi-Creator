extends Control

#@export var items_list: Array[item]
@export var file_dialog: FileDialog
@export var cat_button: TextureButton

var image_size: int = 512
var items_list: Array[Texture]
var background_color = Color.TRANSPARENT

func _ready() -> void:
	file_dialog.current_dir = "Documents"
	file_dialog.set_filters(["*.png ; PNG Images", "*.PNG ; PNG Images"])	

	if cat_button.texture_normal:
		# Get the image from the texture normal
		var image = cat_button.texture_normal.get_image()
		# Create the BitMap
		var bitmap = BitMap.new()
		# Fill it from the image alpha
		bitmap.create_from_image_alpha(image)
		# Assign it to the mask
		cat_button.texture_click_mask = bitmap

	# if not DirAccess.dir_exists_absolute("user://images/"):
	# 	DirAccess.make_dir_absolute("user://images/")

func generate_image(img_size: Vector2i, color: Color, file_name: String, items: Array[Texture]):
	var img = Image.create(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	img.fill(color)
	
	var mask = Image.create(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	mask.fill(Color(0, 0, 0, 5))
	
	var base := preload("res://assets/pictures/base.png").get_image()
	base.convert(Image.FORMAT_RGBA8)
	base.resize(img_size.x, img_size.y)
	img.blend_rect(base, Rect2(Vector2.ZERO, base.get_size()), Vector2.ZERO) # base.get_size()
	
	for it in items:
#		var img = Image.load_from_file("user://test.png")
		if it == null: continue
		var item_image = it.get_image()
		item_image.convert(Image.FORMAT_RGBA8)
		item_image.resize(img_size.x, img_size.y)
		img.blend_rect(item_image, Rect2(Vector2.ZERO, item_image.get_size()), Vector2.ZERO) # item_image.get_size()
	img.save_png(file_name) 
	

func check_item_selected() -> void:
	var objects = $TabContainer.get_children()
	var id = 0
	if items_list == []:
		items_list = [null, null, null, null, null, null]

	for object: Node in objects:
		if not object is ItemList: continue

		id += 1
		var index = object.get_selected_items()
		if index.is_empty(): continue
		else: index = index[0]

		items_list[id] = object.get_item_icon(index)

		var image_display: Array[Node] = $Base.get_children()
		image_display[id].texture = items_list[id]

func _on_file_dialog_file_selected(path: String) -> void:
	if path == "":
		print("No Text")
		return
	elif path.ends_with(".png") or path.ends_with(".PNG"):
		path = path.trim_suffix(".png")

	generate_image(Vector2i(image_size, image_size), background_color, path+".png", items_list)

func _process(_delta):
	check_item_selected()

func _on_background_color_changed(color: Color) -> void:
	$Base/Back.color = color
	background_color = color


func _on_generate_pressed():
	file_dialog.show()

func _on_size_value_changed(value: float) -> void:
	$Size.suffix = "x %s" % value
	image_size = int(value)

func _on_base_pressed():
	$CatSound.play()
