extends Control

@export var coin_display_label: Label
@export var coin_display_label2: Label

func _ready():
	update_coin_display()

# Fungsi untuk memanggil popup rewards dan menghubungkan sinyalnya
func _claim_rewards():
	var popup = preload("res://scenes/drop_rate_item.tscn").instantiate()
	popup.connect("rewards_claimed", self._on_rewards_claimed)
	add_child(popup)

# Fungsi callback ketika rewards diklaim
func _on_rewards_claimed(total_status: int) -> void:
	Startupcoin.coin_amount += total_status
	update_coin_display()
	print("Menerima reward coin:", total_status, " | Total coin sekarang:", Startupcoin.coin_amount)

# Fungsi untuk memperbarui tampilan jumlah koin
func update_coin_display():
	if coin_display_label:
		coin_display_label.text = str(Startupcoin.coin_amount)
	if coin_display_label2:
		coin_display_label2.text = str(Startupcoin.coin_amount)
