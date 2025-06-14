# GlobalGameData.gd (your autoload script)
extends Node

var coin_amount: int = 100

func reset_coins_to_default():
	coin_amount = 100
	print("Coin amount reset to default: ", coin_amount)
