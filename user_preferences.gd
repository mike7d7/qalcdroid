class_name UserPreferences extends Resource

#Default values for user preferences
@export var precision: int = 1
@export var interval: bool = true
@export var fraction: int = 1
@export var angle_unit: int = 1
@export var tab_swipe: bool = true

#Also save history in user preferences
@export var history: PackedStringArray = []

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.res")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.res") as UserPreferences
	if !res:
		res = UserPreferences.new()
		
	return res
