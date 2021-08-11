tool
extends OptionButton


export(NodePath) var T2M_containerPath
export(NodePath) var MatModifierContainerPath

func _Update_Visibility(index):
	var T2M_container = get_node(T2M_containerPath)
	var MatModifierContainer = get_node(MatModifierContainerPath)
	if index == 0:
		T2M_container.set_visible(true)
		MatModifierContainer.set_visible(false)
	else: 
		T2M_container.set_visible(false)
		MatModifierContainer.set_visible(true)
		


func _ready():
	_Update_Visibility(get_selected_id())

func _on_Mode_Options_item_selected(index):
	_Update_Visibility(index)
