extends KinematicBody2D

export(PackedScene) var spearScene

const gravity = 200
const jumpPower = 150
const moveSpeed = 50
const dashSpeed = 1000


var isDashing = false
var canDash = true
var vec = Vector2.ZERO
var vel = Vector2.ZERO

func _unhandled_input(event):
	if Input.is_action_just_pressed("mouseLeft"):
		call_deferred("throwSpear")
	
	vec.x = 0
	if Input.is_action_just_pressed("dash"):
		if !isDashing && canDash:
			isDashing = true
			$timer.start()
	if Input.is_action_pressed("moveDown"):
		pass #for slam or crouch if needed
	if Input.is_action_just_pressed("jump") && is_on_floor() && !isDashing:
		vec.y = -jumpPower
	if Input.is_action_pressed("moveLeft") && !isDashing:
		vec.x += -moveSpeed
	if Input.is_action_pressed("moveRight") && !isDashing:
		vec.x += moveSpeed
	
	if(vec.x != 0 && is_on_floor() && !$feet.playing):
		$feet.play()
	elif(vec.x == 0 && $feet.playing):
		$feet.stop()

func _physics_process(delta):
	
	$Camera2D/hud/debugInf.text = String(self.position) + "\n" + String(vel)
	
	
	vec.y = clamp(vec.y, -10000, 600)
	
	if vec.x < 0: #code to flip the sprite based on movement direction
		$Sprite.flip_h = true
	elif vec.x > 0:
		$Sprite.flip_h = false
	
	if isDashing:
		vec.y = 0
		if abs(vel.x) < 95 && ($timer.wait_time - $timer.time_left) > .05:
			dashEnd()
			print("end")
		if $Sprite.flip_h:
			vec.x = -dashSpeed*pow(.000000001, $timer.wait_time - $timer.time_left)
		else:
			vec.x = dashSpeed*pow(.000000001, $timer.wait_time - $timer.time_left)
	
	vel = move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, true, 4, deg2rad(45), true)
	
	if !is_on_floor():
		vec.y += delta * gravity 
	else:
		vec.y = 0
	
	if is_on_ceiling():
		vec.y = 25
	
	position.x = round(position.x)
	position.y = round(position.y)
	
	#$Camera2D.position.x = round($Camera2D.position.x)
	#$Camera2D.position.y = round($Camera2D.position.y)

func _on_Timer_timeout():
	dashEnd()

func _on_dashCooldown_timeout():
	canDash = true

func dashEnd():
	isDashing = false
	canDash = false
	vec.x = 0
	$timer.stop()
	$dashCooldown.start()
	
func throwSpear():
	var spear = spearScene.instance()
	spear.start(get_local_mouse_position(), position)
	get_tree().get_root().add_child(spear)
