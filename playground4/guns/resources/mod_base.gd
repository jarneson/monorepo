extends Resource
class_name GunModBase

# Damage per shot. Base =  1, Min = 1
@export var add_damage: int = 0
@export var mult_damage: float = 1.0

# Damage fuzziness. Base = 0, Min = 0, Max = ??
@export var add_damage_range: float = 0.0
@export var mult_damage_range: float = 1.0

# Projectile speed. Base = 75, Min = 25, Max = ??
@export var add_speed: float = 0.0
@export var mult_speed: float = 1.0

# Bullets per shot. Base = 1, Min = 1, Max = ??  <- perf
@export var add_bullets: int = 0
@export var mult_bullets: float = 1.0

# Cooldown between shots, Base = 1, Min = 0.1, Max = ??
@export var add_cooldown: float = 0.0
@export var mult_cooldown: float = 1.0

# Projectile Size, Base = 1, Min = 0.1, Max = ??
@export var add_size: float = 0.0
@export var mult_size: float = 1.0

# Projectile Spread, Base = 15, Min = 0, Max = 45
@export var add_spread: float = 0.0
@export var mult_spread: float = 1.0

# How much static geometry a bullet will ricochet off of, Base = 0, Min = 0, NoMax
@export var add_ricochet: int = 0
@export var mult_ricochet: float = 1.0

# Damage multiplier for each ricochet
@export var add_ricochet_damage: float = 0.0
@export var mult_ricochet_damage: float = 1.0

# Damage Falloff/Gain by Distance, Base = 0, Min = -0.1, Max = 0.1
@export var add_damage_falloff: float = 0.0
@export var mult_damage_falloff: float = 1.0

# How fast projectils turn to chase targets, Base = 0, Min = 0, Max = 180
@export var add_homing_speed: float = 0.0
@export var mult_homing_speed: float = 1.0

# How close a target needs to be for homing, Base = 10, Min = 0, Max = ?? <- perf
@export var add_homing_distance: float = 0.0
@export var mult_homing_distance: float = 1.0

# How large an explosion occurs on impact, Base = 0, Min = 0, Max = ??
@export var add_explosion_radius: float = 0.0
@export var mult_explosion_radius: float = 1.0

# How many enemies a projectile will pierce, Base = 0, Min = 0, NoMax
@export var add_pierce: int = 0
@export var mult_pierce: float = 1.0

# How many projectiles will spawn on a collision with something, Base = 0, Min = 0, Max = ?? <- perf
@export var add_shatter: int = 0
@export var mult_shatter: float = 1.0

# What percentage of damage a shattered projectile does, Base = 0.2, Min = 0.1, NoMax
@export var add_shatter_damage: float = 0.0
@export var mult_shatter_damage: float = 1.0

# What percentage of damage is done over time, Base = 0, Min = 0, NoMax
@export var add_toxin: float = 0.0
@export var mult_toxin: float = 1.0

# How long damage over time lasts, Base = 3, Min = 1, NoMax
@export var add_toxin_duration: float = 0.0
@export var mult_toxin_duration: float = 0.0

# How much bonus damage is done per successive hit
@export var add_accuracy_buff: float = 0.0
@export var mult_accuracy_buff: float = 1.0

# How much life is stolen as a percentage of damage dealt
@export var add_lifesteal: float = 0.0
@export var mult_lifesteal: float = 1.0
