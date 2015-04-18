return {
	default = "idle",

	states = {
		["idle"] = { image = "spider_idle.png", fw = 32, fh = 32, delay = 1 },
		["walk"] = { image = "spider_walk.png", fw = 32, fh = 32, delay = 0.1 }
	},

	properties = {
		["state"] = { value = 0 }
	},

	transitions = {
		{
			from = "idle", to = "walk",
			property = "state", value = 1
		},
		{
			from = "walk", to = "idle",
			property = "state", value = 0
		}
	}
}
