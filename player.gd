extends KinematicBody2D

export(PackedScene) var spearScene

export var gravity = 400
export var jumpPower = 350
export var moveSpeed = 175

export var dashDistance = 150 
#this needs to be adapted to dash time because it ends based on time so the dash ends consistently but interpolating to a "desired" point still results in the best feeling movement

var isDashing = false
var canDash = true
var dashStart = 0

func _ready():
	pass #leaving this in event of player needing init code

var vec = Vector2.ZERO

func _process(delta):
	if Input.is_action_just_pressed("mouseLeft"):
		call_deferred("throwSpear")

func _physics_process(delta):
	print(vec.y)
	
	$hud/debugInf.text = String(self.position)
	
	if !is_on_floor():
		vec.y += delta * gravity 
	else:
		vec.y = 1
	
	if is_on_ceiling():
		vec.y = 25
	
	vec.y = clamp(vec.y, -10000, 600)
	vec.x = 0
	
	if Input.is_action_just_pressed("dash"):
		if !isDashing && canDash:
			isDashing = true
			$timer.start()
			dashStart = self.position.x
	if Input.is_action_pressed("moveDown"):
		pass #for slam or crouch if needed
	if Input.is_action_just_pressed("jump") && is_on_floor():
		vec.y = -jumpPower
	if Input.is_action_pressed("moveLeft") && !isDashing:
		vec.x += -moveSpeed
	if Input.is_action_pressed("moveRight") && !isDashing:
		vec.x += moveSpeed
	
	if vec.x < 0: #code to flip the sprite based on movement direction
		$Sprite.flip_h = true
	elif vec.x > 0:
		$Sprite.flip_h = false
	
	if isDashing:
		
		var space_state = get_world_2d().direct_space_state
		var result
		
		if $Sprite.flip_h:
			if(space_state.intersect_ray(position, Vector2(position.x - 11, position.y + 28), [self]).size() > 0):
				dashEnd()
			else:
				self.position.x = lerp(self.position.x, (dashStart - dashDistance), 0.1)
		else:
			if(space_state.intersect_ray(position, Vector2(position.x - 11, position.y - 28), [self]).size() > 0):
				dashEnd()
			else:
				self.position.x = lerp(self.position.x, (dashStart + dashDistance), 0.1)
			
	move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, true, 4, deg2rad(45), true)

func _on_Timer_timeout():
	dashEnd()

func _on_dashCooldown_timeout():
	canDash = true

func dashEnd():
	isDashing = false
	canDash = false
	$timer.stop()
	$dashCooldown.start()
	
func throwSpear():
	var spear = spearScene.instance()
	spear.start(get_local_mouse_position(), position)
	get_tree().get_root().add_child(spear)
