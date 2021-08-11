tool
extends Control

#var editor_interface = EditorInterface
#var FS1 = EditorFileSystem
#var FS2 = EditorInterface.get_filesystem()
#var FS3 = EditorSelection.get_filesystem()

export(NodePath) var nameLabelPath
export(NodePath) var previewAreaPath
export(NodePath) var loadPath

var currentResourcePath = "res://SomeMat1.material"
var currentResource

func _ready():
	pass


	#var FS = EditorInterface.get_resource_filesystem()


	#print(EditorFileSystem.get_selected())
	#print(EditorSelection.get_selection)
	#print(FS3.get_selection())
	#print(get_editor_interface().get_selection())
#	var editor_selection = editor_interface.get_selection()
#	var selected_nodes = editor_selection.get_selected_nodes()
#	print (selected_nodes)

func _on_BrowseFiles_pressed():
	get_node("FileDialog PNG").popup_centered()

func _on_Preview_pressed():
	#	Set preview image
	currentResourcePath = get_node(loadPath).get_text()
	print("Using ", currentResourcePath)
	var previewArea = get_node(previewAreaPath)
	currentResource = load(currentResourcePath) 
	previewArea.set_texture(currentResource)
	
	#	set preview material name
	var nameLabel = get_node(nameLabelPath)
	var displayName = currentResourcePath.get_file().trim_suffix('.png')
	nameLabel.set_text(str(displayName, ".material"))
	



func _on_Create_pressed():
	#	create new material and apply the currentRessource as albedo
	var myMaterial = SpatialMaterial.new()
	currentResource = load(currentResourcePath)
	myMaterial.albedo_texture = currentResource
	
	#	define a name for the material and save it as a resource
	var displayName = currentResourcePath.get_file().trim_suffix('.png')
	ResourceSaver.save(str("res://", displayName, ".material"), myMaterial)
	print("Saved new Material ", "res://", displayName, ".material")
		
	


#func _on_Modify_pressed():
#	currentRessource = SpatialMaterial.new()
#	currentRessource = load(currentRessourcePath) 
#	currentRessource.roughness = 0.5



#
#func _on_FileDialog_files_selected(paths):
#	print("Selected Files: ", paths)
#	#if paths[0] == ends_with(.png)
