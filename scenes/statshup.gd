extends Control

@onready var health_display_label: Label = $HealthDisplayLabel
@onready var base_damage_label: Label = $"../AttackUp/BaseDamageLabel"
@onready var crit_rate_label: Label = $"../CritRateUp/CritRateLabel"
@onready var crit_damage_multiplier_label: Label = $"../CritDmgUp/CritDamageMultiplierLabel"
@export var coin_display_label: Label
@export var coin_display_label2: Label

@export var player_stats: CharacterStats
@export var health_upgrade_cost: int = 10
@export var base_damage_upgrade_cost: int = 15
@export var crit_rate_upgrade_cost: int = 20
@export var crit_damage_upgrade_cost: int = 25

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		update_all_displays()

func _ready():
	if player_stats == null:
		push_warning("player_stats Resource not assigned in the editor!")
		return

	player_stats.resource_changed_custom.connect(update_all_displays)
	update_all_displays()
	update_coin_display()

func _claim_rewards():
	var popup = preload("res://scenes/drop_rate_item.tscn").instantiate()
	popup.connect("rewards_claimed", self._on_rewards_claimed)
	add_child(popup)

func _on_rewards_claimed(total_status: int) -> void:
	Startupcoin.coin_amount += total_status
	update_coin_display()
	print("Menerima reward coin:", total_status, " | Total coin sekarang:", Startupcoin.coin_amount)

func _on_IncreaseHealthButton_pressed():
	if player_stats == null: return
	if Startupcoin.coin_amount >= health_upgrade_cost:
		Startupcoin.coin_amount -= health_upgrade_cost
		player_stats.max_health_stat += 1
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Koin tidak cukup untuk upgrade Kesehatan!")

func _on_DecreaseHealthButton_pressed():
	if player_stats == null: return
	if player_stats.max_health_stat > 1:
		player_stats.max_health_stat -= 1
		Startupcoin.coin_amount += health_upgrade_cost
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Kesehatan sudah pada batas minimal.")

func _on_IncreaseBaseDamageButton_pressed():
	if player_stats == null: return
	if Startupcoin.coin_amount >= base_damage_upgrade_cost:
		Startupcoin.coin_amount -= base_damage_upgrade_cost
		player_stats.base_damage_stat += 1
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Koin tidak cukup untuk upgrade Base Damage!")

func _on_DecreaseBaseDamageButton_pressed():
	if player_stats == null: return
	if player_stats.base_damage_stat > 0:
		player_stats.base_damage_stat -= 1
		Startupcoin.coin_amount += base_damage_upgrade_cost
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Base Damage sudah pada batas minimal.")

func _on_IncreaseCritRateButton_pressed():
	if player_stats == null: return
	if Startupcoin.coin_amount >= crit_rate_upgrade_cost:
		Startupcoin.coin_amount -= crit_rate_upgrade_cost
		player_stats.crit_rate_stat = min(player_stats.crit_rate_stat + 0.01, 1.0)
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Koin tidak cukup untuk upgrade Critical Rate!")

func _on_DecreaseCritRateButton_pressed():
	if player_stats == null: return
	if player_stats.crit_rate_stat > 0.0:
		player_stats.crit_rate_stat = max(player_stats.crit_rate_stat - 0.01, 0.0)
		Startupcoin.coin_amount += crit_rate_upgrade_cost
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Critical Rate sudah pada batas minimal.")

func _on_IncreaseCritDamageMultiplierButton_pressed():
	if player_stats == null: return
	if Startupcoin.coin_amount >= crit_damage_upgrade_cost:
		Startupcoin.coin_amount -= crit_damage_upgrade_cost
		player_stats.crit_damage_multiplier_stat += 0.01
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Koin tidak cukup untuk upgrade Critical Damage Multiplier!")

func _on_DecreaseCritDamageMultiplierButton_pressed():
	if player_stats == null: return
	if player_stats.crit_damage_multiplier_stat > 1.0:
		player_stats.crit_damage_multiplier_stat -= 0.01
		Startupcoin.coin_amount += crit_damage_upgrade_cost
		ResourceSaver.save(player_stats, player_stats.resource_path)
		update_coin_display()
	else:
		print("Critical Damage Multiplier sudah pada batas minimal (1.0x).")

func update_health_display():
	if player_stats == null: return
	health_display_label.text = str(player_stats.max_health_stat)

func update_base_damage_display():
	if player_stats == null: return
	base_damage_label.text = str(player_stats.base_damage_stat)

func update_crit_rate_display():
	if player_stats == null: return
	crit_rate_label.text = str(snapped(player_stats.crit_rate_stat * 100.0, 0.1)) + "%"

func update_crit_damage_multiplier_display():
	if player_stats == null: return
	var bonus_percent = (player_stats.crit_damage_multiplier_stat - 1.0) * 100.0
	crit_damage_multiplier_label.text = "+" + str(snapped(bonus_percent, 0.1)) + "%"

func update_coin_display():
	coin_display_label.text = str(Startupcoin.coin_amount)
	coin_display_label2.text = str(Startupcoin.coin_amount)

func update_all_displays():
	update_health_display()
	update_base_damage_display()
	update_crit_rate_display()
	update_crit_damage_multiplier_display()
	update_coin_display()
