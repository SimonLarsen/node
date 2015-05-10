return {
	default = "idle",

	states = {
		["idle"] = { image = "player_idle.png", fw = 48, fh = 48, delay = 0.14, oy = 46 },
		["run"] = { image = "player_run.png", fw = 50, fh = 48, delay = 0.1, oy = 46 },
		["kick"] = { image = "player_kick.png", fw = 89, fh = 48, delay = 0.06, oy = 46 },
		["hit"] = { image = "player_hit.png", fw = 48, fh = 48, delay = 0.1, oy = 46 },
		["trigger"] = { image = "player_trigger.png", fw = 50, fh = 48, delay = 0.06, oy = 46 },
		["dash"] = { image = "player_dash.png", fw = 48, fh = 48, delay = 1, oy = 46 },
		["die"] = { image = "player_death.png", fw = 50, fh = 48, delay = 0.1, loop = false, oy = 46 },
		["spawn"] = { image = "player_spawn.png", fw = 48, fh = 53, delay = 0.1, loop = false, oy = 47 }
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
		},
		{
			from = "any", to = "dash",
			property = "state", value = 5
		},
		{
			from = "any", to = "die",
			property = "state", value = 6
		},
		{
			from = "any", to = "spawn",
			property = "state", value = 7
		}
	}
}
