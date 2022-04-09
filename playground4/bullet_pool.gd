extends Node3D

@export var bullet_scene: PackedScene

func make_bullet(
		pos: Vector3,
		velocity: Vector3,
		lifetime: float,
		damage: int,
		damage_range: float,
		speed: float,
		size: float,
		ricochets: int,
		ricochet_damage: float,
		damage_falloff: float,
		homing_speed: float,
		homing_distance: float,
		explosion_radius: float,
		pierce: int,
		shatter: int,
		shatter_damage: float,
		toxin: float,
		toxin_duration: float):
	var inst = bullet_scene.instantiate()
	add_child(inst)
	inst.global_transform.origin = pos
	inst.global_transform = inst.global_transform.looking_at(pos+velocity)
	inst.direction = velocity.normalized()
	inst.lifetime = lifetime
	inst.damage = damage
	inst.damage_range = damage_range
	inst.speed = speed
	inst.size = size
	inst.ricochets = ricochets
	inst.ricochet_damage = ricochet_damage
	inst.damage_falloff = damage_falloff
	inst.homing_speed = homing_speed
	inst.homing_distance = homing_distance
	inst.explosion_radius = explosion_radius
	inst.pierce = pierce
	inst.shatter = shatter
	inst.shatter_damage = shatter_damage
	inst.toxin = toxin
	inst.toxin_duration = toxin_duration
	pass
