extends Spatial

var RightHandTarget : Vector3
onready var RightHandPhysicsBone : PhysicalBone = $"legless_man1/Armature/Skeleton/Physical Bone handR"

func _ready():
	pass


func _physics_process(_delta : float):
	var MousePos := get_viewport().get_mouse_position()
	var ViewportCam := get_viewport().get_camera()
	var MousePosition3D := ViewportCam.project_position(MousePos, ViewportCam.global_transform.origin.z)
	$DebugRightHand.global_transform.origin = MousePosition3D
	
