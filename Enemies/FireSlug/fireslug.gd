extends KinematicBody2D


export(PackedScene) var trailScene

var left_facing = 1; # Whether the slug is moving left or right (1 for right, -1 for left)
var move_velocity = 0;



func _ready():
	$MotionTween.interpolate_property(self, "move_velocity", 20, 2, 3.5, Tween.TRANS_QUART, Tween.EASE_OUT);
	$MotionTween.start();



func _physics_process(delta):
	
	if(left_facing == 1 && ($RightDownRay.get_collider() == null || $RightSideRay.get_collider() != null)): 
		left_facing = -1;
		$RightDownRay.enabled = false;
		$RightSideRay.enabled = false;
		$LeftDownRay.enabled = true;
		$LeftSideRay.enabled = true;
	elif(left_facing == -1 && ($LeftDownRay.get_collider() == null || $LeftSideRay.get_collider() != null)): 
		left_facing = 1;
		$RightDownRay.enabled = true;
		$RightSideRay.enabled = true;
		$LeftDownRay.enabled = false;
		$LeftDownRay.enabled = false;
	
	move_and_slide_with_snap(Vector2(move_velocity * left_facing, 1), Vector2.DOWN, Vector2.UP, false, 4)


func _onStartEnter(body):
	pass # Replace with function body.


func _onStopExit(body):
	pass # Replace with function body.


func _on_hitbox_area_entered(area):
	if(area.is_in_group("spear")): queue_free();


func _on_TrailTimer_timeout():
	var firetrail = trailScene.instance();
	get_parent().add_child(firetrail);
	firetrail.global_position = $RightFireTrail.global_position if left_facing == -1 else $LeftFireTrail.global_position;
