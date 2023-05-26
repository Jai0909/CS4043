extends CanvasLayer

signal start_game
signal infoSignal

func _ready():
	$backButton.hide() #hides back button used in menu screen

func _on_StartButton_button_down(): #hides all visible buttons and starts game
	$StartButton.hide() 
	$InfoButton.hide()
	emit_signal("start_game")



func _on_InfoButton_button_down(): #hides visible buttons and enables back button and emits signal that shows the info screen
	$StartButton.hide()
	$InfoButton.hide()
	$backButton.show()
	emit_signal("infoSignal")


func _on_backButton_button_down(): #sends you back to the home screen
	get_tree().reload_current_scene()
