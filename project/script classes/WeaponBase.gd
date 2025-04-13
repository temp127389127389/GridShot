class_name Weapon

func get_current_accuracy(ads_factor) -> float:
	# the current accuracy is dependent on ads_factor, which is
	#   dependent on the to_ads animation progress
	
	var spread_delta = self.base_spread - self.ads_spread
	var current_spread = self.base_spread - spread_delta * ads_factor
	
	return current_spread
