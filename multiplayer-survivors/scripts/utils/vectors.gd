const pixels_to_meters = 32.0
static func Vector2To3(v: Vector2) -> Vector3:
	return Vector3(v.x, 0, -v.y) / pixels_to_meters

static func Vector3To2(v: Vector3) -> Vector2:
	return Vector2(v.x, -v.z) * pixels_to_meters
