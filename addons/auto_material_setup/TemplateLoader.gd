tool
extends HBoxContainer

export(NodePath) var fileDialogPath
export(NodePath) var rootControl




func _on_OpenButton_pressed():
	var fileDialog = get_node(fileDialogPath)
	fileDialog.popup_centered()


func _on_FileDialog_TemplateMat_file_selected(path):
	get_node(rootControl).templateMatPath = path
	get_node("LoadPath").set_text(path)
