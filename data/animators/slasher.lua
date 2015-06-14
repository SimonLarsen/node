return {
	default = "idle",

	states = {
		["idle"] = { image = "slasher_idle.png", fw = 36, fh = 49, delay = 0.1, oy = 48 },
		["dash"] = { image = "slasher_dash.png", fw = 61, fh = 51, delay = 0.1, oy = 50, loop = false },
		["slash"] = { image = "slasher_slash.png", fw = 74, fh = 70, delay = 0.2/10, ox = 34, oy = 63, loop = false },
		["linked"] = { image = "slasher_linked.png", fw = 61, fh = 51, delay = 0.05, oy = 50 }
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
			from = "any", to = "dash",
			property = "state", value = 1
		},
		{
			from = "any", to = "slash",
			property = "state", value = 2
		},
		{
			from = "any", to = "linked",
			property = "state", value = 3
		},
	}
}
