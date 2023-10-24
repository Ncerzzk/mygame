extends GutTest

var MyRigidBody3D = preload("res://scripts/MyRigidBody3D.gd")

func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

func test_center_of_mass():
	var parent = MyRigidBody3D.new()
	parent.mesh = MeshInstance3D.new()
	parent.mass = 1
	
	assert_almost_eq(parent.center_of_mass,Vector3(0,0,0),Vector3(0.0001,0.0001,0.0001) )
	parent.init_center_of_mass = Vector3(1,0,0)
	assert_almost_ne(parent.center_of_mass,Vector3(0,0,0),Vector3(0.0001,0.0001,0.0001) )
	print(parent.center_of_mass)
	assert_almost_eq(parent.center_of_mass,Vector3(1,0,0),Vector3(0.0001,0.0001,0.0001) )
	
	var child = MyRigidBody3D.new()
	child.mass = 1
	child.add_to_parent(parent,Vector3(1,0,0))
	
	assert_almost_eq(parent.mass, 2, 0.001)
	assert_almost_eq(parent.center_of_mass,Vector3(1,0,0),Vector3(0.0001,0.0001,0.0001) )
	
	
