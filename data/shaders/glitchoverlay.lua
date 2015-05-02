return {
	pixelcode = [[
		extern Image overlay;
		extern vec2 screen;

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			sc = sc / screen;
			sc.y = 1 - sc.y;

			vec4 pix1 = Texel(tex, tc);
			vec4 pix2 = Texel(overlay, sc);
			return (0.3 * max(pix1, pix2) + 0.7 * pix1) * col;
			return Texel(overlay, sc);
		}
	]]
}
