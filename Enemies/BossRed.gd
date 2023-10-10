extends "res://Enemies/baseEnemy.gd"

#0, follow, 1, use path, 2, ground based movement, 3 for custom/no default behavior
var vulnerable
var attacking
var direction
var angle
var aimSpeed = 0.02
var MCinder = preload("res://Enemies/flameyHead.tscn")
var BossHands = preload("res://Enemies/BossRedHands.tscn")
var aiming
var hit = null
var attackDirection 
var speed = 1
var aimed
var charge 
var stunned
var playerBody



#called per physics frame after mode code
func customMode(delta):
	if(aiming): rotateBoss()
	if(attacking):
		hit = move_and_collide(attackDirection * speed)
	if(engaged && playerBody != null):
		_onStartEnter(playerBody)
	.customMode(delta)

func _ready():
	._ready()
	$AnimatedSprite.play("default")
	stunned = false
	vulnerable = false
	hp = 5
	charge = true
	$mapCollider2.set_collision_mask_bit(1, false)
	var enemy1 = BossHands.instance()
	enemy1.position = self.position + Vector2(20,0)
	#these two add child calls have to be deferred because we can't guarantee the rest of
	#the scene is also ready
	get_parent().call_deferred("add_child", enemy1)
	#add_child(get_parent().add_child(enemy1))
	var enemy2 = BossHands.instance()
	enemy2.position = self.position + Vector2(-20,0)
	get_parent().call_deferred("add_child", enemy2)
	$BossStompHitbox.set_deferred("disabled",true)
	#add intro animation here


func rotateBoss():
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
	
#control if the enemy should be engaged with the player
func _onStartEnter(body):
	._onStartEnter(body)
	playerBody = body
	if (body.get_class() == "KinematicBody2D"):
		if(charge && !(aiming || attacking || aimed)):
			aiming = true
			mode = 3
			$aimTime.start()
		elif(!charge && !vulnerable && !stunned):
			mode = 0

func _onStopExit(body):
	engaged = false

func _on_hitbox_area_entered(area):
	if(area.is_in_group('spear')&&vulnerable):
		print("red boss hit")
		hp -= 1
		$stunDur.stop()
		$stunDur.emit_signal("timeout")
		
		if (hp<=2):
			spawnMinions()
		if (hp<=0):
			queue_free()
	
func attackStomp():
	#add animation here
	$BossStompHitbox.set_deferred("disabled",false)
	$StompDur.start()
	
func stun():
	print("stun begins")
	$startRange.set_deferred("disabled",true)
	$stopRange.set_deferred("disabled",true)
	set_collision_layer_bit(4, false)
	engaged = false;
	$AnimatedSprite.play("stun")
	#add animation here to go into stun state
	vulnerable = true
	$stunDur.start()
	
	#add animation here for stun state
	
#spawns the MC cinders will randonmize location later once sprites come in
func spawnMinions():
	var x: int = 0
	while x < 5:
		var enemy1 = MCinder.instance()
		#need to randomize positions
		enemy1.position = self.position + Vector2(rand_range(20,40), rand_range(20,40))
		get_parent().call_deferred("add_child", enemy1)
		x = x + 1
	


func _on_ChargeUp_timeout():
	aimed = false
	attackDirection = get_global_position().direction_to(direction).normalized()
	attacking = true
	$mapCollider2.set_collision_mask_bit(1, true)
	set_collision_layer_bit(4, true)
	


func _on_aimTime_timeout():
	aiming = false
	aimed = true
	$ChargeUp.start()


func _on_StompDur_timeout():
	$BossStompHitbox.set_deferred("disabled",true)
	stun()


func _on_chargeCol_timeout():
	charge = true 
	_onStartEnter(playerBody)
	print("boss charge ready")


func _on_stunDur_timeout():
	print("stun over")
	vulnerable = false
	$AnimatedSprite.play("default")
		#play recover 
		#respawns hands after stun is over
		#need to change spawn loacations
	stunned = false
	$startRange.set_deferred("disabled",false)
	$stopRange.set_deferred("disabled",false)
	var enemy1 = BossHands.instance()
	enemy1.position = self.position + Vector2(20,0)
	get_parent().call_deferred("add_child", enemy1)
	var enemy2 = BossHands.instance()
	enemy2.position = self.position + Vector2(-20,0)
	get_parent().call_deferred("add_child", enemy2)
	_onStartEnter(playerBody)
	$chargeCol.start()



func _on_mapCollider2_body_entered(body):
		if(attacking && !body.is_in_group('spear') && !stunned && charge):
			charge = false
			$mapCollider2.set_collision_mask_bit(1, false)
			set_collision_layer_bit(4, false)
			print("boss hit something")
			attacking = false
			stunned = true
			stun()
