Settings = {
    general = {
        language = "en",
        theme = "light",
        notifications = true,
    },

    -- User profile settings
    userProfile = {
        username = "nathan",
        email = "nathan@bogo.io",
        avatar = "default.png",
    },

    audio = {
        volume = 0.5,  -- Volume level from 0.0 to 1.0
        mute = false,  -- Mute audio
    },

    video = {
        brightness = 1.0,  -- Brightness level from 0.0 to 1.0
    }
}

require ('settings.settingsBackground')
local Button = require('utils.Button')

function Settings:load()
    love.window.setTitle("Settings")
    love.window.setMode(800, 600, {resizable = false, vsync = true})
    -- Load settings from a file or database if needed
    -- For now, we just initialize with default values

    self.buttons = {
        Button("Back", 10, 200, 150, 30, function()
            print("Back button pressed!")
            returnToLauncher()  -- Function to return to the launcher state
            -- love.event.quit("restart")
        end),

        Button("Save Settings", 10, 240, 150, 30, function()
            self:save()
        end),

        Button("Mute Volume", 10, 280, 150, 30, function()
            love.audio.setVolume(0)
        end),

        Button("Unmute Volume", 10, 320, 150, 30, function()
            love.audio.setVolume(1)
        end)
    }

    SettingsBackground:load()
end

function Settings:update(dt)
    if not self.buttons then return end
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(self.buttons) do
        btn:update(mx, my)
    end
end



function Settings:draw()
    SettingsBackground:draw()
    love.graphics.print("Settings", 10, 10)
    love.graphics.print("Username: " .. self.userProfile.username, 10, 90)
    love.graphics.print("Email: " .. self.userProfile.email, 10, 110)
    love.graphics.print("Avatar: " .. self.userProfile.avatar, 10, 130)
    love.graphics.print("Volume: " .. self.audio.volume, 10, 150)
    love.graphics.print("Brightness: " .. self.video.brightness, 10, 170)

    for _, btn in ipairs(self.buttons) do
        btn:draw()
    end
end

function Settings:save()
    -- Save settings to a file or database
    print("Saved button pressed!")
end

function Settings:mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(self.buttons) do
            btn:checkClick(x, y)
        end
    end
end

function Settings:keypressed(key)
    if key == "escape" then
        -- Handle escape key to go back or close settings
        print("Escape pressed, going back to launcher.")
        _G.returnToLauncher()
    end
end

return Settings