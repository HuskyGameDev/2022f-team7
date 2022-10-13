extends KinematicBody2D


# Declare member variables here. Examples:
var aiming = false
var aimed = false
var attacking = false
var speed = 200
var angle
var direction
var attackDirection
var aimSpeed = 0.02
var lerpAngle
var hit


func _ready():
	rotation = -2*PI # Necessary for rotation reasons.


func _physics_process(delta):
	#if(aiming): rotateSpike()
	if(attacking): hit = move_and_collide(attackDirection * speed * delta)
	if(hit != null && !hit.collider.is_in_group("tilemap")): queue_free()
	
func _on_StartRange_body_entered(body):
	#if(!aimed && body.is_in_group("player")):
	if(body.is_in_group("player")):
	#	$AimTimer.start()
	#	aiming = true
		$AttackDelay.start()


#func _on_AimTimer_timeout():
#	aiming = false
#	aimed = true
#	$AttackDelay.start()
	
	
#func rotateSpike():
#	direction = Vector2($"../player".get_global_position().x, $"../player".get_global_position().y) # Get player location
#	angle = get_global_position().angle_to_point(direction) + (3.0/2.0)*PI # Get angle to point toward player
	# Adjust rotation/angle so that it doesn't rotate the long way around
#	if abs(rotation - angle) >= PI && rotation != 0:
#		if rotation > angle:
#			rotation = (fposmod(rotation + PI, 2.0*PI) - PI) - (2.0 * PI)
#		else:
#			angle = (fposmod(angle + PI, 2.0*PI) - PI) - (2.0 * PI)
	# Set rotation
#	if(rotation > angle + aimSpeed): rotation -= aimSpeed
#	if(rotation < angle - aimSpeed): rotation += aimSpeed


func _on_AttackDelay_timeout():
	attacking = true
	direction = Vector2(0, -1)
	#attackDirection = get_global_position().direction_to(direction).normalized()
	attackDirection = get_global_position() - direction

func _on_Tip_body_entered(body):
	if(body.is_in_group("tilemap") && attacking): queue_free()
