return {
	default = "run",

	states = {
		["run"] = { image = "sumo_run.png", fw = 52, fh = 47, delay = 0.1, oy = 46 },
		["fire"] = { image = "sumo_fire.png", fw = 70, fh = 67, delay = 0.1, oy = 66 },
		["linked"] = { image = "sumo_linked.png", fw = 52, fh = 47, delay = 0.05, oy = 46 }
	},

	properties = {
		["state"] = { value = 1 },
	},

	transitions = {
		{
			from = "run", to = "fire",
			property = "state", value = 2
		},
		{
			from = "fire", to = "run",
			property = "state", value = 1
		},
		{
			from = "any", to = "linked",
			property = "state", value = 3
		},
		{
			from = "linked", to = "run",
			property = "state", value = 1
		}
	}
}
