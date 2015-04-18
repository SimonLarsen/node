return {
	default = "idle",

	states = {
		["idle"] = { image = "robot_idle.png", fw = 40, fh = 40, delay = 0.1 },
		["run"] = { image = "robot_run.png", fw = 40, fh = 40, delay = 0.1 }
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
