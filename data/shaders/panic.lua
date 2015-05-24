return {
	pixelcode = [[
		extern float factor;

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			float offx = tc.x - 0.5;
			float offy = tc.y - 0.5;

			vec4 rcol = Texel(tex, tc + vec2(offx, offy)*factor);
			vec4 gcol = Texel(tex, tc);
			vec4 bcol = Texel(tex, tc + vec2(-offx, -offy)*factor);

			return vec4(rcol.r, gcol.g, bcol.b, rcol.a);
		}
	]]
}
