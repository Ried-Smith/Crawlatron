extends Container

const skill_button = preload("res://Scenes/skill.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var num_skills = 6
	for n in range(num_skills):
		var new_skill = skill_button.instantiate()
		new_skill.text = "[center]SKILL #" + str(n+1)+"[/center]" 
		add_child(new_skill)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
