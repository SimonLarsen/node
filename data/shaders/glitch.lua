return {
	pixelcode = [[
		extern Image disp;
		extern float factor;

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec4 dpix = Texel(disp, vec2(0, tc.y));
			vec2 offset = vec2((dpix.r - 0.5) * 0.25 * factor, 0);

			return Texel(tex, tc + offset) * col;
		}
	]]
}
