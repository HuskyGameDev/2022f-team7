extends KinematicBody2D

export(PackedScene) var spearScene

#player movement constants
const gravity = 2.5
const jumpPower = 180
const moveSpeed = 50
const dashSpeed = 1000
const jumpDecay = 0.97

#player state and movement trackers
var isDashing = false
var canDash = true
var tarvec = 0 #target movement direction of player -1 left 1 right 0 none
var vec = Vector2.ZERO #vector movement applied to player
var hasSpear = true
var throwingSpear = false
var current_HP = 3

#creates a signal for when the player health changes
signal health_changed(player_hearts)

#starts the current health of the player
func _ready():
	emit_signal("health_changed", current_HP)

func _unhandled_input(_event):
	#spear throw handler (async so any lag of spear spawning isn't affecting player movement)
	if !throwingSpear && hasSpear && Input.is_action_just_pressed("mouseLeft"):
		throwingSpear = true
		call_deferred("throwSpear")
	
	tarvec = 0
	#starts dashing state if possible and starts dash cooldown, as well as cranking camera smoothing so player doesn't launch out of view
	if Input.is_action_just_pressed("dash"):
		if !isDashing && canDash:
			isDashing = true
			$timer.start()
			$Camera2D.smoothing_speed = 7
	#apply jump upward vecocity if possible
	if Input.is_action_just_pressed("jump") && is_on_floor() && !isDashing:
		vec.y = -jumpPower
	
	#apply left/right target direction and reset vecocity of player if changing direction to make movement snappy but smooth
	#doesn't apply the instance 0ing of vecocity if in air to create air strafe effect
	if Input.is_action_pressed("moveLeft") && !isDashing:
		if vec.x > 0 && is_on_floor():
			vec.x = 0
		tarvec += -1
	if Input.is_action_pressed("moveRight") && !isDashing:
		if vec.x < 0 && is_on_floor():
			vec.x = 0
		tarvec += 1

func _physics_process(delta):
	
	processMisc()
	
	processMovement(delta)
	
	processGravity(delta)

#process player movement
func processMovement(delta):
	#cap player vertical and horizontal vecocity so player has terminal vecocity
	vec.y = clamp(vec.y, -10000, 600)
	vec.x = clamp(vec.x, -1500, 1500)
	
	#dash block overrides normal player movement
	if isDashing:
		#end dash if vecocity is too slow with minimum time left
		var elapsed = $timer.wait_time - $timer.time_left
		if abs(vec.x) < 95 && (elapsed) > .05:
			dashEnd()
		
		#exponential decay function so dash has a speed dropoff before it ends
		vec.x = -dashSpeed*pow(.000000001, elapsed) if ($Sprite.flip_h) else dashSpeed*pow(.000000001, elapsed)
		
	#ramp up player velocity, reduce rampup if airborne
	elif tarvec != 0:
		vec.x += 2*tarvec if(is_on_floor()) else tarvec
	elif tarvec == 0 && vec.x != 0 && is_on_floor():
		if vec.x > 0:
			vec.x = clamp(vec.x - 2, 0, moveSpeed)
		else:
			vec.x = clamp(vec.x + 2, -moveSpeed, 0)
	
	# If the player releases the jump button mid-jump, cut vertical velocity
	if(!isDashing && vec.y < 0 && !Input.is_action_pressed("jump")):
		vec.y *= jumpDecay
	
	#clamp velocity if not actively dashing
	if !isDashing:
		vec.x = clamp(vec.x, -moveSpeed, moveSpeed)
	
	#apply calculated properties to body and store result in vec
	vec = move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, true, 4, deg2rad(45), true)

#process behaviour of gravity on player
func processGravity(var delta):
	#apply gravity effects
	if !is_on_floor() && !isDashing:
		vec.y += gravity 
	else:
		vec.y = 0 #no gravity if not falling or if dashing
		
	if is_on_ceiling(): #cancel upward movement if hitting ceiling
		vec.y = 1

#process debug text, player sound effects, and some visual effects
func processMisc():
	#set some debug text
	$Camera2D/hud/debugInf.text = String(position.round()) + "\n" + String(vec.round())
	
	#start/stop footstep audio when appropriate
	if(vec.x != 0 && is_on_floor() && !$feet.playing):
		$feet.play()
	elif($feet.playing && (vec.x == 0 || !is_on_floor())):
		$feet.stop()
	
	#flip sprite based on intended direction, might be changed to actual movement direction
	if tarvec < 0:
		$Sprite.flip_h = true
	elif tarvec > 0:
		$Sprite.flip_h = false
	
	#prevent sprite snapping being different from world, only a visual issue so only applied to sprite
	$Sprite.global_position.x = stepify(global_position.x, .5)
	$Sprite.global_position.y = stepify(global_position.y + 1, .5)

# Dash Stuff

func _on_Timer_timeout():
	dashEnd()

func _on_dashCooldown_timeout():
	canDash = true

func dashEnd():
	isDashing = false
	canDash = false
	$Camera2D.smoothing_speed = 3
	$timer.stop()
	$dashCooldown.start()

# Spear Stuff

# Creates and "throws" a new instance of the spear
func throwSpear():
	hasSpear = false
	var spear = spearScene.instance()
	spear.start(get_local_mouse_position(), position, vec)
	get_parent().add_child(spear)
	spear.connect("spear_collected", self, "_collect_spear")
	throwingSpear = false

# Returns the spear to the player
func _collect_spear():
	$spearCooldown.start()

# Cooldown between picking up the spear and being able to throw it.
# Prevents the spear from being thrown again immediately upon pickup
func _on_spearCooldown_timeout():
	hasSpear = true
	$spearCooldown.stop()

#for the blinking of the player
func _on_BlinkDur_timeout() -> void:
	self.visible = !self.visible


#if hit by enemy, will add groups for different enemies and spikes and other various things in the future
func _on_hitbox_area_entered(area):
	#if the hit by a traditional enemy
	if(area.is_in_group("enemy")):
		get_node("hitbox/CollisionShape2D2").set_deferred("disabled", true) 
		current_HP = current_HP - 1
		print(current_HP)
		emit_signal("health_changed", current_HP)
		if(current_HP <= 0):
			return
		$InvilCooldown.start()
		$BlinkDur.start()
		
		
	

#for the invil frames when getting hit
func _on_InvilCooldown_timeout():
	if(current_HP > 0):
		get_node("hitbox/CollisionShape2D2").set_deferred("disabled", false) 
		$BlinkDur.stop()
		self.visible = true

