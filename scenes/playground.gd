extends Node2D

func get_arc_points(r:int, angle:float, point_num:int,center_pos:Vector2):
	var result=[]
	for i in range(point_num):
		var now_angle = i*angle/point_num * 180 / PI
		var pos = Vector2(r*cos(now_angle),r*sin(now_angle))+ center_pos
		result.append(Vector3(pos.x,pos.y,0))
	return PackedVector3Array(result)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var arc1 = get_arc_points(100,90,90,Vector2(0,0))
	var arc2 = get_arc_points(50,90,90,Vector2(0,0))
	arc2.reverse()
	arc1.append_array(arc2)
	print(arc1)
	
	var a=[]
	a[Mesh.ARRAY_VERTEX] = arc1
	
	var mesh = (get_node("MeshInstance3D") as MeshInstance3D).mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES,a)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
