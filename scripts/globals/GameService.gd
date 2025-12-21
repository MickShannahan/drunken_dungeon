extends Node

func modify_gold(gold_amount: int):
	GameState.current_gold += max(0, GameState.current_gold + gold_amount)
