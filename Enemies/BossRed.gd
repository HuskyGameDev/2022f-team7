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
var hit
var attackDirection 
var speed = 1
var aimed
var charge 
var stunned



#called per physics frame after mode code
func custom(delta):
	if(aiming): rotateBoss()
	if(attacking):
		hit = move_and_collide(attackDirection * speed)
	.custom(delta)

func _ready():
	._ready()
	stunned = false
	vulnerable = false
	hp = 5
	charge = true
	$mapCollider2.set_collision_mask_bit(1, false)
	var enemy1 = BossHands.instance()
	enemy1.position = self.position
	#these two add child calls have to be deferred because we can't guarantee the rest of
	#the scene is also ready
	get_parent().call_deferred("add_child", enemy1)
	#add_child(get_parent().add_child(enemy1))
	var enemy2 = BossHands.instance()
	enemy2.position = self.position
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
	if body.is_in_group("player"):
		if(charge && !aiming && !attacking && !aimed):
			aiming = true
			mode = 4
			$aimTime.start()
		elif(body.get_class() == "KinematicBody2D" && !charge && !vulnerable):
			player = body
			mode = 0
	engaged = true

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
			var children = self.get_children()
			for c in children:
				self.remove_child(c)
				c.queue_free()
			queue_free()
	
func attackStomp():
	#add animation here
	$BossStompHitbox.set_deferred("disabled",false)
	$StompDur.start()
	
func stun():
	vulnerable = true
	print("stun begins")
	#remove_child(BossHands.instance())
	#remove_child(BossHands.instance())
	$startRange.set_deferred("disabled",true)
	$stopRange.set_deferred("disabled",true)
	$mapCollider2.set_collision_mask_bit(1, false)
	engaged = false;
	mode = 4
	#add animation here to go into stun state
	$stunDur.start()
	
	#add animation here for stun state
	
#spawns the MC cinders will randonmize location later once sprites come in
func spawnMinions():
	var x: int = 0
	while x < 5:
		var enemy1 = MCinder.instance()
		enemy1.position = self.position
		add_child(get_parent().add_child(enemy1))
		x = x + 1
	


func _on_ChargeUp_timeout():
	attackDirection = get_global_position().direction_to(direction).normalized()
	$mapCollider2.set_collision_mask_bit(1, true)
	attacking = true
	charge = false
	set_collision_layer_bit(4, true)
	


func _on_stunTimer_timeout():
	if (vulnerable == false):
		vulnerable = true
		#play recover 
		#respawns hands after stun is over
		$startRange.set_deferred("disabled",false)
		$stopRange.set_deferred("disabled",false)
		var enemy1 = BossHands.instance()
		enemy1.position = self.position
		add_child(get_parent().add_child(enemy1))
		var enemy2 = BossHands.instance()
		enemy2.position = self.position
		add_child(get_parent().add_child(enemy2))
		mode = 0


func _on_aimTime_timeout():
	aiming = false
	aimed = true
	$ChargeUp.start()


func _on_StompDur_timeout():
	$BossStompHitbox.set_deferred("disabled",true)
	stun()


func _on_mapCollider2_area_entered(area):
	if(attacking && !area.is_in_group('spear')):
		print("boss hit something")
		attacking = false
		stunned = true
		mode = 4
		stun()


func _on_chargeCol_timeout():
	charge = true 
	print("boss charge ready")


func _on_stunDur_timeout():
	if (vulnerable == false):
		vulnerable = true
		#play recover 
		#respawns hands after stun is over
	$startRange.set_deferred("disabled",false)
	$stopRange.set_deferred("disabled",false)
	var enemy1 = BossHands.instance()
	enemy1.position = self.position
	add_child(get_tree().current_scene.add_child(enemy1))
	var enemy2 = BossHands.instance()
	enemy2.position = self.position
	add_child(get_tree().current_scene.add_child(enemy2))
	$chargeCol.start()
