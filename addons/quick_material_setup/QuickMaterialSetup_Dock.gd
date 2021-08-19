tool
extends Control


const SCALE_SUFFIX_ARRAY = ["_1k", "_2k", "_3k", "_4k", "_6k", "_8k"]

const ALBEDO_SUFFIX_ARRAY = ["_color", "_colour", "_col", "_diffuse", "_diff", "_albedo", "_base", "_basecolor", "_baseColor"]
const NORMAL_SUFFIX_ARRAY = ["_normal", "_nor", "_nrm", "_norm", "_n", "_bump", "_bmp"]
const METALLIC_SUFFIX_ARRAY = ["_metallic", "_metalness", "_metal", "_mtl"]
const ROUGHNESS_SUFFIX_ARRAY = ["_roughness", "_rough", "_rgh", "_gloss", "_glossy", "_glossiness"]
const EMISSION_SUFFIX_ARRAY = ["_emission","_emissive", "_em"]
const AO_SUFFIX_ARRAY = ["_ao", "_occlusion", "_ambientocclusion"]

export(NodePath) var templatePathArea
export(NodePath) var useTemplateButton
export(NodePath) var colorChannelArea
export(NodePath) var useColorChannelsCheckbox
export(NodePath) var useColorChannelsArea
export(NodePath) var autoAssignCheckbox
export(NodePath) var autoAssignArea

var currentResourcePaths
var autoAssing = true
var useTemplateMat = false
var templateMatPath
var useColorChannels = false

export(NodePath) var ao_suffixPath
export(NodePath) var ao_channnelPath
export(NodePath) var roughness_suffixPath
export(NodePath) var roughness_channelPath
export(NodePath) var metallic_suffixPath
export(NodePath) var metallic_channelPath

#	Todo: Make channel variables pull actual values

#	Hide/Show UI elements based on their assigned toggle button
func _enter_tree():

	get_node(templatePathArea).set_visible(get_node(useTemplateButton).is_pressed())
	useTemplateMat = get_node(useTemplateButton).is_pressed()
	
	get_node(colorChannelArea).set_visible(get_node(useColorChannelsCheckbox).is_pressed())
	useColorChannels = get_node(useColorChannelsCheckbox).is_pressed()

	get_node(useColorChannelsArea).set_visible(get_node(autoAssignCheckbox).is_pressed())
	autoAssing = get_node(autoAssignCheckbox).is_pressed()

func _on_UseTemplate_Button_toggled(button_pressed):
	get_node(templatePathArea).set_visible(get_node(useTemplateButton).is_pressed())
	useTemplateMat = button_pressed
	print("useTemplateMat -> ", button_pressed)
	

func _on_AutoAssign_Checkbox_toggled(button_pressed):
	get_node(useColorChannelsArea).set_visible(button_pressed)
	autoAssing = button_pressed
	print("autoAssign -> ", button_pressed)
	

func _on_UseColorChannel_Checkbox_toggled(button_pressed):
	get_node(colorChannelArea).set_visible(get_node(useColorChannelsCheckbox).is_pressed())
	useColorChannels = button_pressed
	print("useColorChannels -> ", button_pressed)



func _on_Create_pressed():
	
	var ao_suffix = get_node(ao_suffixPath).text
	var ao_channnel = get_node(ao_channnelPath).selected
	var roughness_suffix = get_node(roughness_suffixPath).text
	var roughness_channel = get_node(roughness_channelPath).selected
	var metallic_suffix = get_node(metallic_suffixPath).text
	var metallic_channel = get_node(metallic_channelPath).selected
	
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
		
		# make the name lowercase
		texName = texName.to_lower()

		
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


			var skipMatching = false
			
			if useColorChannels == true:
			
				if texName.ends_with(ao_suffix):
					
					var matName = texName.trim_suffix(ao_suffix)
					var matPath = (workingDir + matName + ".tres")
					
					var dummyFile =  File.new() 
					if dummyFile.file_exists(matPath) == true:
						currentMat = load(matPath)
						
					skipMatching = true
					
					currentMat.ao_enabled = true
					currentMat.ao_texture = load(path)
					currentMat.ao_texture_channel = ao_channnel
					
					ResourceSaver.save(str(matPath), currentMat)
					
					
					
				if texName.ends_with(roughness_suffix):
					
					var matName = texName.trim_suffix(roughness_suffix)
					var matPath = (workingDir + matName + ".tres")
					
					var dummyFile =  File.new() 
					if dummyFile.file_exists(matPath) == true:
						currentMat = load(matPath)
						
					skipMatching = true
					
					currentMat.roughness_texture = load(path)
					currentMat.roughness_texture_channel = roughness_channel
					
					ResourceSaver.save(str(matPath), currentMat)

				if texName.ends_with(metallic_suffix):

					var matName = texName.trim_suffix(metallic_suffix)
					var matPath = (workingDir + matName + ".tres")
					
					var dummyFile =  File.new() 
					if dummyFile.file_exists(matPath) == true:
						currentMat = load(matPath)
						
					skipMatching = true
					
					currentMat.metallic_texture = load(path)
					currentMat.metallic_texture_channel = metallic_channel
					
					ResourceSaver.save(str(matPath), currentMat)
			
			# If this texture has just been assigned to a channel, skip this part
			if skipMatching == false:
			
				# just an array containing all suffixes
				var suffixMaster = []
				suffixMaster.append_array(ALBEDO_SUFFIX_ARRAY)
				suffixMaster.append_array(NORMAL_SUFFIX_ARRAY)
				suffixMaster.append_array(METALLIC_SUFFIX_ARRAY)
				suffixMaster.append_array(ROUGHNESS_SUFFIX_ARRAY)
				suffixMaster.append_array(EMISSION_SUFFIX_ARRAY)
				suffixMaster.append_array(AO_SUFFIX_ARRAY)
			
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

				# Load the existing material, if it can be found
				if dummyFile.file_exists(matPath) == true:
					currentMat = load(matPath)

				
	#			if useColorChannels == true:
	#				if 
					
			
				# Either directly assign it to albedo, or assign it based on the suffix in texName
				if useAsAlbedo == true:
					currentMat.albedo_texture = load(path)
					print("no suffix found, using ", path, " as albedo")
					
				else:
					for albedoSuffix in ALBEDO_SUFFIX_ARRAY:
						if texName.ends_with(albedoSuffix):
							currentMat.albedo_texture = load(path)
							print(texName, " identified as albedo texture")

					for normalSuffix in NORMAL_SUFFIX_ARRAY:
						if texName.ends_with(normalSuffix):
							currentMat.normal_enabled = true
							currentMat.normal_texture = load(path)
							print(texName, " identified as normal map")

					for metallicSuffix in METALLIC_SUFFIX_ARRAY:
						if texName.ends_with(metallicSuffix):
							currentMat.metallic_texture = load(path)
							print(texName, " identified as metallic map")

					for roughnessSuffix in ROUGHNESS_SUFFIX_ARRAY:
						if texName.ends_with(roughnessSuffix):
							currentMat.roughness_texture = load(path)
							print(texName, " identified as roughness map")
							
					for emissionSuffix in EMISSION_SUFFIX_ARRAY:
						if texName.ends_with(emissionSuffix):
							currentMat.emission_enabled = true
							currentMat.emission_texture = load(path)
							print(texName, " identified as emission texture")
					
					for aoSuffix in AO_SUFFIX_ARRAY:
						if texName.ends_with(aoSuffix):
							currentMat.ao_enabled = true
							currentMat.ao_texture = load(path)
							print(texName, " identified as AO map")
					

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
