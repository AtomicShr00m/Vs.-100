extends KinematicBody2D

const SPEED=150
const ACCEL=600
const FRICTION=6
const GRAVITY=700

var is_climbing:=false
var is_near_ladder:Node2D

var motion:Vector2

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	motion.y+=GRAVITY*delta
	var dir:=sign(Input.get_axis("ui_left","ui_right"))
	
	if is_climbing:
		motion.y=Input.get_axis("ui_up","ui_down")*120
		if abs(motion.y)>0:
			animation_player.play("Climb")
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
			animation_player.play("Idle")
			motion.x=lerp(motion.x,0,FRICTION*delta)
		else:
			animation_player.play("Walk")
			motion.x+=dir*ACCEL*delta
			motion.x=clamp(motion.x,-SPEED,SPEED)
			sprite.scale.x=1 if dir>0 else -1
	
	motion=move_and_slide(motion,Vector2.UP)
