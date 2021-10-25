extends Spatial

var RightHandTarget : Vector3
onready var RightHandPhysicalBone : PhysicalBone = $"legless_man1/Armature/Skeleton/Physical Bone handR"
onready var LeftHandPhysicalBone : PhysicalBone = $"legless_man1/Armature/Skeleton/Physical Bone handL"
onready var RightLowerArmPhysicalBone : PhysicalBone = $"legless_man1/Armature/Skeleton/Physical Bone arm_lowerR"
onready var LeftLowerArmPhysicalBone : PhysicalBone = $"legless_man1/Armature/Skeleton/Physical Bone arm_lowerL"
const HAND_MOVE_IMPULSE := 1.0
const HAND_TARGET_ACCEL := 10.0
const MAX_TARGET_OFFSET := 5.0
var LeftHandRelativeToCamera : Vector3
const HAND_TARGET_SPEED := 5.0


func _ready():
	print(RightLowerArmPhysicalBone.get_property_list())
	pass


func _physics_process(delta : float):
	var MousePos := get_viewport().get_mouse_position()
	var ViewportCam := get_viewport().get_camera()
	var CameraPos := ViewportCam.global_transform.origin
	var MousePosition3D := ViewportCam.project_position(MousePos, CameraPos.z)
	$DebugRightHand.global_transform.origin = MousePosition3D
	MoveHandTowardTarget(RightHandPhysicalBone, MousePosition3D)
	if Global.is_pressed("move_left_target_left"):
		LeftHandRelativeToCamera.x -= HAND_TARGET_SPEED * delta
	if Global.is_pressed("move_left_target_right"):
		LeftHandRelativeToCamera.x += HAND_TARGET_SPEED * delta
	if Global.is_pressed("move_left_target_up"):
		LeftHandRelativeToCamera.y += HAND_TARGET_SPEED * delta
	if Global.is_pressed("move_left_target_down"):
		LeftHandRelativeToCamera.y -= HAND_TARGET_SPEED * delta
	var LeftHandTargetPos := CameraPos + LeftHandRelativeToCamera
	LeftHandTargetPos.z = 0
	$DebugLeftHand.global_transform.origin = LeftHandTargetPos
	MoveHandTowardTarget(LeftHandPhysicalBone, LeftHandTargetPos)
	#if Global.is_pressed("right_hand_grab"):
	#	RightLowerArmPhysicalBone.set_param(


func MoveHandTowardTarget(Hand : PhysicalBone, Target : Vector3):
	var DirToTarget := Hand.global_transform.origin.direction_to(Target)
	Hand.apply_central_impulse(DirToTarget * HAND_MOVE_IMPULSE)
