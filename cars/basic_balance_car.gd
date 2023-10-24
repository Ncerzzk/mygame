class_name BasicBalanceCar
 
extends VehicleBody3D

var last_q:Quaternion
# Called when the node enters the scene tree for the first time.
func _ready():
	print(transform)
	last_q = quaternion
	pass # Replace with function body.

func cal_center_of_mass():
	var sum_mass = mass
	var mass_ri = center_of_mass * mass
	for i in get_children():
		if i is MyRigidBody3D:
			sum_mass += i.mass
			mass_ri += i.mass * (i.transform * i.center_of_mass)
	return mass_ri / sum_mass

func cal_angle_speed(delta):
	var result:Quaternion
	var temp_now_q:Quaternion = quaternion
	var dq:Quaternion = temp_now_q - last_q
	if abs(dq.w) > 0.9: # handle the situation: sign of quaternion change
		temp_now_q = -quaternion
		dq = temp_now_q - last_q
	result = 2* (dq) /delta * temp_now_q.inverse()
	last_q = quaternion
	return result

func cal_acc():
	return Vector3(0,1,0) * transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_center_of_mass = cal_center_of_mass()
	(get_node("重心") as Node3D).transform.origin = new_center_of_mass

func _physics_process(delta):
	#print(cal_angle_speed(delta))
	pass

func enable_gravity(enable:bool):
	freeze = !enable
	for i in get_children():
		if i is RigidBody3D:
			i.freeze = !enable
	
