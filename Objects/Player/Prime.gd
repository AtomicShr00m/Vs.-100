extends KinematicBody2D

const SPEED=200
const ACCEL=600
const FRICTION=6
const GRAVITY=700

var is_climbing:=false
var is_near_ladder:Node2D

var motion:Vector2

onready var sprite = $Sprite

func _physics_process(delta):
	motion.y+=GRAVITY*delta
	var dir:=sign(Input.get_axis("ui_left","ui_right"))
	
	if is_climbing:
		motion.y=Input.get_axis("ui_up","ui_down")*120
		if Input.is_action_pressed("ui_down") and is_on_floor():
			is_climbing=false
	else:
		if Input.is_action_pressed("ui_down"):
			position.y+=1
		if is_near_ladder and (Input.is_action_pressed("ui_up") or (Input.is_action_pressed("ui_down") and !is_on_floor())):
			is_climbing=true
			motion.x=0
			position.x=is_near_ladder.position.x
		elif dir==0:
			motion.x=lerp(motion.x,0,FRICTION*delta)
		else:
			motion.x+=dir*ACCEL*delta
			motion.x=clamp(motion.x,-SPEED,SPEED)
			sprite.flip_h=dir<0
	
	motion=move_and_slide(motion,Vector2.UP)
