return {
	pixelcode = [[
		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			float factor = pow(0.5 - tc.x, 2) + pow(0.5 - tc.y, 2);

			vec4 rcol = Texel(tex, tc);
			vec4 gcol = Texel(tex, tc + rcol.gb / 25 * factor);
			vec4 bcol = Texel(tex, tc + rcol.gr / 25 * factor);
			return vec4(rcol.r, gcol.g, bcol.b, bcol.a) * col;
		}
	]]
}
