return {
	pixelcode = [[
		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec2 offset = vec2(0.5 - tc.x, 0.5 - tc.y) / 10;

			vec4 pix = Texel(tex, tc);
			vec4 pix2 = Texel(tex, tc+offset);

			return (pix/2 + pix2/2) * col;
		}
	]]
}
