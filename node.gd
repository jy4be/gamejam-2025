extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ob1: Test = Test.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	


func _on_node_ready() -> void:
	pass # Replace with function body.
