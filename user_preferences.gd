class_name UserPreferences extends Resource

#Default values for user preferences
@export var precision: int = 1
@export var interval: bool = true
@export var fraction: int = 1

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
