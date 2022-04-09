static func compute_damage(mods) -> int:
	var v: int = 0
	for m in mods:
		v += m.add_damage
	for m in mods:
		v *= m.mult_damage
	return maxi(v, 1)

static func compute_damage_range(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_damage_range
	for m in mods:
		v *= m.mult_damage_range
	return clampf(v, 0.0, 1.0)

static func compute_speed(mods) -> float:
	var v: float = 75.0
	for m in mods:
		v += m.add_speed
	for m in mods:
		v *= m.mult_speed
	return maxf(v, 10.0)

static func compute_bullets(mods) -> int:
	var v: int = 1
	for m in mods:
		v += m.add_bullets
	for m in mods:
		v *= m.mult_bullets
	return clampi(v, 1, 100)

static func compute_cooldown(mods) -> float:
	var v: float = 1
	for m in mods:
		v += m.add_cooldown
	for m in mods:
		v *= m.mult_cooldown
	return clampf(v, 0.1, 10.0)

static func compute_size(mods) -> float:
	var v: float = 1
	for m in mods:
		v += m.add_size
	for m in mods:
		v *= m.mult_size
	return clampf(v, 0.1, 10.0)

static func compute_spread(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_spread
	for m in mods:
		v *= m.mult_spread
	return clampf(v, 0.0, 1.0)

static func compute_ricochet(mods) -> int:
	var v: int = 0
	for m in mods:
		v += m.add_ricochet
	for m in mods:
		v *= m.mult_ricochet
	return maxi(v, 0)

static func compute_ricochet_damage(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_ricochet_damage
	for m in mods:
		v *= m.mult_ricochet_damage
	return maxf(v, 0.0)

static func compute_damage_faloff(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_damage_faloff
	for m in mods:
		v *= m.mult_damage_falloff
	return clampf(v, -0.1, 0.1)

static func compute_homing_speed(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_homing_speed
	for m in mods:
		v *= m.mult_homing_speed
	return clampf(v, 0.0, 180.0)

static func compute_homing_distance(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_homing_distance
	for m in mods:
		v *= m.mult_homing_distance
	return clampf(v, 0.0, 25.0)

static func compute_explosion_radius(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_explosion_radius
	for m in mods:
		v *= m.mult_explosion_radius
	return maxf(v, 0.0)

static func compute_pierce(mods) -> int:
	var v: int = 0
	for m in mods:
		v += m.add_pierce
	for m in mods:
		v *= m.mult_pierce
	return maxi(v, 0)

static func compute_shatter(mods) -> int:
	var v: int = 0
	for m in mods:
		v += m.add_shatter
	for m in mods:
		v *= m.mult_shatter
	return clampi(v, 0, 100)

static func compute_shatter_damage(mods) -> float:
	var v: float = 0.2
	for m in mods:
		v += m.add_shatter_damage
	for m in mods:
		v *= m.mult_shatter_damage
	return maxf(v, 0.1)

static func compute_toxin(mods) -> float:
	var v: float = 0.0
	for m in mods:
		v += m.add_toxin
	for m in mods:
		v *= m.mult_toxin
	return maxf(v, 0.0)

static func compute_toxin_duration(mods) -> float:
	var v: float = 3.0
	for m in mods:
		v += m.add_toxin_duration
	for m in mods:
		v *= m.mult_toxin_duration
	return maxf(v, 1.0)

static func compute_accuracy_buff(mods) -> float:
	var v: float = 3.0
	for m in mods:
		v += m.add_accuracy_buff
	for m in mods:
		v *= m.mult_accuracy_buff
	return maxf(v, 1.0)

static func compute_lifesteal(mods) -> float:
	var v: float = 3.0
	for m in mods:
		v += m.add_lifesteal
	for m in mods:
		v *= m.mult_lifesteal
	return maxf(v, 0.0)

static func random_mod() -> GunModBase:
	var m := GunModBase.new()
	m.mult_speed = randf_range(0.5, 2.0)
	m.add_bullets = randi_range(15, 25)
	m.add_ricochet = randi_range(0, 2)
	m.add_spread = pow(randf_range(0.0, 1.0), 4)
	m.mult_cooldown = randf_range(0.2, 1.5)
	m.mult_size = randf_range(0.2, 5.0)
	return m
