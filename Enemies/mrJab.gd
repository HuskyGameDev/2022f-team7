extends "res://Enemies/baseEnemy.gd"

# Declare member variables here. Examples:
export (PackedScene) var particles

var aiming = false
var aimed = false
var attacking = false
var speed = 200
var angle
var direction
var attackDirection
var aimSpeed = 0.02
var lerpAngle
var result
var playerBody

var returnVec = Vector2.ZERO

#boilerplate methods
func _ready():
	pass
	#rotation = -2*PI

#enemy mode override (called under physics process)
func customMode(delta):
	if(playerBody != null && playerBody.is_in_group("player")):
		result = get_world_2d().direct_space_state.intersect_ray(global_position, playerBody.global_position, [self, playerBody], collision_mask)
		if result.size() == 0:
			_onStartEnter(playerBody)
	if(aiming): rotateSpike()
	if(attacking): 
		returnVec = move_and_slide(attackDirection * speed)
		if(returnVec.length() < 50): #if going too slow
			_onTipHit(null)
	.customMode(delta)

func _onStartEnter(body):
	._onStartEnter(body)
	playerBody = body
	result = get_world_2d().direct_space_state.intersect_ray(global_position, playerBody.global_position, [self, playerBody], collision_mask)
	print(body.is_in_group("player"))
	print(result.size())
	print(!aimed)
	if aiming || aimed: return
	if(body.is_in_group("player") && result.size() == 0 && $VisibilityNotifier2D.is_on_screen()):
		$VisibilityNotifier2D.queue_free()
		$AimTimer.start()
		aiming = true
		$AnimatedSprite.animation = "alert"
		$AnimatedSprite.playing = true
		set_collision_layer_bit(4, true)

#signals
func _onAimEnd():
	aiming = false
	aimed = true
	$AttackDelay.start()

func _onTargetDelayEnd():
	attacking = true
	attackDirection = get_global_position().direction_to(direction).normalized()
	$touchBox.set_collision_mask_bit(1, true)
	$AnimatedSprite.animation = "fly"

func _onTipHit(body):
	if(attacking):
		var p = particles.instance()
		p.transform = transform
		get_parent().add_child(p)
		p.emitting = true;
		queue_free()

func _on_hitbox_area_entered(area):
	if(attacking || aiming || aimed):
		._on_hitbox_area_entered(area)

#helper methods
func rotateSpike():
	direction = Vector2($"../player".get_global_position().x, $"../player".get_global_position().y) # Get player location
	angle = get_global_position().angle_to_point(direction) + (3.0/2.0)*PI # Get angle to point toward player
	# Adjust rotation/angle so that it doesn't rotate the long way around
	if abs(rotation - angle) >= PI && rotation != 0:
		if rotation > angle:
			rotation = (fposmod(rotation + PI, 2.0*PI) - PI) 
		else:
			angle = (fposmod(angle + PI, 2.0*PI) - PI) 
	# Set rotation
	if(rotation > angle + aimSpeed): rotation -= aimSpeed
	if(rotation < angle - aimSpeed): rotation += aimSpeed
	$Light2D.global_rotation = 0
