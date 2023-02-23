extends "res://Enemies/baseEnemy.gd"

#0, follow, 1, use path, 2, ground based movement, 3 for custom/no default behavior
var vulnerable = false
var attacking
var direction
var angle
var aimSpeed
var MCinder = preload("res://Enemies/flameyHead.tscn")
var aiming
var hit
var attackDirection 
var speed = 200


#will
func _physics_process(delta):
	match(mode):
		modes.follow:
			if engaged:
				vec = (position - player.position).normalized()
				vec *= -0.2
				move_and_collide(vec, false)
		modes.rails:#MUST be a child of a pathfollower!
			self.get_parent().unit_offset += (.0005 * railSpeed)
		modes.walker:
			pass #have not finished yet, no enemies use it either
		modes.custom:
			customMode(delta)

	custom(delta)

#called per physics frame after mode code
func custom(delta):
	if(aiming): rotateBoss()
	if(attacking): hit = move_and_collide(attackDirection * speed)
	.customMode(delta)

#called per physics frame if enemy is of mode 3
func customMode(delta):
	pass
	#method for handling a custom mode in new enemies

func _ready():
	.ready()
	hp = 5
	$BossStompHitbox.set_deferred("disabled",true)

#will change later for refinement
func rotateBoss():
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
	
#control if the enemy should be engaged with the player
func _onStartEnter(body):
	#if body is in group("player"):
	if(body.get_class() == "KinematicBody2D"):
		player = body
	engaged = true

func _onStopExit(body):
	engaged = false

func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')&&vulnerable):
		vulnerable = false
		hp -= 1
		if (hp<=2):
			spawnMinions()
		if (hp<=0):
			#add death animation here
			queue_free()
	if(hit != null && hit.collider.is_in_group("tilemap")):
		stun()
#attacks of 
func attackCharge():
	pass
	
func attackStomp():
	#add animation here
	$BossStompHitbox.set_deferred("disabled",false)
	stun()
	
func stun():
	vulnerable = true
	$stunTimer.start()
	
	#add animation here for stun state
	
#spawns the MC cinders will randonmize location later once sprites come in
func spawnMinions():
	var x: int = 0
	while x < 5:
		add_child(MCinder.instance())
		MCinder.instance().global_position = Vector2(0,0)
		x = x + 1
	


func _on_ChargeUp_timeout():
	attacking = true
	attackDirection = get_global_position().direction_to(direction).normalized()
	
	pass # Replace with function body.


func _on_stunTimer_timeout():
	pass # Replace with function body.


func _on_aimTime_timeout():
	pass # Replace with function body.
