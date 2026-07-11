## AddyTools by ReloKai
## A collection of random functions that don't already exist in Godot.
## I personally use these in all of my projects!
## Use this script as an AutoLoad to use these tools in your project.

extends Node
class_name AddyTools_class

#region Math Tools
## The correct use of delta in a lerp function
func deltaFactor(factor:float,delta:float) -> float:
	return 1.0 - factor ** delta

## Get the multiplication factors of an int
func getFactors(input:int):
	var inputMax : int = int(floor(sqrt(input)))
	var factors : Array = []
	for index in range(inputMax):
		var i : int = index+1
		if i <= inputMax:
			if input % i == 0:
				factors.append(i)
	removeArrayDuplicates(factors)
	return factors

## Get the largest Square Root of an int
func getLargestSquareFromInt(input:int) -> Vector2i:
	var N : int = int(floor(sqrt(input)))
	var M : int = 0
	while bool(input % N):
		N -= 1
	M = floor(input / N)
	return Vector2i(N,M)

## Returns a random rotation in radians
## If maxRot == 0.0, will return any random rotation
func randomRotation(maxRot:float = 0.0):
	if maxRot == 0.0:
		maxRot = TAU
	return randf_range(0.0,maxRot)

#endregion

#region Vector Tools
## Average both values of a Vector2
func averageVector2Values(input:Vector2) -> float:
	return (input.x + input.y)/2

## Average the three values of a Vector3
func averageVector3Values(input:Vector3) -> float:
	return (input.x + input.y + input.z)/3

## Get the average of an Array[Vector2]
func averageVector2s(inputV2s:Array[Vector2]) -> Vector2:
	var output : Vector2 = Vector2.ZERO
	for vector in inputV2s:
		output += vector
	output /= inputV2s.size()
	return output

## Get the average of an Array[Vector3]
func averageVector3s(inputV3s:Array[Vector3]) -> Vector3:
	var output : Vector3 = Vector3.ZERO
	for vector in inputV3s:
		output += vector
	output /= inputV3s.size()
	return output

## Return a random position (Vector2) within a max distance from the starting position
func randomPositionVector2(maxDistance:float,startingPos:Vector2 = Vector2.ZERO,zeroY:bool = true) -> Vector2:
	if zeroY:
		return Vector2(
		randf_range(startingPos.x - maxDistance,startingPos.x + maxDistance),
		0.0)
	else:
		return Vector2(
		randf_range(startingPos.x - maxDistance,startingPos.x + maxDistance),
		randf_range(startingPos.y - maxDistance,startingPos.y + maxDistance))

## Return a random position (Vector2) within a range from a starting position
func randomPositionWithMinVector2(maxDistance:float,minDistance:float,startingPos:Vector2 = Vector2.ZERO,zeroY:bool = true) -> Vector2:
	if zeroY:
		return Vector2(
		randf_range((startingPos.x - minDistance) - maxDistance,
		(startingPos.x + minDistance) + maxDistance),
		0.0)
	else:
		return Vector2(
		randf_range((startingPos.x - minDistance) - maxDistance,
		(startingPos.x + minDistance) + maxDistance),
		randf_range((startingPos.y - minDistance) - maxDistance,
		(startingPos.y + minDistance) + maxDistance))


## Return a random position (Vector3) within a max distance from the starting position
func randomPositionVector3(maxDistance:float,startingPos:Vector3 = Vector3.ZERO,zeroY:bool = true) -> Vector3:
	if zeroY:
		return Vector3(
		randf_range(startingPos.x - maxDistance,startingPos.x + maxDistance),
		0.0,
		randf_range(startingPos.z - maxDistance,startingPos.z + maxDistance))
	else:
		return Vector3(
		randf_range(startingPos.x - maxDistance,startingPos.x + maxDistance),
		randf_range(startingPos.y - maxDistance,startingPos.y + maxDistance),
		randf_range(startingPos.z - maxDistance,startingPos.z + maxDistance))

## Return a random position (Vector3) within a range from a starting position
func randomPositionWithMinVector3(maxDistance:float,minDistance:float,startingPos:Vector3 = Vector3.ZERO,zeroY:bool = true) -> Vector3:
	if zeroY:
		return Vector3(
		randf_range((startingPos.x - minDistance) - maxDistance,
		(startingPos.x + minDistance) + maxDistance),
		0.0,
		randf_range((startingPos.z - minDistance) - maxDistance,
		(startingPos.z + minDistance) + maxDistance))
	else:
		return Vector3(
		randf_range((startingPos.x - minDistance) - maxDistance,
		(startingPos.x + minDistance) + maxDistance),
		randf_range((startingPos.y - minDistance) - maxDistance,
		(startingPos.y + minDistance) + maxDistance),
		randf_range((startingPos.z - minDistance) - maxDistance,
		(startingPos.z + minDistance) + maxDistance))

## Returns a randomly rotated Vector3.
## If maxRot == 0.0, will return any random rotation
func randomRotationVector3(maxRot:float = 0.0, YOnly:bool = false) -> Vector3:
	if YOnly:
		return Vector3(0.0,randomRotation(maxRot),0.0)
	else:
		return Vector3(randomRotation(maxRot), randomRotation(maxRot), randomRotation(maxRot))

#endregion

#region Transform and Basis Tools
## move_toward function for Basis
func move_toward_basis(bFrom:Basis,bTo:Basis,delta:float) -> Basis:
	return Basis(
	bFrom.x.move_toward(bTo.x,delta),
	bFrom.y.move_toward(bTo.y,delta),
	bFrom.z.move_toward(bTo.z,delta)
	).orthonormalized()

## move_toward function for Transform3D
func move_toward_transform(tFrom:Transform3D,tTo:Transform3D,delta:float) -> Transform3D:
	return Transform3D(
	move_toward_basis(tFrom.basis,tTo.basis,delta),
	tFrom.origin.move_toward(tTo.origin,delta))

#endregion

#region String Tools
## Check if a string is whitespace
func isWhitespace(string:String) -> bool:
	return string.strip_edges().is_empty()

#endregion

#region Array Tools
## Get the value in an array that is closest to a set value
## Returns either the index or the closest value itself (using returnIndex)
## array must be an Array[int] or Array[float]
func getArrayClosestValue(value:float,array:Array,returnIndex:bool = false) -> Variant:
	var closest_num : float
	var closest_idx : int
	var closest_delta : float = 0.0
	var temp_delta : float = 0.0

	for i in range(array.size()):
		if array[i] == value:
			if !returnIndex:
				return array[i]
			elif returnIndex:
				return i
		temp_delta = abs(array[i]-value)
		if closest_delta == 0.0 or temp_delta < closest_delta:
			closest_num = array[i]
			closest_idx = i
		closest_delta = temp_delta
	if !returnIndex:
		return closest_num
	else:
		return closest_idx

## Remove duplicates from an array
func removeArrayDuplicates(array:Array) -> Array:
	var dict := {}
	for a in array:
		dict[a] = 1
	return dict.keys()

#endregion

#region Object and Node Tools
## Get ALL Children of a node
func get_all_children(node:Node) -> Array[Node]:
	var outputList : Array[Node] = []
	for n in node.get_children():
		if n.get_child_count() > 0:
			outputList.append(n)
			outputList.append_array(get_all_children(n))
		else:
			outputList.append(n)
	return outputList

## Enable or disable a node
func enableNode(node:Node,enable:bool):
	node.set_process(enable)
	node.set_physics_process(enable)
	node.visible = enable

## An easy way to set Collision Layer and Mask Values
func setCollisionLayerAndMaskValues(collision:CollisionObject3D,layers:Array[int],masks:Array[int]):
	for l in range(32):
		l += 1
		collision.set_collision_layer_value(l,false)
		collision.set_collision_mask_value(l,false)
	for l in layers:
		collision.set_collision_layer_value(l,true)
	for l in masks:
		collision.set_collision_mask_value(l,true)

## Check if an object is freed or is going to be freed
func isFreed(instance:Object) -> bool:
	if is_instance_valid(instance):
		if !instance.is_queued_for_deletion():
			return false
	return true

#endregion

#region Misc Tools
## Wait for a number of seconds
## Is corutine, must be used with await. ex: await waitForTime(1.0)
func waitForTime(time:float,process_always:bool = true,process_in_physics:bool = false,ignoreTimeScale:bool = false):
	var newTimer : SceneTreeTimer = get_tree().create_timer(time,process_always,process_in_physics,ignoreTimeScale)
	await newTimer.timeout

## Checks if the Current OS is SteamOS, as in, A Steam Deck or Steam Machine
## (Tested only on Steam Deck)
func isSteamDeck() -> bool:
	return OS.get_distribution_name() == "SteamOS"

#endregion
