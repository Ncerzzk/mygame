extends MyRigidBody3D

@onready var last_q:Quaternion = self.quaternion

func cal_angle_speed(delta):
	var quaternion = (get_parent() as Node3D).quaternion
	var result:Quaternion
	var temp_now_q:Quaternion = quaternion
	var dq:Quaternion = temp_now_q - last_q
	if abs(dq.w) > 0.9: # handle the situation: sign of quaternion change
		temp_now_q = -quaternion
		dq = temp_now_q - last_q
	result = 2* (dq) /delta * temp_now_q.inverse()
	last_q = quaternion
	return result

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	print(cal_angle_speed(delta))

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass
