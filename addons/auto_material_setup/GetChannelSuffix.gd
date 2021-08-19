tool
extends Node

export(NodePath) var root



func _on_AO_LineEdit_text_changed(new_text):
	get_node(root).ao_suffix = new_text

func _on_AO_Options_item_selected(index):
	get_node(root).ao_channnel = index



func _on_Rough_LineEdit_text_changed(new_text):
	get_node(root).roughness_suffix = new_text

func _on_Rough_Options_item_selected(index):
	get_node(root).roughness_channnel = index



func _on_Metal_LineEdit_text_changed(new_text):
	get_node(root).metallic_suffix = new_text

func _on_Metal_Options_item_selected(index):
	get_node(root).metallic_channnel = index
