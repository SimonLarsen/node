local shaders = {
	shader = {},
	matrix = {}
}

shaders.shader.convolution3x3 = {
	pixelcode = [[
		uniform vec2 offset[9];
		uniform number kernel[9];

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec4 sum = vec4(0);
			for(int i = 0; i < 9; i++) {
				vec4 c = col * Texel(tex, tc+offset[i]);
				sum += c * kernel[i];
			}
			return sum;
		}
	]]
}

shaders.shader.trishader = {
	pixelcode = [[
		uniform vec2 screen;
		uniform Image bg;
		uniform vec2 offset[9];
		uniform number kernel[9];

		vec4 effect(vec4 col, Image tex, vec2 tc, vec2 sc) {
			vec4 sum = vec4(0);
			for(int i = 0; i < 9; ++i) {
				vec4 c = col * Texel(tex, tc+offset[i]);
				sum += c * kernel[i];
			}
			vec2 rsc = vec2(sc.x/screen.x, 1.0 - sc.y/screen.y);
			return sum * Texel(bg, rsc);
		}
	]]
}

shaders.matrix.sharpen3x3 = {
	 0, -1,  0,
	-1,  5, -1,
	 0, -1,  0
}

shaders.matrix.edge3x3 = {
	-1, -1, -1,
	-1,  8, -1,
	-1, -1, -1
}

shaders.matrix.convolve3x3 = {
	0.0, 0.5, 0.0,
	0.5, 1.0, 0.5,
	0.0, 0.5, 0.0
}

shaders.matrix.normalize3x3 = {
	  0, 1/6,   0,
	1/6, 1/3, 1/6,
	  0, 1/6,   0
}

shaders.matrix.gaussianblur3x3 = {
	1/16, 1/8, 1/16,
	 1/8, 1/4,  1/8,
	1/16, 1/8, 1/16
}

shaders.generateOffsets3x3 = function(w, h)
	local xoff = 1 / w
	local yoff = 1 / h
	return {
		{-xoff, yoff},	{0, yoff},	{xoff, yoff},
		{-xoff, 0},		{0,0},		{xoff, 0},
		{-xoff, -yoff},	{0, -yoff},	{xoff, -yoff}
	}
end


return shaders
