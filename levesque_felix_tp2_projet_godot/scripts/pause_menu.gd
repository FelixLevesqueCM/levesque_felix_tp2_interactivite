extends Control

@onready var game = $"../../../"

func _on_resume_pressed() -> void:
	game.pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().quit()
