extends KinematicBody2D

export(PackedScene) var spearScene

const gravity = 200
const jumpPower = 150
const moveSpeed = 50
const dashSpeed = 1000


var isDashing = false
var canDash = true
var tarvec = 0
var vec = Vector2.ZERO
var vel = Vector2.ZERO

var current_HP: int = 3

#creates a signal when the player health changes
signal health_changed(player_hearts)

#starts the current health of the player
func _ready() -> void:
	connect("health_changed", get_node("Camera2D/hud/health/hearts"), "on_player_health_changed")
	emit_signal("heath_changed", current_HP)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("mouseLeft"):
		call_deferred("throwSpear")
	
	tarvec = 0
	if Input.is_action_just_pressed("dash"):
		if !isDashing && canDash:
			isDashing = true
			$timer.start()
			$Camera2D.smoothing_speed = 7
	if Input.is_action_pressed("moveDown"):
		pass #for slam or crouch if needed
	if Input.is_action_just_pressed("jump") && is_on_floor() && !isDashing:
		vec.y = -jumpPower
	if Input.is_action_pressed("moveLeft") && !isDashing:
		if vel.x > 0:
			vel.x = 0
		tarvec += -1
	if Input.is_action_pressed("moveRight") && !isDashing:
		if vel.x < 0:
			vel.x = 0
		tarvec += 1

func _physics_process(delta):
	$Camera2D/hud/debugInf.text = String(position) + "\n" + String(vel)
	if(vel.x != 0 && is_on_floor() && !$feet.playing):
		$feet.play()
	elif($feet.playing && (vel.x == 0 || !is_on_floor())):
		$feet.stop()
	
	vec.y = clamp(vec.y, -10000, 600)
	
	if tarvec < 0: #code to flip the sprite based on movement direction
		$Sprite.flip_h = true
	elif tarvec > 0:
		$Sprite.flip_h = false
	
	if isDashing:
		vec.y = 0
		if abs(vel.x) < 95 && ($timer.wait_time - $timer.time_left) > .05:
			dashEnd()
		if $Sprite.flip_h:
			vec.x = -dashSpeed*pow(.000000001, $timer.wait_time - $timer.time_left)
		else:
			vec.x = dashSpeed*pow(.000000001, $timer.wait_time - $timer.time_left)
	elif tarvec != 0:
		vel.x += 2 * tarvec
		vel.x = clamp(vel.x, -moveSpeed, moveSpeed)
	elif tarvec == 0 && vel.x != 0:
		if vel.x > 0:
			vel.x = clamp(vel.x - 2, 0, 50)
		else:
			vel.x = clamp(vel.x + 2, -50, 0)
	if !isDashing:
		vec.x = vel.x
	
	vel = move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, true, 4, deg2rad(45), true)
	
	if !is_on_floor():
		vec.y += delta * gravity 
	else:
		vec.y = 0
	
	if is_on_ceiling():
		vec.y = 25
	
	#$Sprite.global_position = global_position.snapped(Vector2.ONE * .5)
	$Camera2D.global_position.x = stepify(global_position.x, .5)
	$Camera2D.global_position.y = stepify(global_position.y, .5)
	
	$Sprite.global_position.x = stepify(global_position.x, .5)
	$Sprite.global_position.y = stepify(global_position.y + 1, .5)
	
# when the enemy hits the player
func _on_hit_Enemy():
	current_HP = current_HP - 1
	emit_signal("health_changed", current_HP)
	if current_HP <= 0:
		visible = false
		print("gameover") #place holder until we create a death system
		
	
func _on_Timer_timeout():
	dashEnd()

func _on_dashCooldown_timeout():
	canDash = true

func dashEnd():
	isDashing = false
	canDash = false
	vec.x = 0
	$Camera2D.smoothing_speed = 3
	$timer.stop()
	$dashCooldown.start()
	
func throwSpear():
	var spear = spearScene.instance()
	spear.start(get_local_mouse_position(), position)
	get_tree().get_root().add_child(spear)
