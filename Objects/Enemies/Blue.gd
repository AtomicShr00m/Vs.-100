extends KinematicBody2D

const SPEED=100
const ACCEL=600
const FRICTION=8
const GRAVITY=700

var motion:Vector2
var dir:=0

var target:Node2D

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	motion.y+=GRAVITY*delta
	if dir==0:
		motion.x=lerp(motion.x,0,FRICTION*delta)
		animation_player.play("Idle")
	else:
		animation_player.play("Walk")
		motion.x+=dir*ACCEL*delta
		motion.x=clamp(motion.x,-SPEED,SPEED)
		sprite.scale.x=dir
	
	motion=move_and_slide(motion,Vector2.UP)

