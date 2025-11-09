extends Sprite

func _on_CheckBox_body_entered(body):
	body.is_near_ladder=self

func _on_CheckBox_body_exited(body):
	body.is_near_ladder=null
	if body.is_climbing:
		body.is_climbing=false
