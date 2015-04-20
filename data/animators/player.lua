return {
	default = "idle",

	states = {
		["idle"] = { image = "player_idle.png", fw = 20, fh = 48, delay = 0.14 },
		["run"] = { image = "player_run.png", fw = 50, fh = 48, delay = 0.1 },
		["kick"] = { image = "player_kick.png", fw = 89, fh = 48, delay = 0.06 },
		["hit"] = { image = "player_hit.png", fw = 48, fh = 48, delay = 0.1 },
		["trigger"] = { image = "player_trigger.png", fw = 27, fh = 48, delay = 0.1 }
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
			from = "any", to = "run",
			property = "state", value = 1
		},
		{
			from = "any", to = "kick",
			property = "state", value = 2
		},
		{
			from = "any", to = "hit",
			property = "state", value = 3
		},
		{
			from = "any", to = "trigger",
			property = "state", value = 4
		}
	}
}
