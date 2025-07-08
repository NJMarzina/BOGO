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

function Settings:load()
    love.window.setTitle("Settings")
    love.window.setMode(800, 600, {resizable = false, vsync = true})
    -- Load settings from a file or database if needed
    -- For now, we just initialize with default values

    SettingsBackground:load()
end

function Settings:update(dt)
    -- Update settings if needed, e.g., based on user input
end

function Settings:draw()
    SettingsBackground:draw()
    -- Draw settings UI elements, e.g., text fields, buttons
    love.graphics.print("Settings", 10, 10)
    --love.graphics.print("Language: " .. self.general.language, 10, 30)
    --love.graphics.print("Theme: " .. self.general.theme, 10, 50)
    --love.graphics.print("Notifications: " .. tostring(self.general.notifications), 10, 70)
    love.graphics.print("Username: " .. self.userProfile.username, 10, 90)
    love.graphics.print("Email: " .. self.userProfile.email, 10, 110)
    love.graphics.print("Avatar: " .. self.userProfile.avatar, 10, 130)

    love.graphics.print("Volume: " .. self.audio.volume, 10, 150)
    love.graphics.print("Brightness: " .. self.video.brightness, 10, 170)
end

function Settings:save()
    -- Save settings to a file or database
end

return Settings