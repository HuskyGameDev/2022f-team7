extends "res://Enemies/baseEnemy.gd"

var charge = false
var aiming = false
var aimed = false
var direction
var angle
var speed = 200
var aimSpeed = 0.02
var attacking = false
var attackDirection
var hit
var location
var returnCheck
var returning = false

var returnVec = Vector2.ZERO


func _onStartEnter(body):
	if(body.get_class() == "KinematicBody2D"):
		player = body
		if( !(aiming || aimed) && charge):
			engaged = false
			charge = false
			location = self.get_global_position()
			$AimTimer.start()
			aiming = true
			print("aiming peg")
		elif(!charge && !returning):
			engaged = true

	
	
func customMode(delta):
	if(engaged && player != null):
		_onStartEnter(player)
	
	if(aiming): rotatePegasus()
	
	if(attacking): 
		hit = move_and_collide(attackDirection * speed)

	if(returning):
		returnCheck = move_and_slide(attackDirection * speed)
		if(returnCheck): #if going too slow
			returning = false
	.customMode(delta)
	
	
func rotatePegasus():
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

func _on_hitbox_area_entered(area):
	._on_hitbox_area_entered(area)
	if(hit && !area.is_in_group('spear')):
		returnPosition()
	
func returnPosition():
	attackDirection = get_global_position().direction_to(location).normalized()
	returning = true
	$chargeCooldown.start()
	
func _on_chargeCooldown_timeout():
	charge = true

func _on_aimTime_timeout():
	print("aiming peg stop")
	aiming = false
	aimed = true
	$chargeUp.start()
	
func _on_chargeUp_timeout():
	attackDirection = get_global_position().direction_to(direction).normalized()
	attacking = true
	$animatedSprite.frame = engaged
	
