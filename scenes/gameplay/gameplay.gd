extends Node2D

onready var level = $Level
onready var ui = $UI
onready var bgm = $BGM


func _ready() -> void:
	bgm.play()


func _on_HitArea_enemy_arrived(enemy):
	ui.hp.reduce_by(enemy.enemy_resource.damage)


func pre_start(params):
	if not params.has("level_path"):
		load_level(params.level_path)
	else:
		load_level(params.level_path)


func start():
	for ha in get_tree().get_nodes_in_group("HitAreas"):
		var hit_area: HitArea = ha
		hit_area.connect("enemy_arrived", self, "_on_HitArea_enemy_arrived")



func load_level(level_scene_path):
	level.replace_by_instance(load(level_scene_path))
	update_ui()


func update_ui():
	Game.money = 500
	var wave_manager: WaveManager = get_tree().get_nodes_in_group("WaveManager")[0]
	ui.wave.set_wave(0, wave_manager.waves.size())
	ui.hp.set_hp(20)
	ui.money.set_money(Game.money)
	wave_manager.connect("wave_started", self, "_on_wave_manager_wave_started")
	ui.insufficient_money_popup.register_signals()


func _on_wave_manager_wave_started(wave_id):
	ui.wave.set_wave(wave_id + 1)
