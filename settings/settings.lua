Settings = {
    general = {
        language = "en",
        theme = "dark",
        notifications = true,
        fullscreen = false,
    },

    -- User profile settings
    userProfile = {
        username = "nathan",
        email = "nathan@bogo.io",
        avatar = "default.png",
        level = 1,
        experience = 0,
    },

    audio = {
        masterVolume = 0.7,
        musicVolume = 0.5,
        sfxVolume = 0.8,
        mute = false,
    },

    video = {
        brightness = 1.0,
        contrast = 1.0,
        vsync = true,
        showFPS = false,
    },

    gameplay = {
        autoSave = true,
        difficulty = "normal",
        showTutorials = true,
        animationSpeed = 1.0,
    }
}

require('settings.settingsBackground')
local Button = require('utils.Button')
local GameState = require('utils.GameState')

function Settings:load()
    love.window.setTitle("Settings")
    love.window.setMode(1000, 700, {resizable = false, vsync = true})

    self:createButtons()
    SettingsBackground:load()
end

function Settings:createButtons()
    local buttonWidth = 180
    local buttonHeight = 35
    local leftColumn = 20
    local rightColumn = 220
    local startY = 100

    self.buttons = {
        -- Navigation buttons
        Button("< Back", leftColumn, startY, buttonWidth, buttonHeight, function()
            print("Back button pressed!")
            GameState:goBack()
        end),

        Button("Main Menu", rightColumn, startY, buttonWidth, buttonHeight, function()
            print("Returning to launcher!")
            _G.returnToLauncher()
        end),

        -- Audio controls
        Button("Volume: " .. math.floor(self.audio.masterVolume * 100) .. "%", leftColumn, startY + 50, buttonWidth, buttonHeight, function()
            self.audio.masterVolume = (self.audio.masterVolume + 0.1) % 1.1
            if self.audio.masterVolume > 1.0 then self.audio.masterVolume = 0.0 end
            love.audio.setVolume(self.audio.masterVolume)
            self:updateButtonText(3, "Volume: " .. math.floor(self.audio.masterVolume * 100) .. "%")
        end),

        Button(self.audio.mute and "Unmute" or "Mute", rightColumn, startY + 50, buttonWidth, buttonHeight, function()
            self.audio.mute = not self.audio.mute
            love.audio.setVolume(self.audio.mute and 0 or self.audio.masterVolume)
            self:updateButtonText(4, self.audio.mute and "Unmute" or "Mute")
        end),

        -- Video controls
        Button("Brightness: " .. math.floor(self.video.brightness * 100) .. "%", leftColumn, startY + 100, buttonWidth, buttonHeight, function()
            self.video.brightness = (self.video.brightness + 0.1) % 1.1
            if self.video.brightness > 1.0 then self.video.brightness = 0.1 end
            self:updateButtonText(5, "Brightness: " .. math.floor(self.video.brightness * 100) .. "%")
        end),

        Button("VSync: " .. (self.video.vsync and "ON" or "OFF"), rightColumn, startY + 100, buttonWidth, buttonHeight, function()
            self.video.vsync = not self.video.vsync
            love.window.setVSync(self.video.vsync and 1 or 0)
            self:updateButtonText(6, "VSync: " .. (self.video.vsync and "ON" or "OFF"))
        end),

        -- Gameplay settings
        Button("Difficulty: " .. string.upper(self.gameplay.difficulty), leftColumn, startY + 150, buttonWidth, buttonHeight, function()
            local difficulties = {"easy", "normal", "hard", "expert"}
            local current = 1
            for i, diff in ipairs(difficulties) do
                if diff == self.gameplay.difficulty then current = i break end
            end
            current = (current % #difficulties) + 1
            self.gameplay.difficulty = difficulties[current]
            self:updateButtonText(7, "Difficulty: " .. string.upper(self.gameplay.difficulty))
        end),

        Button("Auto-Save: " .. (self.gameplay.autoSave and "ON" or "OFF"), rightColumn, startY + 150, buttonWidth, buttonHeight, function()
            self.gameplay.autoSave = not self.gameplay.autoSave
            self:updateButtonText(8, "Auto-Save: " .. (self.gameplay.autoSave and "ON" or "OFF"))
        end),

        -- Theme and display
        Button("Theme: " .. string.upper(self.general.theme), leftColumn, startY + 200, buttonWidth, buttonHeight, function()
            self.general.theme = self.general.theme == "dark" and "light" or "dark"
            self:updateButtonText(9, "Theme: " .. string.upper(self.general.theme))
        end),

        Button("Show FPS: " .. (self.video.showFPS and "ON" or "OFF"), rightColumn, startY + 200, buttonWidth, buttonHeight, function()
            self.video.showFPS = not self.video.showFPS
            self:updateButtonText(10, "Show FPS: " .. (self.video.showFPS and "ON" or "OFF"))
        end),

        -- Action buttons
        Button("Save Settings", leftColumn, startY + 300, buttonWidth, buttonHeight, function()
            self:save()
        end),

        Button("Reset to Defaults", rightColumn, startY + 300, buttonWidth, buttonHeight, function()
            self:resetToDefaults()
        end),
    }
end

function Settings:updateButtonText(buttonIndex, newText)
    if self.buttons and self.buttons[buttonIndex] then
        self.buttons[buttonIndex].text = newText
    end
end

function Settings:resetToDefaults()
    self.audio.masterVolume = 0.7
    self.audio.mute = false
    self.video.brightness = 1.0
    self.video.vsync = true
    self.video.showFPS = false
    self.gameplay.difficulty = "normal"
    self.gameplay.autoSave = true
    self.general.theme = "dark"
    
    love.audio.setVolume(self.audio.masterVolume)
    love.window.setVSync(1)
    
    print("Settings reset to defaults!")
    
    -- Update all button texts without recreating buttons
    self:updateButtonText(3, "Volume: " .. math.floor(self.audio.masterVolume * 100) .. "%")
    self:updateButtonText(4, self.audio.mute and "Unmute" or "Mute")
    self:updateButtonText(5, "Brightness: " .. math.floor(self.video.brightness * 100) .. "%")
    self:updateButtonText(6, "VSync: " .. (self.video.vsync and "ON" or "OFF"))
    self:updateButtonText(7, "Difficulty: " .. string.upper(self.gameplay.difficulty))
    self:updateButtonText(8, "Auto-Save: " .. (self.gameplay.autoSave and "ON" or "OFF"))
    self:updateButtonText(9, "Theme: " .. string.upper(self.general.theme))
    self:updateButtonText(10, "Show FPS: " .. (self.video.showFPS and "ON" or "OFF"))
end

function Settings:update(dt)
    if not self.buttons then return end
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(self.buttons) do
        btn:update(mx, my)
    end
end

function Settings:draw()
    -- Set background color based on theme
    if self.general.theme == "dark" then
        love.graphics.clear(0.1, 0.1, 0.15, 1)
    else
        love.graphics.clear(0.9, 0.9, 0.95, 1)
    end
    
    SettingsBackground:draw()
    
    -- Set text color based on theme
    if self.general.theme == "dark" then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(0, 0, 0, 1)
    end
    
    -- Title
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print("BOGO Settings", 20, 20)
    
    -- User info section
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("User Profile", 500, 100)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("Username: " .. self.userProfile.username, 500, 130)
    love.graphics.print("Email: " .. self.userProfile.email, 500, 150)
    love.graphics.print("Level: " .. self.userProfile.level, 500, 170)
    love.graphics.print("Experience: " .. self.userProfile.experience .. " XP", 500, 190)
    
    -- Current settings display
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("Audio Settings", 500, 230)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("Master Volume: " .. math.floor(self.audio.masterVolume * 100) .. "%", 500, 260)
    love.graphics.print("Music Volume: " .. math.floor(self.audio.musicVolume * 100) .. "%", 500, 280)
    love.graphics.print("SFX Volume: " .. math.floor(self.audio.sfxVolume * 100) .. "%", 500, 300)
    love.graphics.print("Muted: " .. (self.audio.mute and "Yes" or "No"), 500, 320)
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("Video Settings", 500, 350)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("Brightness: " .. math.floor(self.video.brightness * 100) .. "%", 500, 380)
    love.graphics.print("Contrast: " .. math.floor(self.video.contrast * 100) .. "%", 500, 400)
    love.graphics.print("VSync: " .. (self.video.vsync and "Enabled" or "Disabled"), 500, 420)
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("Gameplay Settings", 500, 450)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("Difficulty: " .. string.upper(self.gameplay.difficulty), 500, 480)
    love.graphics.print("Auto-Save: " .. (self.gameplay.autoSave and "Enabled" or "Disabled"), 500, 500)
    love.graphics.print("Theme: " .. string.upper(self.general.theme), 500, 520)
    
    -- FPS counter
    if self.video.showFPS then
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.print("FPS: " .. love.timer.getFPS(), 20, 650)
    end
    
    -- Draw buttons
    if self.buttons then
        for _, btn in ipairs(self.buttons) do
            btn:draw()
        end
    end
    
    -- Instructions
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("Press ESC to go back | R to reset | S to save", 20, 670)
end

function Settings:save()
    -- Here you could save to a file
    print("Settings saved successfully!")
    print("Theme: " .. self.general.theme)
    print("Volume: " .. self.audio.masterVolume)
    print("Difficulty: " .. self.gameplay.difficulty)
    
    -- Visual feedback
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("SAVED!", 420, 300)
end

function Settings:mousepressed(x, y, button)
    if button == 1 and self.buttons then
        for _, btn in ipairs(self.buttons) do
            btn:checkClick(x, y)
        end
    end
end

function Settings:keypressed(key)
    if key == "escape" then
        print("Escape pressed in settings, going back")
        GameState:goBack()
    elseif key == "r" then
        self:resetToDefaults()
    elseif key == "s" then
        self:save()
    end
end

return Settings