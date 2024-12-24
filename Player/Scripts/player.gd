class_name Player
extends CharacterBody2D


signal damaged

signal test_signal

@export var c: Color

@export var inventory_ui : Control

var aim_position : Vector2 = Vector2(1, 0)

var alive := true
var invincible := false

var inventory : Inventory = Inventory.new()

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var crafting_menu: Control = $CanvasLayer/CraftingMenu

var crafting :
	get():
		return crafting_menu.crafting


func _ready():
	inventory_ui.display_inventory(inventory)


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_focus_next"):
		if crafting_menu.crafting:
			crafting_menu.hide_crafting()
		else:
			crafting_menu.show_crafting()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var half_viewport = get_viewport_rect().size / 2.0
		aim_position = (event.position - half_viewport)


func on_hitbox_damaged(attack: Attack) -> void:
	damaged.emit(attack)


func on_health_changed(health: float):
	print("Health changed to " + str(health) + "!")
