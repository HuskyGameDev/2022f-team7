extends KinematicBody2D

export(PackedScene) var spearScene
export(PackedScene) var spearMeleeScene

#player movement constants
const gravity   = 2.5
const jumpPower = 180
const moveSpeed = 50
const dashSpeed = 1000
const jumpDecay = 0.97
const springPower = 400
#player's default/max health
const health    = 3
var invincible

#player state and movement trackers
var isDashing = false
var canDash = true
var tarvec = 0 #target movement direction of player -1 left 1 right 0 none
var vec = Vector2.ZERO #vector movement applied to player
var hasSpear = true
var usingSpear = false
var current_HP = 0
var usedSpring = false
var spearState = 0; # Whether the spear is normal (0), red (1), yellow (2), or blue (3)
var maxSpearState = 3;

var isHurt = false
var isWalking = false
var isJumping = false
var isDying = false

#creates a signal for when the player health changes
signal health_changed(player_hearts)
signal spear_changed(usable)

#starts the current health of the player
func _ready():
	invincible = false
	set_spear_state(spearState);
	set_collision_layer_bit(2, true)
	current_HP = health
	emit_signal("health_changed", current_HP)
	$healthUpBox/Collider.set_deferred("disabled", true)

func processInput():
	tarvec = 0
	#deny input if player is dying/dead
	if isDying:
		return
	
	
	#spear throw handler (async so any lag of spear spawning isn't affecting player movement)
	if !usingSpear && hasSpear && Input.is_action_just_pressed("mouseRight"):
		usingSpear = true
		call_deferred("throwSpear")
	
	if !usingSpear && hasSpear && Input.is_action_just_pressed("mouseLeft"):
		usingSpear = true
		call_deferred("attackSpear")
	
	if(!usingSpear && hasSpear && Input.is_action_just_pressed("switch_spear")):
		switch_spear_state();
	
	#starts dashing state if possible and starts dash cooldown, as well as
	#cranking camera smoothing so player doesn't launch out of view
	if Input.is_action_just_pressed("dash"):
		if !isDashing && canDash:
			isDashing = true
			$dashTime.start()
			$Camera2D.smoothing_speed = 7
	#apply jump upward vecocity if possible
	if Input.is_action_just_pressed("jump") && is_on_floor() && !isDashing:
		vec.y = -jumpPower
		isJumping = true
	
	#apply left/right target direction and reset vecocity of player if changing direction to
	#make movement snappy but smooth
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
	
	processInput()
	
	processMisc()
	
	processMovement(delta)
	
	processGravity(delta)
	
	processState()

func processState():
	if isDying:
		set_collision_layer_bit(2, false)
		$Sprite.animation = "Death"
		$Sprite/Spear.visible = false
		$Sprite.playing = true
	elif isDashing:
		$Sprite.animation = "Strafe"  + ("Hurt" if isHurt else "")
		$Sprite.playing = false
		$Sprite.frame = 1
	elif isJumping:
		$Sprite.animation = "Jump"  + ("Hurt" if isHurt else "")
		$Sprite.playing = true
	elif isWalking:
		$Sprite.animation = "Walk"  + ("Hurt" if isHurt else "")
		$Sprite.playing = true
	else:
		$Sprite.animation = "Look"  + ("Hurt" if isHurt else "")
		$Sprite.playing = true

#process player movement
func processMovement(delta):
	#cap player vertical and horizontal vecocity so player has terminal vecocity
	vec.y = clamp(vec.y, -10000, 600)
	vec.x = clamp(vec.x, -1500, 1500)
	
	#dash block overrides normal player movement
	if isDashing:
		#end dash if vecocity is too slow with minimum time left
		var elapsed = $dashTime.wait_time - $dashTime.time_left
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
			
			
	if(usedSpring):
		usedSpring = false
		isJumping = true
		vec.y = -springPower
		
	# If the player releases the jump button mid-jump, cut vertical velocity
	if(!isDashing && vec.y < 0 && !Input.is_action_pressed("jump")):
		vec.y *= jumpDecay
	
	#clamp velocity if not actively dashing
	if !isDashing:
		vec.x = clamp(vec.x, -moveSpeed, moveSpeed)
	
	
	
	#apply calculated properties to body and store result in vec
	vec = move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, true, 4, deg2rad(46), true)
	isWalking = (vec.x != 0) && is_on_floor()

#process behaviour of gravity on player
func processGravity(var delta):
	#apply gravity effects
	if !is_on_floor() && !isDashing:
		vec.y += gravity 
	else:
		if (isDashing):
			vec.y = 0 #prevents dashes from launching you if you're on a slope
		isJumping = false
		
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
		$Sprite/Spear.flip_h = true
		$Sprite/Spear.rotation_degrees = -11.5
	elif tarvec > 0:
		$Sprite.flip_h = false
		$Sprite/Spear.flip_h = false
		$Sprite/Spear.rotation_degrees = 11.5
	
	#prevent sprite snapping being different from world, only a visual issue so only applied to sprite
	#$Sprite.global_position.x = stepify(global_position.x, .5)
	#$Sprite.global_position.y = stepify(global_position.y + 1, .5)

#spear bobbing effect
func spearBob():
	if hasSpear:
		return
		#move across parabola around player back and forth
		#gonna be in desmos hell for a hot sec

# Dash Stuff

func _on_dashTime_timeout():
	dashEnd()

func _on_dashCooldown_timeout():
	canDash = true

func dashEnd():
	isDashing = false
	canDash = false
	$Camera2D.smoothing_speed = 3
	$dashTime.stop()
	$dashCooldown.start()

# Spear Stuff

# Creates and "throws" a new instance of the spear
func throwSpear():
	hasSpear = false
	$Sprite/Spear.visible = false
	emit_signal("spear_changed", hasSpear)
	var spear = spearScene.instance()
	get_parent().add_child(spear)
	spear.start(get_local_mouse_position(), position, vec, spearState)
	spear.connect("spear_collected", self, "_collect_spear")
	usingSpear = false

# Creates an instance of the melee attack version of the spear
func attackSpear():
	$Sprite/Spear.visible = false
	emit_signal("spear_changed", hasSpear)
	var spear = spearMeleeScene.instance()
	spear.start(get_local_mouse_position(), spearState)
	add_child(spear);
	spear.connect("spear_attack_ended", self, "_collect_spear")

# Returns the spear to the player
func _collect_spear():
	if(usingSpear):
		usingSpear = false;
	else:
		$spearCooldown.start()
	$Sprite/Spear.visible = true

# Cooldown between picking up the spear and being able to throw it.
# Prevents the spear from being thrown again immediately upon pickup
func _on_spearCooldown_timeout():
	hasSpear = true
	emit_signal("spear_changed", hasSpear)
	$spearCooldown.stop()

#for the blinking of the player
func _on_BlinkDur_timeout() -> void:
	$Sprite.visible = !$Sprite.visible

#if hit by enemy, will add groups for different enemies and spikes and other various things in the future
func _on_hitbox_area_entered(area):
	#if the hit by a traditional enemy
	if(area.is_in_group("enemy") && $InvilCooldown.time_left == 0):
		#stop watching for hurtbox collisions
		$hurtbox/Collider.set_deferred("disabled", true)
		current_HP -= 1
		print(current_HP)
		emit_signal("health_changed", current_HP)
		if(current_HP <= 0):
			isDying = true
			$playerDeathSound.play()
			self.modulate="353535"
			$Light2D.visible=false
			return
		$InvilCooldown.start()
		$BlinkDur.start()
		isHurt = true
	if(current_HP < 3):
		$healthUpBox/Collider.set_deferred("disabled", false)
#for the invil frames when getting hit
func _on_InvilCooldown_timeout():
	if(current_HP > 0):
		$hurtbox/Collider.set_deferred("disabled", false)
		$BlinkDur.stop()
		$Sprite.visible = true
		isHurt = false

func switch_spear_state():
	spearState = spearState + 1;
	if(spearState > maxSpearState): spearState = 0;
	print("current spear state: " + str(spearState));
	set_spear_color();

func set_spear_state(var s):
	spearState = s;
	if(spearState >= maxSpearState): spearState = 0;
	print("current spear state: " + str(spearState));
	set_spear_color();

func set_spear_color():
	if(spearState == 0):
		$Sprite/Spear.modulate = Color(1, 1, 1);
		$Camera2D/hud/health/spear.modulate = Color(1, 1, 1);
	elif(spearState == 1):
		$Sprite/Spear.modulate = Color(0.83, 0.38, 0.38);
		$Camera2D/hud/health/spear.modulate = Color(0.83, 0.38, 0.38);
	elif(spearState == 2):
		$Sprite/Spear.modulate = Color(0.92, 0.92, 0.15);
		$Camera2D/hud/health/spear.modulate = Color(0.92, 0.92, 0.15);
	elif(spearState == 3):
		$Sprite/Spear.modulate = Color(0.41, 0.41, 1.0);
		$Camera2D/hud/health/spear.modulate = Color(0.41, 0.41, 1.0);


func _on_springHitBox_area_entered(area):
		if(area.is_in_group("spring")):
			usedSpring = true 


func _on_healthUpBox_area_entered(area):
	if(area.is_in_group("healthUp") && current_HP < 3):
		current_HP += 1
		print(current_HP)
		emit_signal("health_changed", current_HP)
	if(current_HP >= 3):
		$healthUpBox/Collider.set_deferred("disabled", true)
