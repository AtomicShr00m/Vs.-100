extends KinematicBody2D

const SPEED=150
const ACCEL=600
const FRICTION=6
const GRAVITY=700
const JUMP_FORCE=160

var is_punching:=false
var is_climbing:=false
var is_near_ladder:Node2D

var motion:Vector2

onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var hurt_col = $Sprite/HurtBox/CollisionShape2D
onready var arm_l = $Sprite/Head/ArmL
onready var arm_r = $Sprite/Head/ArmR

func hit():
	get_tree().paused=true
	queue_free()

func punch():
	if is_punching:
		return
	set_arm_anims(false)
	is_punching=true
	var tweener=create_tween()
	tweener.tween_property(arm_l,"position:x",6.0,0.1)
	tweener.parallel().tween_property(arm_r,"position:x",-8.0,0.1)
	tweener.tween_callback(hurt_col,"set_deferred",['disabled',false])
	tweener.tween_property(arm_l,"position:x",0.0,0.1)
	tweener.parallel().tween_property(arm_r,"position:x",12.0,0.05)
	tweener.tween_property(arm_l,"position:x",4.0,0.05)
	tweener.parallel().tween_property(arm_r,"position:x",-4.0,0.1)
	tweener.tween_callback(hurt_col,"set_deferred",['disabled',true])
	yield(tweener,"finished")
	set_arm_anims(true)
	is_punching=false

func set_arm_anims(value):
	for anims in anim.get_animation_list():
		var cur_anim:Animation=anim.get_animation(anims)
		var armL_track=cur_anim.find_track("Sprite/Head/ArmL:position")
		var armR_track=cur_anim.find_track("Sprite/Head/ArmR:position")
		cur_anim.track_set_enabled(armL_track,value)
		cur_anim.track_set_enabled(armR_track,value)

func _physics_process(delta):
	motion.y+=GRAVITY*delta
	var dir:=sign(Input.get_axis("ui_left","ui_right"))
	
	if is_climbing:
		motion.y=Input.get_axis("ui_up","ui_down")*120
		if abs(motion.y)>0:
			anim.play("Climb")
		if Input.is_action_pressed("ui_down") and is_on_floor():
			is_climbing=false
	else:
		if Input.is_action_pressed("ui_down"):
			position.y+=1
		if is_near_ladder and (Input.is_action_pressed("ui_up") or (Input.is_action_pressed("ui_down") and !is_on_floor())):
				is_climbing=true
				motion.x=0
				position.x=is_near_ladder.position.x
		else:
			if Input.is_action_just_pressed("punch"):
				punch()
			if dir==0:
				anim.play("Idle")
				motion.x=lerp(motion.x,0,FRICTION*delta)
			else:
				anim.play("Walk")
				
				motion.x+=dir*ACCEL*delta
				motion.x=clamp(motion.x,-SPEED,SPEED)
				sprite.scale.x=1 if dir>0 else -1
			if is_on_floor() and Input.is_action_just_pressed("jump"):
				motion.y=-JUMP_FORCE
	
	motion=move_and_slide(motion,Vector2.UP)


func _on_HurtBox_area_entered(area):
	area.flip()

func _on_HurtBox_body_entered(body):
	body.hit()
