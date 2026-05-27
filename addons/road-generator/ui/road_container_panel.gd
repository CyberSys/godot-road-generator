@tool
# Panel which is added to UI and used to trigger callbacks to update RoadContainers
extends VBoxContainer

signal export_gltf
signal bake_roadlanes(container: Array)

@onready var bake_button: Button = $bake_roadlanes

var sel_container: RoadContainer

var _edi : set = set_edi

func set_edi(value):
	_edi = value
	update_road_container_panel()


func update_selected_road_container(object: RoadContainer):
	if is_instance_valid(sel_container) and sel_container.on_road_updated.is_connected(_container_updated_callback):
		sel_container.on_road_updated.disconnect(_container_updated_callback)
	sel_container = object
	sel_container.on_road_updated.connect(_container_updated_callback)
	update_road_container_panel()


func update_road_container_panel() -> void:
	if not is_instance_valid(sel_container):
		return
	bake_button.disabled = not sel_container.generate_ai_lanes


func _on_export_gltf_pressed() -> void:
	export_gltf.emit()


func _container_updated_callback(segs: Array) -> void:
	update_road_container_panel()


func _on_bake_roadlanes_pressed() -> void:
	bake_roadlanes.emit(sel_container.get_roadpoints() + sel_container.get_intersections())
