extends Spatial


onready var skeleton : Skeleton = $Armature/Skeleton

func _ready():
	skeleton.physical_bones_start_simulation()

