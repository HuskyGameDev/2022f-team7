extends KinematicBody2D


export(PackedScene) var trailScene
export(float, 0, 200, 10) var hiSpeed = 50.0 #push speed
export(float, 0, 200) var loSpeed = 10.0 #after push speed
export(float, 0, 10) var interval = 3.5 #time to move from hi to low

var vec
var left_facing = 1 # Whether the slug is moving left or right (1 for right, -1 for left)
var tweened_vel = 0



func _ready():
	$MotionTween.interpolate_property(self, "tweened_vel", 20, 2, 3.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$MotionTween.start()



func _physics_process(_delta):
	if(left_facing == 1 && ($RightDownRay.get_collider() == null || $RightSideRay.get_collider() != null)): 
		left_facing = -1
		$AnimatedSprite.flip_h = true
		$RightDownRay.enabled = false
		$RightSideRay.enabled = false
		$LeftDownRay.enabled = true
		$LeftSideRay.enabled = true
	elif(left_facing == -1 && ($LeftDownRay.get_collider() == null || $LeftSideRay.get_collider() != null)): 
		left_facing = 1
		$AnimatedSprite.flip_h = false
		$RightDownRay.enabled = true
		$RightSideRay.enabled = true
		$LeftDownRay.enabled = false
		$LeftSideRay.enabled = false
	vec = Vector2(tweened_vel * left_facing, 1)
	vec = move_and_slide_with_snap(vec, Vector2.DOWN, Vector2.UP, false, 4)


func _onStartEnter(_body):
	pass # Replace with function body.


func _onStopExit(_body):
	pass # Replace with function body.


func _on_hitbox_area_entered(area):
	if(area.is_in_group("spear")): queue_free();


func _on_TrailTimer_timeout():
	var firetrail = trailScene.instance();
	get_parent().add_child(firetrail);
	firetrail.global_position = $RightFireTrail.global_position if left_facing == -1 else $LeftFireTrail.global_position;
