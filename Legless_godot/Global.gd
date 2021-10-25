extends Node

var ControllerDevice := 0
var ControllerDeadzone := 0.8


func joy_past_deadzone(joy_val : Vector2, axis_sign : float) -> bool:
	var length := joy_val.length()
	if (length > ControllerDeadzone):
		var axis_positive := joy_val.x * axis_sign
		var deadzone := (joy_val.normalized() * ControllerDeadzone).x  # Circular deadzone
		var wedge_deadzone := 0.4142135623730950488016887242097 * abs(joy_val.y) # 1 / tan(3/4 90 degrees).  The slope of 1/8 of a circle
		if (wedge_deadzone > deadzone):
			deadzone = wedge_deadzone
		if (axis_positive > deadzone):
			return true
	return false


func is_pressed(action : String) -> bool:
	var is_pressed := false
	for event in InputMap.get_action_list(action):
		if event is InputEventKey:
			is_pressed = Input.is_key_pressed(event.scancode)
		elif event is InputEventJoypadButton:
			is_pressed = Input.is_joy_button_pressed(event.device, event.button_index)
		elif event is InputEventMouseButton:
			is_pressed = Input.is_mouse_button_pressed(event.button_index)
		elif event is InputEventJoypadMotion:
			var axis : int = event.axis
			var axis_sign := sign(event.axis_value)
			var axis_val := Input.get_joy_axis(ControllerDevice, event.axis)# * axis_sign
			var perpendicular_axis_val := 0.0
			if (axis == JOY_ANALOG_LX):
				perpendicular_axis_val = Input.get_joy_axis(ControllerDevice, JOY_ANALOG_LY)
			elif (axis == JOY_ANALOG_LY):
				perpendicular_axis_val = Input.get_joy_axis(ControllerDevice, JOY_ANALOG_LX)
			elif (axis == JOY_ANALOG_RX):
				perpendicular_axis_val = Input.get_joy_axis(ControllerDevice, JOY_ANALOG_RY)
			elif (axis == JOY_ANALOG_RY):
				perpendicular_axis_val = Input.get_joy_axis(ControllerDevice, JOY_ANALOG_RX)
			var value_2d := Vector2(axis_val, perpendicular_axis_val)
			is_pressed = joy_past_deadzone(value_2d, axis_sign)
		else:
			continue
		if is_pressed:
			return true
	return false
