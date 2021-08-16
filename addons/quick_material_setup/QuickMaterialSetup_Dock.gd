tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UseTemplate_Button_toggled(button_pressed):
	var pathField = get_node("VBoxContainer/ScrollContainer/Options/MaterialProperties/VBoxContainer2/TemplatePath Area/Material Path Area2/LoadPath")
	var openButton = get_node("VBoxContainer/ScrollContainer/Options/MaterialProperties/VBoxContainer2/TemplatePath Area/Material Path Area2/OpenButton")
	pathField.set_editable(button_pressed)
	openButton.set_disabled(!button_pressed)

