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
var returning

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _physics_process(delta):
	match(mode):
		0:
			var playerPos = $"../player".get_global_position() - self.global_position
			if engaged:
				if playerPos.length < 1:
					pass
				else:
					vec = (position - player.position).normalized()
					vec *= -0.2
					move_and_collide(vec, false)
		1:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * railSpeed)
		2:
			pass #have not finished yet, no enemies use it either
		3:
			customMode(delta)

func _onStartEnter(body):
	._onStartEnter(body)
	if(!aimed && body.is_in_group("player") && charge):
		charge = false
		location = self.get_global_position()
		$AimTimer.start()
		aiming = true
		
	
	
func custom(delta):
	if(aiming): rotatePegasus()
	if(attacking): hit = move_and_collide(attackDirection * speed)
	if(returning): position = position.move_toward(location, speed*delta)
	.customMode(delta)
	
	
func rotatePegasus():
	direction = Vector2($"../player".get_global_position().x, $"../player".get_global_position().y) # Get player location
	angle = get_global_position().angle_to_point(direction) + (1.0/2.0)*PI # Get angle to point toward player
	# Adjust rotation/angle so that it doesn't rotate the long way around
	if abs(rotation - angle) >= PI && rotation != 0:
		if rotation > angle:
			rotation = (fposmod(rotation + PI, 2.0*PI) - PI) - (2.0 * PI)
		else:
			angle = (fposmod(angle + PI, 2.0*PI) - PI) - (2.0 * PI)
	# Set rotation
	if(rotation > angle + aimSpeed): rotation -= aimSpeed
	if(rotation < angle - aimSpeed): rotation += aimSpeed

func _on_hitbox_area_entered(area):
	._on_hitbox_area_entered(area)
	if(hit != null && hit.collider.is_in_group("tilemap")):
		returnPosition()
	
func returnPosition():
	returning = true
	$chargeCooldown.start()
	
func _on_chargeCooldown_timeout():
	charge = true

func _on_aimTime_timeout():
	aiming = false
	aimed = true
	$chargeUp.start()
	
func _on_chargeUp_timeout():
	attacking = true
	attackDirection = get_global_position().direction_to(direction).normalized()
	$animatedSprite.frame = engaged
	
