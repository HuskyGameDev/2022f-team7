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
var hit

#boilerplate methods
func _ready():
	rotation = -2*PI

#enemy mode override (called under physics process)
func customMode(delta):
	if(aiming): rotateSpike()
	if(attacking): hit = move_and_collide(attackDirection * speed * delta, true)
	#if(hit != null && !hit.collider.is_in_group("tilemap")): queue_free()
	.customMode(delta)

func _onStartEnter(body):
	._onStartEnter(body)
	if(!aimed && body.is_in_group("player")):
		$AimTimer.start()
		aiming = true

#signals
func _onAimEnd():
	aiming = false
	aimed = true
	$AttackDelay.start()

func _onTargetDelayEnd():
	attacking = true
	attackDirection = get_global_position().direction_to(direction).normalized()
	$touchBox.set_collision_mask_bit(1, true)

func _onTipHit(body):
	if(attacking):
		var p = particles.instance()
		p.transform = transform
		get_parent().add_child(p)
		p.emitting = true;
		queue_free()

#helper methods
func rotateSpike():
	direction = Vector2($"../player".get_global_position().x, $"../player".get_global_position().y) # Get player location
	angle = get_global_position().angle_to_point(direction) + (3.0/2.0)*PI # Get angle to point toward player
	# Adjust rotation/angle so that it doesn't rotate the long way around
	if abs(rotation - angle) >= PI && rotation != 0:
		if rotation > angle:
			rotation = (fposmod(rotation + PI, 2.0*PI) - PI) - (2.0 * PI)
		else:
			angle = (fposmod(angle + PI, 2.0*PI) - PI) - (2.0 * PI)
	# Set rotation
	if(rotation > angle + aimSpeed): rotation -= aimSpeed
	if(rotation < angle - aimSpeed): rotation += aimSpeed
