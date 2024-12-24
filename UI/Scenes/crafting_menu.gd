extends Control


@onready var ingredient_container: VBoxContainer = $PanelContainer/VBoxContainer/Ingredients/ScrollContainer/IngredientContainer
@onready var recipe_container: HBoxContainer = $PanelContainer/VBoxContainer/Recipes/ScrollContainer/RecipeContainer
@onready var output_container: MarginContainer = $PanelContainer/VBoxContainer/Output
@onready var craft_button: Button = $PanelContainer/VBoxContainer/CraftContainer/CraftButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var input_label: Label = $PanelContainer/VBoxContainer/InputLabel
@onready var output_label: Label = $PanelContainer/VBoxContainer/OutputLabel

var ingredient_scene : PackedScene = preload("res://UI/Scenes/ingredient.tscn")

var selected_recipe : CraftingRecipe

var recipe_button_scene : PackedScene = preload("res://UI/Scenes/recipe_button.tscn")

@onready var player : Player = get_tree().get_first_node_in_group("player")

var crafting := false

func _ready():
	visibility_changed.connect(on_visibility_changed)
	
	for c in recipe_container.get_children():
		c.queue_free()
	
	for r in CraftingRegistry.recipes:
		var spawned : RecipeButton = recipe_button_scene.instantiate()
		spawned.crafting_recipe = r
		spawned.selected.connect(on_recipe_selected)
		recipe_container.add_child(spawned)
	
	player.inventory.updated.connect(on_inventory_updated)


func show_recipe(recipe: CraftingRecipe) -> void:
	selected_recipe = recipe
	
	input_label.show()
	output_label.show()
	
	for c in ingredient_container.get_children():
		c.queue_free()
	
	for ingredient in recipe.ingredients:
		var spawned := ingredient_scene.instantiate()
		spawned.crafting_ingredient = ingredient
		
		ingredient_container.add_child(spawned)
	
	for c in output_container.get_children():
		c.queue_free()
	
	var spawned := ingredient_scene.instantiate()
	spawned.crafting_ingredient = recipe.output
	
	output_container.add_child(spawned)
	
	craft_button.set_craftable(recipe.can_craft(player.inventory))


func on_visibility_changed() -> void:
	if !visible:
		clean_up()


func clean_up() -> void:
	selected_recipe = null
	
	input_label.hide()
	output_label.hide()
	
	for c in ingredient_container.get_children():
		c.queue_free()
	
	for c in output_container.get_children():
		c.queue_free()
	
	craft_button.set_craftable(false)


func on_recipe_selected(recipe: CraftingRecipe) -> void:
	show_recipe(recipe)


func _on_craft_button_pressed() -> void:
	if !selected_recipe || !selected_recipe.can_craft(player.inventory):
		return
	
	selected_recipe.craft(player.inventory)


func on_inventory_updated() -> void:
	if !selected_recipe:
		craft_button.set_craftable(false)
		return
	
	craft_button.set_craftable(selected_recipe.can_craft(player.inventory))


func show_crafting() -> void:
	crafting = true
	animation_player.play("show", -1, 1, false)


func hide_crafting() -> void:
	crafting = false
	animation_player.play("show", -1, -1, true)
