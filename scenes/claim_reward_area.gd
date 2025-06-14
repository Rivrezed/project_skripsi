extends Area2D

## --- Variabel yang bisa diatur dari Inspector ---

# 1. Drag & drop node AnimationPlayer kamu ke sini.
@export var animation_player: AnimationPlayer

# 2. Drag & drop node AudioStreamPlayer2D kamu ke sini.
@export var sfx_player: AudioStreamPlayer2D # BARU

# 3. Atur Path ke node yang akan menerima reward (misal: UI, GameManager).
@export var reward_target: NodePath


## --- Variabel Internal ---
# Flag untuk memastikan reward hanya bisa diambil sekali.
var is_claimed: bool = false

# --------------------------------------------------

func _ready():
	connect("body_entered", _on_body_entered)

## Fungsi ini akan dijalankan saat player menyentuh area.
func _on_body_entered(body: Node) -> void:
	# Cek apakah body yang masuk adalah Player dan reward belum pernah diklaim.
	if body.name == "Player2" and not is_claimed:
		# Pastikan semua node yang dibutuhkan sudah di-assign dari inspector.
		if animation_player == null or sfx_player == null:
			push_warning("Pastikan AnimationPlayer dan SFX Player sudah di-assign pada Area2D.")
			return

		# Tandai bahwa reward sudah dalam proses klaim agar tidak ter-trigger berulang kali.
		is_claimed = true

		# 1. Mainkan SFX dan animasi secara bersamaan.
		sfx_player.play() # BARU
		animation_player.play("open")

		# 2. Tunggu (await) sampai animasi selesai.
		await animation_player.animation_finished

		# 3. Setelah animasi selesai, jalankan fungsi claim_rewards.
		if has_node(reward_target):
			var target_node = get_node(reward_target)
			if target_node.has_method("_claim_rewards"):
				target_node._claim_rewards()
			else:
				push_warning("Target node tidak memiliki fungsi _claim_rewards.")
		else:
			push_warning("Reward target tidak ditemukan.")
		
		# Opsional: Matikan collision shape agar tidak bisa di-trigger lagi sama sekali.
		# get_node("CollisionShape2D").disabled = true
