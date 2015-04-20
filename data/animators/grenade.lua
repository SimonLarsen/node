return {
	default = "idle",

	states = {
		["idle"] = { image = "grenade.png", fw = 14, fh = 14, delay = 1 },
		["detonate"] = { image = "grenade_detonate.png", fw = 14, fh = 14, delay = 0.1 }
	},

	properties = {
		["state"] = { value = 0 }
	},

	transitions = {
		{
			from = "idle", to = "detonate",
			property = "state", value = 1
		}
	}
}
