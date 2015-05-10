return {
	pixelcode = [[
		extern Image disp;
		extern float offset;
		extern float factor;

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec4 dpix = Texel(disp, vec2(offset, tc.y));
			vec2 offset = vec2((dpix.r - 0.5) * 0.15 * factor, 0);

			return Texel(tex, tc + offset) * col;
		}
	]]
}
