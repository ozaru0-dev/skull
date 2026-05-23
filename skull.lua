-- =========================================================
--  The_Skull | Hub | Blox Fruits
-- =========================================================
-- [1] BYPASSES Y PROTECCIONES
repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Util")
local ss = require(game:GetService("ReplicatedStorage").Util.CameraShaker.Main)
local xx = function() return nil end
ss.StartShake = xx; ss.ShakeOnce = xx; ss.ShakeSustain = xx; ss.CamerShakeInstance = xx; ss.Shake = xx; ss.Start = xx

pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TeleportService = game:GetService("TeleportService")
    local GuiService = game:GetService("GuiService")

    local function Rejoin()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local Method = getnamecallmethod()
        if (Method == "Kick" or Method == "kick") and Self == LocalPlayer then 
            task.spawn(Rejoin)
            return nil 
        end
        return OldNamecall(Self, ...)
    end))

    GuiService.ErrorMessageChanged:Connect(function()
        if GuiService:GetErrorMessage() ~= "" then Rejoin() end
    end)
end)

-- // Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // Variables de Control
local MasterEnabled = false 
local AutoSkillEnabled = false
local MaxDistance = 500 
local FOV_Radius = 150 

-- // Función para detectar enemigo
local function GetClosestPlayer()
    local Target = nil
    local ShortestDistance = FOV_Radius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local distFromMe = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            
            if distFromMe <= MaxDistance then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local distFromCenter = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distFromCenter < ShortestDistance then
                        Target = hrp
                        ShortestDistance = distFromCenter
                    end
                end
            end
        end
    end
    return Target
end

-- // LÓGICA DE LA MACRO XZ (FIXED)
UserInputService.InputBegan:Connect(function(input)
    if not AutoSkillEnabled then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        local isShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
        
        if isShiftLock then
            task.spawn(function()
                -- EJECUCIÓN DE X
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                task.wait(0.05) -- Tiempo suficiente para que el juego registre "Presionado"
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                
                -- TIEMPO DE ESPERA ENTRE HABILIDADES
                -- Si solo sale la X, aumenta este número (ej: 0.15)
                task.wait(0.1) 
                
                -- EJECUCIÓN DE Z
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
            end)
        end
    end
end)

-- // Bucle Principal (Aimbot Instantáneo)
RunService.RenderStepped:Connect(function()
    local isShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    
    if MasterEnabled and isShiftLock then
        local target = GetClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- [ FUNCIÓN DE TELEPORT AL BARCO EMBRUJADO - SEA 2 ]
local isHealing = false
local returnPos = nil

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.O then
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not isHealing then
                    isHealing = true
                    returnPos = hrp.CFrame
                    hrp.CFrame = CFrame.new(923.212, 125.103, 32852.832)
                else
                    if returnPos then
                        hrp.CFrame = returnPos
                    end
                    isHealing = false
                end
            end
        end)
    end
end)

-- [2] VARIABLES Y SERVICIOS (ya declarados arriba, se referencian aquí)

local FastAttackEnabled = false
local FastAttackRange = 12000 
local FruitAttack = false
local InfiniteJumpEnabled = false
local InstakillActive = false 
local GodModeEnabled = true
local TeleportEnabled = false
local PredictionStrength = 0
local ESPMaxDistance = 99999999
local TOGGLE_KEY = Enum.KeyCode.U
local autoV4 = false

-- Fix de Infinite Jump (Forzado de Velocidad)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if hrp and hum then
            -- Forzamos la velocidad vertical del salto
            hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower, hrp.Velocity.Z)
        end
    end
end)

-- Vuelo hacia arriba al mantener Espacio
local SpaceHeld = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        SpaceHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        SpaceHeld = false
    end
end)

RunService.Heartbeat:Connect(function()
    if InfiniteJumpEnabled and SpaceHeld then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Aplica velocidad hacia arriba (ajusta el 50 para ir más rápido o lento)
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end
end)

-- Variables Noclip
local Noclip = false
local NoclipConnection

-- Función para manejar el estado del Noclip
local function SetNoclip(state)
    Noclip = state
    if Noclip then
        -- Conexión que desactiva colisiones en cada frame
        NoclipConnection = RunService.Stepped:Connect(function()
            local character = game.Players.LocalPlayer.Character
            if character and Noclip then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Desconectar y devolver colisiones
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Configuración WalkSpeed GLOBAL
_G.WalkSpeedValue = 40
_G.WalkSpeedEnabled = false

local FastAttackConnection = nil
local FruitAttackConnection = nil
local FruitAttackConnection1 = nil
local FruitAttackConnection12 = nil
local FruitAttackConnection16662 = nil
local SelectedPlayer = nil
local InstaTpConnection = nil
local ActiveTween = nil
local TeleportConnection = nil
local YOffset = 0

local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterHit = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]

-- [LÓGICA DE MOVIMIENTO TWEEN VEL 200]
local function SetNoCollide(v)
    pcall(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not v end
        end
    end)
end

local function StartTeleporting()
    if TeleportConnection then TeleportConnection:Disconnect() end
    TeleportConnection = RunService.Heartbeat:Connect(function()
        if not TeleportEnabled or not SelectedPlayer then return end
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LocalPlayer.Character.HumanoidRootPart
            local targetHRP = target.Character.HumanoidRootPart
            local targetPos = targetHRP.Position + Vector3.new(0, YOffset, 0)
            local dist = (myHRP.Position - targetPos).Magnitude
            if dist > 2 then
                SetNoCollide(true)
                local speed = 200
                local time = dist / speed
                if ActiveTween then ActiveTween:Cancel() end
                ActiveTween = TweenService:Create(myHRP, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                ActiveTween:Play()
            end
        end
    end)
end

-- LÓGICA DE WALKSPEED (RENDERSTEPPED PARA QUE FUNCIONE SIEMPRE)
RunService.RenderStepped:Connect(function()
    if _G.WalkSpeedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = _G.WalkSpeedValue
            end
        end)
    end
end)

-- Flags de control
local AutoHealActive = true
local isHealing = false
local returnPos = nil

-- [3] FUNCIONES DE ATAQUE (ORIGINALES)
local function FireAttack(targets)
    if #targets == 0 then return end
    RegisterAttack:FireServer(0)
    RegisterHit:FireServer(targets[1][2], targets)
end

local function StartFastAttack()
    if FastAttackConnection then FastAttackConnection:Disconnect() end
    FastAttackConnection = RunService.Heartbeat:Connect(function()
        if not FastAttackEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local origin = hrp.Position
        local range = FastAttackRange
        local targets = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local c = plr.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local h = c and c:FindFirstChild("Head")
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and h and r and (r.Position - origin).Magnitude <= range then
                    targets[#targets+1] = {c, h}
                end
            end
        end
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local h = npc:FindFirstChild("Head")
                local r = npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and h and r and (r.Position - origin).Magnitude <= range then
                    targets[#targets+1] = {npc, h}
                end
            end
        end
        if #targets > 0 then FireAttack(targets) end
    end)
end

local function StopFastAttack()
    if FastAttackConnection then FastAttackConnection:Disconnect(); FastAttackConnection = nil end
end

local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return #list == 0 and {"None"} or list
end

local function GetNearestPlayer()
    local nearest, dist = nil, math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; nearest = v end
        end
    end
    return nearest
end

local function StartFastAttack()
    if FastAttackConnection then FastAttackConnection:Disconnect() end
    FastAttackConnection = RunService.Heartbeat:Connect(function()
        if not FastAttackEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local origin = hrp.Position
        local range = FastAttackRange
        local targets = {}

        -- [A] TARGET: JUGADORES
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local c = plr.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
                    table.insert(targets, {c, c:FindFirstChild("Head") or r})
                end
            end
        end

        -- [B] TARGET: ENEMIGOS ESTÁNDAR
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local r = npc:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
                    table.insert(targets, {npc, npc:FindFirstChild("Head") or r})
                end
            end
        end

        -- [C] TARGET: LEVIATHAN Y COLAS (NUEVO)
        -- Buscamos en todo el workspace por modelos que contengan "Leviathan" o "Tail"
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name:find("Leviathan") or obj.Name:find("Tail") or obj.Name:find("Segment") then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local r = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("LowerTorso")
                if hum and hum.Health > 0 and r and (r.Position - origin).Magnitude <= range then
                    table.insert(targets, {obj, r})
                end
            end
        end

        if #targets > 0 then FireAttack(targets) end
    end)
end

-- [ VARIABLES DE CONTROL ]
local CapitanAtack2Enabled = false
local CapitanRange = 3000
local MaxTargetsPerFrame = 8 -- Límite para evitar kicks en cuentas flagged

-- [ LISTA DE OBJETIVOS ESPECIALES ]
local SPECIAL_TARGETS = {
    "Leviathan", "Tail", "Segment", "Tongue", "Head", -- Leviathan Parts
    "Sea Beast", "TerrorShark", "Piranha", "Ship Wright", -- Sea Events
    "Ghost Ship", "Fishman", "Boss", "NPC" -- Raids & Bosses
}

-- [ VARIABLES OPTIMIZADAS PARA CUENTAS FLAGGED ]
local CapitanAtack2Enabled = false
local CapitanRange = 3000
local AttackSpeed = 0.0 -- 
local LastAttack = 0

local function StartCapitanAtack2()
    if KrazyAtack2Connection then KrazyAtack2Connection:Disconnect() end
    
    KrazyAtack2Connection = RunService.Heartbeat:Connect(function()
        if not CapitanAtack2Enabled then return end
        
        -- Control de velocidad para evitar detección de "Spam"
        if tick() - LastAttack < AttackSpeed then return end
        
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local targets = {}
        
        -- Escaneo eficiente
        for _, v in ipairs(workspace:GetChildren()) do
            -- Filtro de objetivos (Leviathan, Sea Events, NPCs)
            local isTarget = false
            for _, name in ipairs(SPECIAL_TARGETS) do
                if string.find(v.Name, name) then isTarget = true break end
            end

            if isTarget or (v:FindFirstChildOfClass("Humanoid") and v.Name ~= LocalPlayer.Name) then
                local hum = v:FindFirstChildOfClass("Humanoid")
                local tRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                
                if hum and hum.Health > 0 and tRoot then
                    local dist = (hrp.Position - tRoot.Position).Magnitude
                    if dist <= CapitanRange then
                        table.insert(targets, {v, tRoot})
                        if #targets >= 5 then break end -- No le pegues a más de 5 a la vez
                    end
                end
            end
        end

        if #targets > 0 then
            LastAttack = tick() -- Reinicia el temporizador de bypass
            pcall(function()
                -- El bypass de "FireAttack"
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(targets[1][2], targets)
            end)
        end
    end)
end

-- Lógica de Noclip (Corre en segundo plano)
game:GetService("RunService").Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Variables ESP Drawing
local ESP_Enabled = false
local Box_Color = Color3.fromRGB(0, 162, 255) -- Tu azul neón
local ESP_Objects = {}

-- Función para crear los dibujos (invisible hasta que se activa)
local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Box_Color
    Box.Thickness = 1.5 -- Línea fina para que sea discreto
    Box.Transparency = 1
    Box.Filled = false

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.new(1, 1, 1)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true

    ESP_Objects[player] = {Box = Box, Name = Name}
end

-- Limpieza al salir
local function RemoveESP(player)
    if ESP_Objects[player] then
        ESP_Objects[player].Box:Remove()
        ESP_Objects[player].Name:Remove()
        ESP_Objects[player].Distance:Remove() -- Si tenías distancia antes
        ESP_Objects[player] = nil
    end
end

-- Bucle de renderizado suave
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        local drawings = ESP_Objects[player]
        if not drawings then 
            if player ~= LocalPlayer then CreateESP(player) end
            continue 
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if ESP_Enabled and hrp and hum and hum.Health > 0 then
            -- Calculamos la posición superior (cabeza) e inferior (pies)
            local hrpPos, onScreen = Camer
