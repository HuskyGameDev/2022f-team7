extends "res://Enemies/baseEnemy.gd"


export (PackedScene) var particles
var attacking
var maxSpeed = 100
var startSpeed = 2

func _ready():
	._ready()
	vec = Vector2(0,startSpeed)

func _onStartEnter(body):
	$attack.play()
	._onStartEnter(body)
	$startRange.set_deferred("monitoring", false)
	attacking = true
	$AnimatedSprite.animation = "alert"
	$AnimatedSprite.playing = true
	set_collision_layer_bit(4, true) #become vulnerable

func _on_hitbox_area_entered(area):
	if(attacking):
		._on_hitbox_area_entered(area)

func customMode(delta):
	.customMode(delta)
	if (attacking):
		vec = move_and_slide(vec)
		vec.y += 2.5
		vec.y = clamp(vec.y, 0, 100)

func _on_hitbox_body_entered(body):
	if(attacking):
		var ds = get_node("DeathSound").duplicate()
		ds.play()
		get_parent().add_child(ds)
		ds.transform = transform;
		var p = particles.instance()
		p.transform = transform
		get_parent().add_child(p)
		p.emitting = true;
		
		queue_free()
		._on_hitbox_area_entered(body)
