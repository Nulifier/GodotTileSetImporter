tool
extends ConfirmationDialog

var plugin
var textureDialog
var destinationDialog
var errorDialog

# Display the source select FileDialog
func _browse_source():
	if !textureDialog:
		textureDialog = get_node("TextureDialog")
		textureDialog.set_mode(FileDialog.MODE_OPEN_FILE)
		textureDialog.set_access(FileDialog.ACCESS_RESOURCES)
		for ext in ResourceLoader.get_recognized_extensions_for_type("Texture"):
			textureDialog.add_filter("*." + ext + " ; " + ext.to_upper())
	textureDialog.popup_centered_ratio()

# Display the target select FileDialog
func _browse_target():
	if !destinationDialog:
		destinationDialog = get_node("DestinationDialog")
		destinationDialog.set_mode(FileDialog.MODE_SAVE_FILE)
		destinationDialog.set_access(FileDialog.ACCESS_RESOURCES)
		for ext in ResourceSaver.get_recognized_extensions("TileSet"):
			destinationDialog.add_filter("*." + ext + " ; " + ext.to_upper())
	destinationDialog.popup_centered_ratio()

func _choose_source( path ):
	var source_box = get_node("TabContainer/Single Texture/Source/LineEdit")
	source_box.set_text(path)

func _choose_target( path ):
	var target_box = get_node("TabContainer/Single Texture/Target/LineEdit")
	target_box.set_text(path)

func _import():
	assert(plugin)
	
	# Get the data
	var sourcePath = get_node("TabContainer/Single Texture/Source/LineEdit").get_text()
	var targetPath = get_node("TabContainer/Single Texture/Target/LineEdit").get_text()
	var tileWidth = get_node("TabContainer/Single Texture/Properties/Tile Width/Value").get_value()
	var tileHeight = get_node("TabContainer/Single Texture/Properties/Tile Height/Value").get_value()
	var tileSpacing = get_node("TabContainer/Single Texture/Properties/Tile Spacing/Value").get_value()
	var tilePadding = get_node("TabContainer/Single Texture/Properties/Tile Padding/Value").get_value()
	
	# Validate the data
	if sourcePath.empty():
		showError("Please specify a source file");
		return
	
	if targetPath.empty():
		showError("Please specify a target");
		return
	
	# Store the data
	var metadata = ResourceImportMetadata.new()
	metadata.add_source(sourcePath)
	metadata.set_option("tileWidth", tileWidth)
	metadata.set_option("tileHeight", tileHeight)
	metadata.set_option("tileSpacing", tileSpacing)
	metadata.set_option("tilePadding", tilePadding)
	
	# Import the resource
	plugin.import(targetPath, metadata)
	
	hide()

func showError(message):
	if !errorDialog:
		errorDialog = get_node("ErrorDialog")
		errorDialog.set_title("Error")
	errorDialog.set_text(message)
	errorDialog.popup_centered(Size2(200, 100))
