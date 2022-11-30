extends "res://Enemies/baseEnemy.gd"


export (PackedScene) var particles
var attacking
var maxSpeed = 100
var startSpeed = 2

func _ready():
	._ready()
	vec = Vector2(0,startSpeed)

func _onStartEnter(body):
	._onStartEnter(body)
	attacking = true
	$AnimatedSprite.animation = "alert"
	$AnimatedSprite.playing = true

func _on_hitbox_area_entered(area):
	if(attacking):
		._on_hitbox_area_entered(area)

func customMode(delta):
	.customMode(delta)
	if (attacking):
		vec = move_and_slide(vec)
		vec.y += 2.5
		vec.y = clamp(vec.y, 0, 100)

func _onTipHit(body):
	if(attacking):
		var p = particles.instance()
		p.transform = transform
		get_parent().add_child(p)
		p.emitting = true;
		queue_free()
