local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Cores
local corFundo = Color3.fromRGB(25, 25, 25)
local corRosa = Color3.fromRGB(255, 0, 128)
local corTexto = Color3.fromRGB(255, 255, 255)

-- Cria GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "HazapGUI"
gui.ResetOnSpawn = false

-- Botão para abrir painel
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 1, -60)
openBtn.BackgroundColor3 = corRosa
openBtn.Text = "⚙️"
openBtn.TextColor3 = corFundo
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 24
openBtn.AutoButtonColor = true

-- Painel principal
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 450, 0, 320)
panel.Position = UDim2.new(0.5, -225, 0.5, -160)
panel.BackgroundColor3 = corFundo
panel.Visible = false

-- Botão fechar
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = corRosa
closeBtn.Text = "X"
closeBtn.TextColor3 = corFundo
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.AutoButtonColor = true

-- Aba Skeleton
local skeBtn = Instance.new("TextButton", panel)
skeBtn.Size = UDim2.new(0, 100, 0, 40)
skeBtn.Position = UDim2.new(0, 0, 0, 50)
skeBtn.BackgroundColor3 = corRosa
skeBtn.Text = "Skeleton"
skeBtn.TextColor3 = corFundo
skeBtn.Font = Enum.Font.GothamBold
skeBtn.TextSize = 18

-- Aba Aimbot
local aimBtn = Instance.new("TextButton", panel)
aimBtn.Size = UDim2.new(0, 100, 0, 40)
aimBtn.Position = UDim2.new(0, 110, 0, 50)
aimBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
aimBtn.Text = "Aimbot"
aimBtn.TextColor3 = corRosa
aimBtn.Font = Enum.Font.GothamBold
aimBtn.TextSize = 18

-- Aba Tela Esticada
local resBtn = Instance.new("TextButton", panel)
resBtn.Size = UDim2.new(0, 100, 0, 40)
resBtn.Position = UDim2.new(0, 220, 0, 50)
resBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
resBtn.Text = "Tela Esticada"
resBtn.TextColor3 = corRosa
resBtn.Font = Enum.Font.GothamBold
resBtn.TextSize = 16

-- Aba Efeitos Anime
local animeBtn = Instance.new("TextButton", panel)
animeBtn.Size = UDim2.new(0, 100, 0, 40)
animeBtn.Position = UDim2.new(0, 330, 0, 50)
animeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
animeBtn.Text = "Efeitos Anime"
animeBtn.TextColor3 = corRosa
animeBtn.Font = Enum.Font.GothamBold
animeBtn.TextSize = 16

-- Frames das abas
local skeFrame = Instance.new("Frame", panel)
skeFrame.Size = UDim2.new(1, 0, 1, -100)
skeFrame.Position = UDim2.new(0, 0, 0, 100)
skeFrame.BackgroundTransparency = 1

local aimFrame = skeFrame:Clone()
aimFrame.Parent = panel
aimFrame.Visible = false

local resFrame = skeFrame:Clone()
resFrame.Parent = panel
resFrame.Visible = false

local animeFrame = skeFrame:Clone()
animeFrame.Parent = panel
animeFrame.Visible = false

-- Skeleton
local skeletons = {}
local skeletonEnabled = false
local skeletonConn

local function createLine()
    local ln = Drawing.new("Line")
    ln.Thickness = 2
    ln.Transparency = 1
    return ln
end

local connections = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},
    {"UpperTorso","RightUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},
    {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},
    {"LowerTorso","RightUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},
}

local function toggleSkeleton(on)
    if on then
        skeletonConn = RunService.RenderStepped:Connect(function()
            for _, v in pairs(skeletons) do for _, ln in pairs(v) do ln.Visible = false end end
            for _, pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer and pl.Character then
                    local char = pl.Character
                    if not skeletons[pl] then
                        skeletons[pl] = {}
                        for _ = 1, #connections do table.insert(skeletons[pl], createLine()) end
                    end
                    local color = Color3.fromHSV((tick()%5)/5,1,1)
                    for i, pair in ipairs(connections) do
                        local p1 = char:FindFirstChild(pair[1])
                        local p2 = char:FindFirstChild(pair[2])
                        if p1 and p2 then
                            local pos1, on1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2, on2 = Camera:WorldToViewportPoint(p2.Position)
                            if on1 and on2 then
                                local ln = skeletons[pl][i]
                                ln.Color = color
                                ln.From = Vector2.new(pos1.X,pos1.Y)
                                ln.To = Vector2.new(pos2.X,pos2.Y)
                                ln.Visible = true
                            end
                        end
                    end
                end
            end
        end)
    else
        if skeletonConn then skeletonConn:Disconnect() end
        for _, v in pairs(skeletons) do for _, ln in pairs(v) do ln.Visible = false end end
        skeletons = {}
    end
end

-- Botão Skeleton
local skeToggle = Instance.new("TextButton", skeFrame)
skeToggle.Size = UDim2.new(0, 200, 0, 40)
skeToggle.Position = UDim2.new(0.5, -100, 0.2, 0)
skeToggle.BackgroundColor3 = corRosa
skeToggle.TextColor3 = corFundo
skeToggle.Font = Enum.Font.GothamBold
skeToggle.TextSize = 18
skeToggle.Text = "Ativar Skeleton"
skeToggle.Parent = skeFrame
skeToggle.MouseButton1Click:Connect(function()
    skeletonEnabled = not skeletonEnabled
    skeToggle.Text = skeletonEnabled and "Desativar Skeleton" or "Ativar Skeleton"
    toggleSkeleton(skeletonEnabled)
end)

-- Botão Aimbot
local extBtn = Instance.new("TextButton", aimFrame)
extBtn.Size = skeToggle.Size
extBtn.Position = skeToggle.Position
extBtn.BackgroundColor3 = corRosa
extBtn.TextColor3 = corFundo
extBtn.Font = Enum.Font.GothamBold
extBtn.TextSize = 18
extBtn.Text = "Carregar Aimbot"
extBtn.Parent = aimFrame
extBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Aimbot-Universal-For-Mobile-and-PC-29153"))()
end)

-- Botão Tela Esticada
local resBtn2 = extBtn:Clone()
resBtn2.Parent = resFrame
resBtn2.Text = "Aplicar Tela Esticada"
resBtn2.MouseButton1Click:Connect(function()
    getgenv().Resolution = { [".gg/scripters"] = 0.65 }
    if getgenv().gg_scripters == nil then
        RunService.RenderStepped:Connect(function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
        end)
    end
    getgenv().gg_scripters = "Aori0001"
end)

-- Botão Efeitos Anime
local animeBtn2 = extBtn:Clone()
animeBtn2.Parent = animeFrame
animeBtn2.Text = "Aplicar Efeitos Anime"
animeBtn2.MouseButton1Click:Connect(function()
    local lighting = game:GetService("Lighting")
    for _, effect in pairs(lighting:GetChildren()) do
        if effect:IsA("PostEffect") then effect:Destroy() end
    end
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.TintColor = Color3.fromRGB(255, 230, 230)
    colorCorrection.Saturation = 0.4
    colorCorrection.Contrast = 0.2
    colorCorrection.Parent = lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 1.5
    bloom.Threshold = 0.8
    bloom.Size = 56
    bloom.Parent = lighting
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        if obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy() end
    end
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            wait(1)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local outline = part:Clone()
                    outline.Name = "Outline"
                    outline.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                    outline.Material = Enum.Material.SmoothPlastic
                    outline.Color = Color3.new(0, 0, 0)
                    outline.Transparency = 0
                    outline.Anchored = false
                    outline.CanCollide = false
                    outline.Massless = true
                    outline.Parent = part
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = part
                    weld.Part1 = outline
                    weld.Parent = outline
                end
            end
        end)
    end)
end)

-- Abas
local function hideAll()
    skeFrame.Visible = false
    aimFrame.Visible = false
    resFrame.Visible = false
    animeFrame.Visible = false
    skeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    aimBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    resBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    animeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
end

skeBtn.MouseButton1Click:Connect(function()
    hideAll()
    skeFrame.Visible = true
    skeBtn.BackgroundColor3 = corRosa
end)
aimBtn.MouseButton1Click:Connect(function()
    hideAll()
    aimFrame.Visible = true
    aimBtn.BackgroundColor3 = corRosa
end)
resBtn.MouseButton1Click:Connect(function()
    hideAll()
    resFrame.Visible = true
    resBtn.BackgroundColor3 = corRosa
end)
animeBtn.MouseButton1Click:Connect(function()
    hideAll()
    animeFrame.Visible = true
    animeBtn.BackgroundColor3 = corRosa
end)

-- Abrir/fechar painel
openBtn.MouseButton1Click:Connect(function()
    panel.Visible = true
    openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    openBtn.Visible = true
end)