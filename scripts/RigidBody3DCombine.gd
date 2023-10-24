class_name RigidBody3DCombine extends Node3D

func cal_center_of_mass():
	var sum_mass = mass
	var mass_ri = center_of_mass * mass
	for i in get_children():
		if i is RigidBody3D || i is RigidBody3DCombine:
			sum_mass += i.mass
			mass_ri += i.mass * (i.transform * i.center_of_mass)
	return mass_ri / sum_mass

var mass:float:
	get:
		var sum_mass = 0
		for i in get_children():
			if i is RigidBody3D:
				sum_mass += i.mass
		return sum_mass

var center_of_mass:Vector3:
	get:
		var sum_mass = 0
		var mass_ri = Vector3(0,0,0)
		for i in get_children():
			if i is RigidBody3D:
				sum_mass += i.mass
				mass_ri += i.mass * (i.transform * i.center_of_mass)
		return mass_ri / sum_mass

