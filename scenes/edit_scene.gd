extends Node3D

var add_object_moving = false
var add_object_target:MyRigidBody3D
var car:BasicBalanceCar
var car_collision_shape:ConvexPolygonShape3D
var car_collision_shape_max_z = 0
var car_init_transform

var car_hinges_hash = {}

var camera_rotating = false
var camera_old_transform:Transform3D

func create_hinge(pos:Vector3, node1:Node3D, node2:Node3D ):
	var hinge = Generic6DOFJoint3D.new()
	hinge.transform.origin = pos
	hinge.node_a = node1.get_path()
	hinge.node_b = node2.get_path()
	#hinge.set_param(HingeJoint3D.PARAM_LIMIT_LOWER,0)
	#hinge.set_param(HingeJoint3D.PARAM_LIMIT_UPPER,0)
	#hinge.set_param(HingeJoint3D.PARAM_BIAS,0.99)
	#hinge.set_param(HingeJoint3D.PARAM_LIMIT_BIAS,0.99)
	#hinge.set_flag(HingeJoint3D.FLAG_USE_LIMIT,true)
	return hinge
	
func link_obj_to_car(car:Node3D,obj:Node3D,pos:Vector3):
	var hinge = create_hinge(pos,car,obj)
	car_hinges_hash[obj] = hinge
	car.add_child(hinge)
	hinge.transform.origin = pos * car.transform
	obj.reparent(car)

func unlink_obj_from_car(car:Node3D,obj:Node3D):
	var hinge = car_hinges_hash.get(obj)
	car.remove_child(obj)
	if hinge:
		car.remove_child(hinge)
		hinge.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_node("basic_balance_car")
	car_init_transform = car.transform
	car_collision_shape = (get_node("basic_balance_car/body_CollisionShape3D") \
	as CollisionShape3D).shape \
	as ConvexPolygonShape3D
	
	for i in car_collision_shape.points:
		if abs(i.z) > car_collision_shape_max_z:
			car_collision_shape_max_z = i.z

func _input(event):
	var camera = get_node("Camera3D") as Camera3D
	if event.is_action_pressed("物体绕z旋转"):
		if add_object_target:
			add_object_target.rotate_z(PI/2) 
	elif event.is_action_pressed("物体绕y旋转"):
		if add_object_target:
			add_object_target.rotate_y(PI/2) 
	if event is InputEventMouseMotion:
		if camera_rotating:
			#$Bat.position = $Bat.position.rotated(Vector3(0,1,0).normalized(),PI/100)
			#$Bat.look_at_from_position($Bat.position.rotated(Vector3(0,1,0).normalized(),PI/100),Vector3(0,1,0))
			camera.look_at_from_position(camera.position.rotated(Vector3(0,1,0),PI/10),car.position)
			pass
		else:
			var mouse_pos =  camera.project_position(event.position,camera.transform.origin.z)
			# mouse_pos = mouse_pos * car.transform
			if add_object_target != null && add_object_moving:
				add_object_target.transform.origin.x = mouse_pos.x
				add_object_target.transform.origin.y = mouse_pos.y
				add_object_target.transform.origin.z = car_collision_shape_max_z
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && add_object_moving:
			add_object_moving = false
			var mouse_pos =  camera.project_position(event.position,camera.transform.origin.z)
			add_object_target.add_to_parent(car,add_object_target.transform.origin)
			#link_obj_to_car(car,add_object_target,add_object_target.transform.origin)

		if event.button_index == MOUSE_BUTTON_RIGHT && not event.pressed :
			add_object_moving = false
			if add_object_target != null:
				unlink_obj_from_car(car,add_object_target)
				add_object_target.queue_free()
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				camera_old_transform = camera.transform
				camera_rotating = true
			else:
				camera.transform = camera_old_transform
				camera_rotating = false
			
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if add_object_target != null:
		DebugDraw3D.draw_gizmo(add_object_target.global_transform.orthonormalized())
	

func _on_toggle_pressed():
	car.rotate_y(PI)
	
func _on_check_box_show_center_of_mas_toggled(button_pressed):
	var car_body = get_node("basic_balance_car/body") as MeshInstance3D
	if button_pressed:
		car_body.transparency = 0.5
	else:
		car_body.transparency = 0
		
func _on_check_box_enable_gravity_toggled(button_pressed):
	car.enable_gravity(button_pressed)


func _on_button_reset_pressed():
	car.transform = car_init_transform


func _on_button_obj_pressed(extra_arg_0):
	var object_class:Resource
	match extra_arg_0:
		"bat":
			object_class = preload("res://cars/bat.tscn")
		"imu":
			object_class = preload("res://cars/imu.tscn")
		"ccd":
			object_class = preload("res://scenes/camera_with_nod.tscn")
	
	add_object_target = object_class.instantiate()
	
	add_child(add_object_target)
	add_object_moving = true
