tool
extends Control


const SCALE_SUFFIX_ARRAY = ["_1K", "_2K", "_3K", "_4K", "_6K", "_8K", "_1k", "_2k", "_3k", "_4k", "_6k", "_8k"]

const ALBEDO_SUFFIX_ARRAY = ["_color", "_col", "_diffuse","_diff", "_albedo", "_base"]
const NORMAL_SUFFIX_ARRAY = ["_normal", "_nor", "_nrm", "_norm", "_bump", "_bmp"]
const METALLIC_SUFFIX_ARRAY = ["_metallic", "_metalness", "_metal", "_mtl"]
const ROUGHNESS_SUFFIX_ARRAY = ["_roughness", "_rough", "_rgh", "_gloss", "_glossy", "_glossiness"]
const EMISSION_SUFFIX_ARRAY = ["_emission","_emissive", "_em"]

var currentResourcePaths
var autoAssing = true
var useTemplateMat = false
var templateMatPath
var useColorChannels = false

func _enter_tree():
	var templatePathArea = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/Template Path Area")
	var useTemplateButton = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/UseTemplate Area/UseTemplate_Button")
	templatePathArea.set_visible(useTemplateButton.is_pressed())
	
	var colorChannelArea = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/ColorChannel_Area")
	var useColorChannelsCheckbox = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/UseColorChannels/UseColorChannel_Checkbox")
	colorChannelArea.set_visible(useColorChannelsCheckbox.is_pressed())

func _on_UseTemplate_Button_toggled(button_pressed):
	var templatePathArea = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/Template Path Area")
	templatePathArea.set_visible(button_pressed)
	useTemplateMat = button_pressed
	print("set useTemplateMat to ", button_pressed)
	

func _on_AutoAssign_Checkbox_toggled(button_pressed):
	autoAssing = button_pressed
	print("set autoAssign to ", button_pressed)
	

func _on_UseColorChannel_Checkbox_toggled(button_pressed):
	var colorChannelArea = get_node("VBoxContainer/Options/ScrollContainer/MaterialProperties/Settings/ColorChannel_Area")
	colorChannelArea.set_visible(button_pressed)
	colorChannelArea = button_pressed
	print("set colorChannelArea to ", button_pressed)

func _on_Create_pressed():
	
	var currentMat
	if useTemplateMat == true:
		currentMat = load(templateMatPath).duplicate()
	else:
		currentMat = SpatialMaterial.new()




	for path in currentResourcePaths:
		
		# only use the part of the string BEFORE the last slash
		var workingDir = path.left(path.find_last("/")+1)
	
		# only use the part of the string AFTER the last slash
		var fileName = path.right(path.find_last("/")+1)
		
		# create the variable "texName" by copying fileName (because otherwise erase() would overwrite it)
		var texName = fileName 
		# then erase the file ending from it
		texName.erase(texName.find_last("."), texName.length()-texName.find_last("."))
		
		
		if autoAssing == true:
		
			#	Remove stupid scale suffixes because they would mess with my channel suffix detection
			for scaleSuffix in SCALE_SUFFIX_ARRAY:
				if texName.ends_with(scaleSuffix) == true:
					texName = texName.trim_suffix(scaleSuffix)
					print("removed suffix ", scaleSuffix, " from Texture ", texName)
					break
			# Remove the even dumber _gl suffix because screw that
			if texName.ends_with("_gl") == true:
				texName = texName.trim_suffix("_gl")
				print("also removed _gl suffix from ", texName)
				
				
			
			# just an array containing all suffixes
			var suffixMaster = []
			suffixMaster.append_array(ALBEDO_SUFFIX_ARRAY)
			suffixMaster.append_array(NORMAL_SUFFIX_ARRAY)
			suffixMaster.append_array(METALLIC_SUFFIX_ARRAY)
			suffixMaster.append_array(ROUGHNESS_SUFFIX_ARRAY)
			suffixMaster.append_array(EMISSION_SUFFIX_ARRAY)
		
			var matName
			var useAsAlbedo = false # If this is true, it will skipp going through other suffixes
									# and directly use it as the albedo
			
			# If a channel suffix is found, remove it from the string and use it as matName
			# if no suffix matches, simply use the texture as albedo
			for anySuffix in suffixMaster:
				if texName.ends_with(anySuffix):
					matName = texName.trim_suffix(anySuffix)
					useAsAlbedo = false
					break
				else:
					matName = texName
					useAsAlbedo = true
			
			
			# this will be the path of the new material file
			var matPath = (workingDir + matName + ".tres")
			
			# first check if the file already exists, otherwise load it in
			var dummyFile =  File.new() # why do we have to create these??! 
			#var currentMat # The loaded material instance
			
			if dummyFile.file_exists(matPath) == true:
				currentMat = load(matPath)
			else:
				#currentMat = SpatialMaterial.new()
				pass
			# Either directly assign it to albedo, or assign it based on the suffix in texName
			if useAsAlbedo == true:
				currentMat.albedo_texture = load(path)
				print("no suffix found, using ", path, " as albedo")
				
			else:
				for albedoSuffix in ALBEDO_SUFFIX_ARRAY:
					if texName.ends_with(albedoSuffix):
						currentMat.albedo_texture = load(path)

				for normalSuffix in NORMAL_SUFFIX_ARRAY:
					if texName.ends_with(normalSuffix):
						currentMat.normal_enabled = true
						currentMat.normal_texture = load(path)

				for metallicSuffix in METALLIC_SUFFIX_ARRAY:
					if texName.ends_with(metallicSuffix):
						currentMat.metallic_texture = load(path)

				for roughnessSuffix in ROUGHNESS_SUFFIX_ARRAY:
					if texName.ends_with(roughnessSuffix):
						currentMat.roughness_texture = load(path)
						
				for emissionSuffix in EMISSION_SUFFIX_ARRAY:
					if texName.ends_with(emissionSuffix):
						currentMat.emission_enabled = true
						currentMat.emission_texture = load(path)

			# finally, write the material to disk (happens for each texture but eh...
			ResourceSaver.save(str(matPath), currentMat)
			
		# if autoAssing == false: 
		# Just take all textures and assign them to albedo in their own, new material 
		else:
			var matPath = (workingDir + texName + ".tres")
			var dummyFile =  File.new() # why do we have to create these??! 
			#var currentMat # The loaded material instance
			
			if dummyFile.file_exists(matPath) == true:
				currentMat = load(matPath)
			else:
				#currentMat = SpatialMaterial.new()
				pass
			currentMat.albedo_texture = load(path)
			ResourceSaver.save(str(matPath), currentMat)










