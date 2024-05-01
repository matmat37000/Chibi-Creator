extends Resource
class_name item

@export_category("Data")
@export var item_name: String = ""
@export var item_texture: Texture
@export_category("Utilisation")
@export_enum("Left", "Middle", "Right") var position: int = 0
@export var single: bool = true
