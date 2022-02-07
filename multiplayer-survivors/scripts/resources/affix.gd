extends Resource
class_name Affix

export(Resource) var provide_ability: Resource

export var reduced_cooldown: int
export var projectile_speed: int
export var duration: int
export var area: int
export var run_speed: int

func to_string() -> String:
	var lines = PoolStringArray()
	if provide_ability:
		lines.push_back("Provides Ability: %s" % provide_ability.name)
	if reduced_cooldown != 0:
		lines.push_back("%s Reduced Cooldown" % reduced_cooldown)
	if projectile_speed != 0:
		lines.push_back("%s Projectile Speed" % projectile_speed)
	if duration != 0:
		lines.push_back("%s Effect Duration" % duration)
	if area != 0:
		lines.push_back("%s Area" % area)
	if run_speed != 0:
		lines.push_back("%s Run Speed" % run_speed)
	return lines.join("\n")
