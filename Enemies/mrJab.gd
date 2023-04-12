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

#enemy mode override (called under physics process)
func customMode(delta):
	
	if(engaged && playerBody != null && lineOfSight(playerBody)):
		_onStartEnter(playerBody)
	
	if(aiming): rotateSpike()
	
	if(attacking): 
		returnVec = move_and_slide(attackDirection * speed)
		if(returnVec.length() < 50): #if going too slow
			_onTipHit(null)
	
	.customMode(delta)

#signals

func _onStartEnter(body):
	._onStartEnter(body)#super call
	
	playerBody = body
	
	if( !(aiming || aimed) && lineOfSight(body) ):
		print("locking on!")
		alertSpike()
	else:
		print("no lock, waiting for lock")

func _onStopExit(body):
	._onStopExit(body)#super call
	print("stopping lockon")

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
		if($DeathSound != null):
			$DeathSound.playing = true;
			var ds = $DeathSound;
			remove_child(ds)
			get_parent().add_child(ds)
			ds.transform = transform;
		var p = particles.instance()
		p.transform = transform
		get_parent().add_child(p)
		p.emitting = true;
		queue_free()

func _on_hitbox_area_entered(area):
	if(attacking || aiming || aimed):
		._on_hitbox_area_entered(area)

#helper methods

func lineOfSight(var body:Node2D):
	if (aiming || aimed): return
	result = get_world_2d().direct_space_state.intersect_ray($losCast.global_position, playerBody.global_position, [self, playerBody], collision_mask)
	return result.size() == 0 && $VisibilityNotifier2D.is_on_screen()

func alertSpike():
	engaged = false
	$startRange.set_deferred("monitoring", false)
	$stopRange.set_deferred("monitoring", false)
	$VisibilityNotifier2D.queue_free() #no need for this
	
	aiming = true
	$AimTimer.start()
	
	$AnimatedSprite.animation = "alert"
	$AnimatedSprite.playing = true
	set_collision_layer_bit(4, true)

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
