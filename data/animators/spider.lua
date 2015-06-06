return {
	default = "idle",

	states = {
		["idle"] = { image = "spider_idle.png", fw = 32, fh = 32, delay = 1 },
		["walk"] = { image = "spider_walk.png", fw = 32, fh = 32, delay = 0.08 },
		["alert"] = { image = "spider_alert.png", fw = 32, fh = 32, delay = 0.07 },
		["charge"] = { image = "spider_walk.png", fw = 32, fh = 32, delay = 0.04 },
		["linked"] = { image = "spider_linked.png", fw = 32, fh = 32, delay = 0.05 }
	},

	properties = {
		["state"] = { value = 0 }
	},

	transitions = {
		{
			from = "any", to = "idle",
			property = "state", value = 0
		},
		{
			from = "any", to = "walk",
			property = "state", value = 1
		},
		{
			from = "any", to = "alert",
			property = "state", value = 2
		},
		{
			from = "any", to = "charge",
			property = "state", value = 3
		},
		{
			from = "any", to = "linked",
			property = "state", value = 4
		}
	}
}
