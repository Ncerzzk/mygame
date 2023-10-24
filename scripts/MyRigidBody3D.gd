class_name MyRigidBody3D extends Node3D

var _mass:float = 0

@export var mass:float=0 :
	get:
		var sum_mass:float = _mass
		for i in get_children():
			if i is MyRigidBody3D:
				sum_mass += i.mass
				
		return sum_mass
	set(value):
		_mass = value
@export var mesh:MeshInstance3D
@export var collision:CollisionShape3D

var init_center_of_mass:Vector3

var center_of_mass:Vector3:
	get:
		return cal_center_of_mass()

func get_mesh_list():
	var result:Array[MeshInstance3D] = Array()
	if mesh != null:
		result.append(mesh)
		
	for i in get_children():
		if i is MyRigidBody3D:
			result.append_array(i.get_mesh_list())
	return result

func get_collision_list():
	var result:Array[CollisionShape3D] = Array()
	if collision !=null:
		result.append(collision)
	for i in get_children():
		if i is MyRigidBody3D:
			result.append_array(i.get_collision_list())
	return result
	
func add_to_parent(parent:Node3D, pos:Vector3):
	if get_parent():
		reparent(parent)
	else:
		parent.add_child(self)
	transform.origin = pos * parent.transform

# Called when the node enters the scene tree for the first time.
func _ready():
	if mesh != null:
		init_center_of_mass = mesh.transform.origin

func cal_center_of_mass():
	var sum_mass = mass
	var mass_ri = init_center_of_mass * mass
	for i in get_children():
		if i is MyRigidBody3D:
			sum_mass += i.mass
			mass_ri += i.mass * (i.transform * i.center_of_mass)
	return mass_ri / sum_mass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
