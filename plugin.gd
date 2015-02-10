tool
extends EditorPlugin

var importer

func get_name():
	return "TileSet Importer"

func _enter_tree():
	var editor = get_node("/root/EditorNode")
	var Importer = preload("importer.gd")
	importer = Importer.new(editor)
	editor.add_editor_import_plugin(importer)

func _exit_tree():
	button.free()
	button = null

	var editor = get_node("/root/EditorNode")
	editor.remove_editor_import_plugin(importer)
	importer = null
