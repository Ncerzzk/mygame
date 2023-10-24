extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	(get_node("重心") as Node3D).transform.origin = center_of_mass
	print(center_of_mass)
	pass
