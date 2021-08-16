tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/quick_material_setup/QuickMaterialSetup_Dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
