extends KinematicBody2D

const SPEED=100
const ACCEL=600
const FRICTION=8
const GRAVITY=700

var motion:Vector2
var dir:=0

var target:Node2D

onready var anim = $Anim
onready var sprite = $Sprite
onready var shoot_timer = $ShootTimer
onready var enemy_check = $Sprite/EnemyCheck
onready var player_check = $Sprite/PlayerCheck
onready var bullet_spawn = $Sprite/Head/ArmR/BulletSpawn
onready var bulletScn = preload("res://Objects/Enemies/Bullets/BulletBlue.tscn")

func hit():
	queue_free()

func _ready():
	player_check.cast_to.x=rand_range(160,320)
	enemy_check.cast_to.x=player_check.cast_to.x

func shoot():
	var bullet=bulletScn.instance()
	bullet.dir.x=sprite.scale.x
	bullet.position=bullet_spawn.global_position
	bullet_spawn.scale=Vector2.ZERO
	get_parent().add_child(bullet)

func sight_blocked():
	var collider=enemy_check.get_collider()
	if collider:
		if collider.is_in_group('enemies'):
			return true
	return false

func spotted_player():
	return player_check.get_collider()==target

func _physics_process(delta):
	if !shoot_timer.is_stopped():
		bullet_spawn.scale=Vector2.ONE*(1-shoot_timer.time_left)
	motion.y+=GRAVITY*delta
	if dir==0:
		motion.x=lerp(motion.x,0,FRICTION*delta)
	else:
		sprite.scale.x=dir
		motion.x+=dir*ACCEL*delta
		motion.x=clamp(motion.x,-SPEED,SPEED)
	
	motion=move_and_slide(motion,Vector2.UP)

func _on_FriendCheck_body_entered(body):
	enemy_check.add_exception(body)

func _on_FriendCheck_body_exited(body):
	enemy_check.remove_exception(body)
