local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Kronos"))()

local window = library:Window({
    Title = "nighttide.cc",
    Accent = Color3.fromRGB(69, 69, 207),
    Logo = 3610245066,
    ToggleKey = Enum.KeyCode.LeftAlt
})

local tab = window:NewTab({
    Logo = 4483345998
})

local tabsection = tab:TabSection({
    Title = "ESP & Aimbot"
})

local column = tabsection:AddColumn({
    Title = "Features"
})

local section = column:Section({
    Title = "ESP Settings"
})

local esp_enabled = false
local aimbot_enabled = false
local fov_enabled = false
local aim_part = "Head"
local fov_circle = Drawing.new("Circle")

fov_circle.Radius = 100
fov_circle.Color = Color3.fromRGB(255, 255, 255)
fov_circle.Thickness = 2
fov_circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
fov_circle.Visible = fov_enabled

local esp_type = "BoxESP"
local current_target = nil
local esp_table = {}

section:Toggle({
    Text = "Enable ESP",
    State = false,
    Callback = function(state)
        esp_enabled = state
        for _, esp_func in pairs(esp_table) do
            esp_func()
        end
    end
})

section:Toggle({
    Text = "Enable Aimbot",
    State = false,
    Callback = function(state)
        aimbot_enabled = state
    end
})

section:Toggle({
    Text = "Show FOV",
    State = false,
    Callback = function(state)
        fov_enabled = state
        fov_circle.Visible = fov_enabled
    end
})

section:Dropdown({
    Text = "Aim Part",
    List = {'Head', 'Torso', 'Random'},
    Callback = function(selected)
        aim_part = selected
    end
})

section:Slider({
    Text = "FOV",
    Min = 0,
    Max = 500,
    Def = 100,
    Callback = function(value)
        fov_circle.Radius = value
    end
})

section:Dropdown({
    Text = "ESP Type",
    List = {"BoxESP", "Highlight (SOON)", "w/HealthBar (SOON)"},
    Callback = function(selected)
        esp_type = selected
    end
})
local function createESPBox(character, color)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = color
    box.Thickness = 2

    return function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen and esp_enabled then
                local size = Vector3.new(2, 3, 0) * (workspace.CurrentCamera.ViewportSize.Y / (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude)
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end

local function getClosestPlayerToFOV()
    local closestPlayer = nil
    local shortestDistance = fov_circle.Radius

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - fov_circle.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = character
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function lockOntoTarget(targetPosition)
    local camera = workspace.CurrentCamera
    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                if not esp_table[player] then
                    esp_table[player] = createESPBox(character, Color3.fromRGB(255, 0, 0))
                end
                esp_table[player]()
            elseif esp_table[player] then
                esp_table[player] = nil
            end
        end
    end

    if aimbot_enabled then
        current_target = getClosestPlayerToFOV()
        if current_target then
            local aim_part_obj = current_target:FindFirstChild(aim_part)
            if aim_part_obj then
                lockOntoTarget(aim_part_obj.Position)
            end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbot_enabled = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbot_enabled = false
    end
end)

local gunModTab = window:NewTab({
    Title = "Gun Mods"
})

local gunModSection = gunModTab:TabSection({
    Title = "Gun Settings"
})

local gunModColumn = gunModSection:AddColumn({
    Title = "SOON"
})