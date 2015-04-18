return {
	default = "idle",

	states = {
		["idle"] = { image = "player_idle.png", fw = 32, fh = 48, delay = 0.1 },
		["run"] = { image = "player_run.png", fw = 50, fh = 48, delay = 0.1 }
	},

	properties = {
		["state"] = { value = 0 }
	},

	transitions = {
		{
			from = "idle", to = "run",
			property = "state", value = 1
		},
		{
			from = "run", to = "idle",
			property = "state", value = 0
		}
	}
}
