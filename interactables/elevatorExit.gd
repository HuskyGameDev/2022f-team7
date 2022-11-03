extends Area2D

var interacting = false;
var activePlayer;
var levelRoot;

export (String) var nextLevel;

signal interacted;
signal change_level(next_level)

func _ready():
	if get_tree().get_root().get_child(0).get_name() == "levelRoot":
		print("connecting")
		levelRoot = get_tree().get_root().get_child(0)
		connect("change_level", levelRoot, "levelTransition")
	$CanvasPrompt.hide();
	$CanvasInteractions.hide();

func _on_body_entered(body):
	print("fingers touching " + body.get_name());
	if(body.is_in_group("player")):
		activePlayer = body
		interacting = true;
		$CanvasPrompt.show();
		
func _on_body_exited(body):
	print("fingers stopped touching " + body.get_name())
	if(body.is_in_group("player")):
		activePlayer = null
		interacting = false
		$CanvasPrompt.hide()
		$CanvasInteractions.hide()
		
func _input(event):
	if event.is_action_pressed("interact"): #prevent spam in terminal
		if interacting == false:
			print("player not interacting")
			return
		if get_tree().paused == false:
			get_tree().paused = true
			$CanvasInteractions.show()
			$CanvasPrompt.hide()
			print("player is interacting")
		else:
			get_tree().paused = false
			$CanvasInteractions.hide()
			$CanvasPrompt.show()
			print("player stopped interacting")
			


func _on_No_pressed():
	get_tree().paused = false
	$CanvasInteractions.hide()
	$CanvasPrompt.show()


func _on_Yes_pressed():
	emit_signal("change_level", nextLevel)
