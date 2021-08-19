tool
extends Label


func _enter_tree():
	var myFont = get_font("doc_bold", "EditorFonts")
	self.add_font_override("font", myFont)
	
