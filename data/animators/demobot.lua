return {
	default = "idle",

	states = {
		["idle"] = { image = "demobot_idle.png", fw = 40, fh = 40, delay = 0.1, oy = 37 },
		["run"] = { image = "demobot_run.png", fw = 32, fh = 40, delay = 0.1, oy = 37 },
		["fire"] = { image = "demobot_fire.png", fw = 32, fh = 40, delay = 0.15, oy = 37 },
		["linked"] = { image = "demobot_linked.png", fw = 40, fh = 40, delay = 0.05, oy = 37 }
	},

	properties = {
		["state"] = { value = 0 },
	},

	transitions = {
		{
			from = "any", to = "idle",
			property = "state", value = 0
		},
		{
			from = "any", to = "run",
			property = "state", value = 1
		},
		{
			from = "any", to = "fire",
			property = "state", value = 2
		},
		{
			from = "any", to = "linked",
			property = "state", value = 3
		}
	}
}
