extends State

var wait_time:=3.0

func open():
	wait_time=rand_range(2,4)

func update(delta):
	wait_time-=delta
	if wait_time<=0:
		emit_signal("transit",self,'scout')
	
