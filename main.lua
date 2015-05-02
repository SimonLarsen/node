require("slam.slam")
class = require("middleclass.middleclass")
gamestate = require("hump.gamestate")
Resources = require("Resources")
Entity = require("Entity")
Timer = require("hump.timer")
Scene = require("Scene")
Keyboard = require("Keyboard")
Mouse = require("Mouse")
util = require("util")
Animation = require("Animation")
Animator = require("Animator")
require("mymath")

local MainMenuScene = require("MainMenuScene")
local GameScene = require("GameScene")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	updateViewport()

	music = love.audio.newSource("data/music/redemption.ogg", "stream")
	music:setLooping(true)
	music:setVolume(0.5)
	love.audio.play(music)

	gamestate.registerEvents()
	gamestate.switch(MainMenuScene())
end

function updateViewport()
	local width, height, flags = love.window.getMode()

	SCALE = math.max(1, math.ceil(math.min(width, height) / 500))

	WIDTH = math.ceil(width / SCALE)
	HEIGHT = math.ceil(height / SCALE)

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
end

function toggleFullscreen()
	local fullscreen = not love.window.getFullscreen()
	if fullscreen then
		love.window.setMode(0, 0, {fullscreen = true, vsync = true})
	else
		love.window.setMode(800, 600, {fullscreen = false, vsync = true})
	end
	updateViewport()
end

function love.gui()
	gamestate.current():gui()
end

function love.keypressed(k)
	if k == "f11" or
	k == "return" and (love.keyboard.isDown("lalt", "ralt")) then
		toggleFullscreen()
	end
	Keyboard.keypressed(k)
end

function love.keyreleased(k)
	Keyboard.keyreleased(k)
end

function love.mousepressed(x, y, button)
	Mouse.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Mouse.mousereleased(x, y, button)
end

function love.resize(w, h)
	updateViewport()
end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
        for i=1,3 do love.math.random() end
    end

    if love.event then
        love.event.pump()
    end

    love.load(arg)

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        love.update(dt)

		Mouse.clear()
		Keyboard.clear()

        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()

			love.graphics.setCanvas(canvas)

			love.draw()
			love.gui()

			love.graphics.push()

			love.graphics.scale(SCALE, SCALE)
			love.graphics.setCanvas()
			love.graphics.draw(canvas, 0, 0)

			love.graphics.pop()

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
