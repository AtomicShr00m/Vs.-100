extends KinematicBody2D

const SPEED=250
const ACCEL=600
const FRICTION=8
const GRAVITY=700

var motion:Vector2

var target:Node2D

onready var sprite = $Sprite

func _physics_process(delta):
	motion.y+=GRAVITY*delta
	var dir:=0
	if dir==0:
		motion.x=lerp(motion.x,0,FRICTION*delta)
	else:
		motion.x+=dir*ACCEL*delta
		motion.x=clamp(motion.x,-SPEED,SPEED)
		sprite.flip_h=dir<0
	
	motion=move_and_slide(motion,Vector2.UP)

