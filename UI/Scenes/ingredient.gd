extends HBoxContainer

var crafting_ingredient : CraftingIngredient

@onready var texture: TextureRect = $Texture
@onready var label: Label = $Label


func _ready() -> void:
	if !crafting_ingredient:
		queue_free()
		return
	
	var item : Item = crafting_ingredient.item
	
	texture.texture = item.sprite
	
	label.text = "%s x %d" % [item.item_name, crafting_ingredient.count]
