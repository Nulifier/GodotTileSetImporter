tool
extends EditorImportPlugin

var dialog
var editor

func _init(_editor):
	editor = _editor
	var ImporterDialog = preload("importerDialog.xscn")
	dialog = ImporterDialog.instance()
	dialog.plugin = self

func _free():
	dialog.free()

func get_name():
	return "tileSet_importer"

func get_visible_name():
	return "TileSet"

func import_dialog(from):
	if !dialog.get_parent():
		# This needs to be deferred as children can't be added during a notification (_init)
		editor.get_gui_base().add_child(dialog)
	dialog.popup_centered()

func import(targetPath, from):
	from.set_editor(get_name())

	# Get parameters
	assert(from.get_source_count() > 0)
	var sourcePath = from.get_source_path(0)
	var tileWidth = from.get_option("tileWidth")
	var tileHeight = from.get_option("tileHeight")
	var tileSpacing = from.get_option("tileSpacing")
	var tilePadding = from.get_option("tilePadding")

	# Load the texture
	var sourceTexture = load(sourcePath)
	if !(sourceTexture extends Texture):
		print("Invalid source, must be Texture.")
		return

	var textureWidth = sourceTexture.get_width()
	var textureHeight = sourceTexture.get_height()

	# Calculate the number of tiles
	var tiles_x = floor((textureWidth - 2 * tilePadding + tileSpacing) / (tileWidth + tileSpacing))
	var tiles_y = floor((textureHeight - 2 * tilePadding + tileSpacing) / (tileHeight + tileSpacing))

	# Create the TileSet
	var tiles = TileSet.new()
	for j in range(0, tiles_y):
		for i in range(0, tiles_x):
			var id = i + j * tiles_x
			tiles.create_tile(id)

			tiles.tile_set_name(id, "Tile " + str(id))
			tiles.tile_set_texture(id, sourceTexture)

			var x = tilePadding + i * (tileWidth + tileSpacing)
			var y = tilePadding + j * (tileHeight + tileSpacing)
			var region = Rect2(x, y, tileWidth, tileHeight)

			tiles.tile_set_region(id, region)

	# Save the resource
	tiles.set_import_metadata(from)
	tiles.set_path(targetPath)
	ResourceSaver.save(targetPath, tiles)
