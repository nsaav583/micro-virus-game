extends Control

@export_file("*.tscn") var game_scene_path: String

func _on_play_button_pressed() -> void:
	if game_scene_path == "":
		push_warning("No se ha asignado la escena del juego en el inspector.")
		return
	get_tree().change_scene_to_file(game_scene_path)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
