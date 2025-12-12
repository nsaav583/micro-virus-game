extends Control

@export_file("*.tscn") var game_scene_path: String
@export_file("*.tscn") var menu_scene_path: String


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene_path)
