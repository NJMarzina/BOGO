-- casino/BackgroundShader.lua - Manages the animated background shader
local BackgroundShader = {}

-- We'll get state directly from the Casino module to avoid circular dependency

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

-- https://www.shadertoy.com/view/XlfGRj
local shaderCode = [[
    extern vec2 iResolution;
    extern number iTime;
    extern vec2 iMouse;

    const int iterations = 17;
    const float formuparam = 0.53;

    const int volsteps = 20;
    const float stepsize = 0.1;

    const float zoom = 0.800;
    const float tile = 0.850;
    const float speed = 0.010;

    const float brightness = 0.0015;
    const float darkmatter = 0.300;
    const float distfading = 0.730;
    const float saturation = 0.850;

    vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 fragCoord) {
        vec2 uv = fragCoord / iResolution - 0.5;
        uv.y *= iResolution.y / iResolution.x;
        vec3 dir = vec3(uv * zoom, 1.0);
        float time = iTime * speed + 0.25;

        float a1 = 0.5;
        float a2 = 0.8;
        mat2 rot1 = mat2(cos(a1), sin(a1), -sin(a1), cos(a1));
        mat2 rot2 = mat2(cos(a2), sin(a2), -sin(a2), cos(a2));
        dir.xz *= rot1;
        dir.xy *= rot2;

        vec3 from = vec3(1.0, 0.5, 0.5);
        from += vec3(time * 2.0, time, -2.0);
        from.xz *= rot1;
        from.xy *= rot2;

        float s = 0.1, fade = 1.0;
        vec3 v = vec3(0.0);
        for (int r = 0; r < volsteps; r++) {
            vec3 p = from + s * dir * 0.5;
            p = abs(vec3(tile) - mod(p, vec3(tile * 2.0)));
            float pa = 0.0, a = 0.0;
            for (int i = 0; i < iterations; i++) {
                p = abs(p) / dot(p, p) - formuparam;
                a += abs(length(p) - pa);
                pa = length(p);
            }
            float dm = max(0.0, darkmatter - a * a * 0.001);
            a *= a * a;
            if (r > 6) fade *= 1.0 - dm;
            v += fade;
            v += vec3(s, s * s, s * s * s * s) * a * brightness * fade;
            fade *= distfading;
            s += stepsize;
        }
        v = mix(vec3(length(v)), v, saturation);
        return vec4(v * 0.01, 1.0);
    }
]]

function BackgroundShader:init()
    self.shader = love.graphics.newShader(shaderCode)
end

function BackgroundShader:update(time)
    self.shader:send("iTime", time)
    self.shader:send("iResolution", {screenWidth, screenHeight})
    -- Uncomment if you want mouse interaction with background
    -- self.shader:send("iMouse", {love.mouse.getX(), love.mouse.getY()})
end

function BackgroundShader:draw()
    love.graphics.setShader(self.shader)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setShader()
end

return BackgroundShader