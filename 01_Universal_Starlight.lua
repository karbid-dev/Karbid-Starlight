local vercount = 9
print("Ver_Universal : 2.0." .. vercount)
-------------------------------------------------------------------------------------------------------------------------- ⚠️ Variables
-- Roblox Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInput = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local Workspace = game.Workspace

-- Player & Character
local Plr = Players.LocalPlayer
local Backpack = Plr:WaitForChild("Backpack")
local PlrGui = Plr:WaitForChild("PlayerGui")
local Character = Plr.Character or Plr.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game/Server Info
local PlaceId = game.PlaceId
local JobId = game.JobId
local Camera = Workspace.CurrentCamera
local GameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name

-------------------------------------------------------------------------------------------------------------------------- ⚠️ Basic Functions
Plr.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local function clearConns()
	_G.Conns = _G.Conns or {}
	for name, conn in pairs(_G.Conns) do
		conn:Disconnect()
	end
	_G.Conns = {}
end
clearConns()
_G.Starlight:OnDestroy(clearConns)

function Disconnect(name)
	if _G.Conns[name] then
		_G.Conns[name]:Disconnect()
		_G.Conns[name] = nil
	end
end

function RunEvery(sec, callback)
	if sec == 0 then -- Runs Every Frame
		return RunService.Heartbeat:Connect(callback)
	elseif sec > 0 then
		local last = 0 -- Runs Every Seconds Ex 0.1 or 1.5 sec
		return RunService.Heartbeat:Connect(function()
			if tick() - last >= sec then
				last = tick()
				callback()
			end
		end)
	end
end

--🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢

--🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢🟢
-------------------------------------------------------------------------------------------------------------------------- ⚠️ Universal
_G.CharacterGroupbox:CreateButton({
	Name = "Teleport",
	Style = 1,
	CenterContent = true,
	Callback = function() end,
}, "BtnPlrTeleport")

local selectedplr
_G.CharacterGroupbox
	:CreateLabel({
		Name = "Select Player",
		Icon = _G.NebulaIcons:GetIcon("person_search", "Material"),
	}, "LabelSelectPlr")
	:AddDropdown({
		Special = 1,
		CurrentOptions = {},
		Placeholder = "None Selected",
		Callback = function(opt)
			selectedplr = opt[1]
			print(selectedplr)
		end,
	}, "DDPlrTeleport")

local function getPlrTeleport()
	if selectedplr then
		local target = Players:FindFirstChild(selectedplr)
		if target then
			local targetchar = target.Character
			if targetchar then
				local targethrp = targetchar:FindFirstChild("HumanoidRootPart")
				if targethrp then
					HumanoidRootPart.CFrame = targethrp.CFrame 
				end
			else
			end
		end
	end
end

_G.CharacterGroupbox:CreateButton({
	Name = "Get Player",
	Icon = _G.NebulaIcons:GetIcon("users", "Lucide"),
	Style = 2,
	Callback = function()
		getPlrTeleport()
	end,
}, "BtnGetPlr")

_G.CharacterGroupbox:CreateToggle({
	Name = "Lock Player",
	Icon = _G.NebulaIcons:GetIcon("user-lock", "Lucide"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		Disconnect("TPLock")
		if state then
			_G.Conns["TPLock"] = RunEvery(0, getPlrTeleport)
		end
	end,
}, "ToggleLockPlr")
_G.CharacterGroupbox:CreateDivider()

local savepos
_G.CharacterGroupbox:CreateButton({
	Name = "Save Character Position ",
	Icon = _G.NebulaIcons:GetIcon("save_alt", "Material"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		savepos = HumanoidRootPart.CFrame
	end,
}, "BtnSavePos")

_G.CharacterGroupbox:CreateButton({
	Name = "Load Character Position ",
	Icon = _G.NebulaIcons:GetIcon("rotate_left", "Material"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		HumanoidRootPart.CFrame = savepos
	end,
}, "BtnLoadPos")

_G.CharacterGroupbox:CreateDivider()
_G.CharacterGroupbox:CreateButton({
	Name = "Character",
	Style = 1,
	CenterContent = true,
	Callback = function() end,
}, "BtnCharacter")

if Humanoid and not _G.oriwalkspeed and not _G.orijumppower then
	_G.oriwalkspeed = math.floor(Humanoid.WalkSpeed + 0.5)
	_G.orijumppower = math.floor(Humanoid.JumpPower + 0.5)
end
local successmt, err = pcall(function()
	local mt = getrawmetatable(Humanoid)
	if not _G.oriindex or not _G.orinewindex then
		_G.oriindex = mt.__index
		_G.orinewindex = mt.__newindex
	end

	local function getSpoof()
		setreadonly(mt, false)
		if _G.modifierstate then
			mt.__index = function(self, key)
				if self == Humanoid then
					if key == "WalkSpeed" then
						return _G.oriwalkspeed
					elseif key == "JumpPower" then
						return _G.orijumppower
					end
				end
				return _G.oriindex(self, key)
			end

			mt.__newindex = function(self, key, value)
				if self == Humanoid then
					if key == "WalkSpeed" then
						local speed = _G.modwalkspeed
						if _G.sprintstate then
							speed = _G.oriwalkspeed * 3
						end
						return _G.orinewindex(self, key, speed)
					elseif key == "JumpPower" then
						return _G.orinewindex(self, key, _G.modjumppower)
					end
				end
				return _G.orinewindex(self, key, value)
			end
		else
			mt.__index = _G.oriindex
			mt.__newindex = _G.orinewindex
		end
		setreadonly(mt, true)
	end
end)
if not successmt then
	warn("Failed to initialize spoofing: " .. err)
	warn("Trash Executor Detected")
end

local SliderWalkspeed = _G.CharacterGroupbox:CreateSlider({
	Name = "Walkspeed | Original : " .. _G.oriwalkspeed,
	Icon = _G.NebulaIcons:GetIcon("directions_run", "Material"),
	Range = { 0, 300 },
	Increment = 1,
	CurrentValue = _G.oriwalkspeed,
	Callback = function(val)
		_G.modwalkspeed = val
		if _G.modifierstate then
			Humanoid.WalkSpeed = _G.modwalkspeed
		end
	end,
}, "SliderWalkspeed")

local SliderJumppower = _G.CharacterGroupbox:CreateSlider({
	Name = "Jumppower | Original : " .. _G.orijumppower,
	Icon = _G.NebulaIcons:GetIcon("sports_handball", "Material"),
	Range = { 0, 300 },
	Increment = 1,
	CurrentValue = _G.orijumppower,
	Callback = function(val)
		_G.modjumppower = val
		if _G.modifierstate then
			Humanoid.JumpPower = _G.modjumppower
		end
	end,
}, "SliderJumppower")

_G.CharacterGroupbox
	:CreateLabel({
		Name = "Sprint",
		Tooltip = "Original Speed x 3 ",
		Icon = _G.NebulaIcons:GetIcon("speed", "Material"),
	}, "LabelSprint")
	:AddBind({
		HoldToInteract = true,
		CurrentValue = "LeftShift",
		Callback = function(state)
			_G.sprintstate = state
			if state then
				if _G.modifierstate then
					Humanoid.WalkSpeed = _G.modwalkspeed * 3
				end
			else
				if _G.modifierstate then
					Humanoid.WalkSpeed = _G.modwalkspeed
				else
					Humanoid.WalkSpeed = _G.oriwalkspeed
				end
			end
		end,
	}, "BindSprint")

_G.CharacterGroupbox:CreateToggle({
	Name = "Enable Modifier",
	Icon = _G.NebulaIcons:GetIcon("add_task", "Material"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		_G.modifierstate = state
		local successspoof, err = pcall(function()
			getSpoof()
		end)
		if state then
			Humanoid.WalkSpeed = _G.modwalkspeed
			Humanoid.JumpPower = _G.modjumppower
		else
			Humanoid.WalkSpeed = _G.oriwalkspeed
			Humanoid.JumpPower = _G.orijumppower
		end
	end,
}, "ToggleModifier")

_G.CharacterGroupbox:CreateButton({
	Name = "Reset Speed & Jump",
	Icon = _G.NebulaIcons:GetIcon("history", "Material"),
	Style = 2,
	Callback = function()
		SliderWalkspeed:Set({ CurrentValue = _G.oriwalkspeed })
		SliderJumppower:Set({ CurrentValue = _G.orijumppower })
	end,
}, "BtnResetSpeedPower")

_G.CharacterGroupbox:CreateDivider()

_G.CharacterGroupbox:CreateToggle({
	Name = "Infinity Jump",
	Icon = _G.NebulaIcons:GetIcon("chevrons-up", "Lucide"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		Disconnect("InfJump")

		if state then
			_G.Conns["InfJump"] = UserInputService.JumpRequest:Connect(function()
				Humanoid:ChangeState("Jumping")
			end)
		end
	end,
}, "ToggleInfJump")

_G.noclipdata = _G.noclipdata or {}
local function getNoClip()
	if not Character and not HumanoidRootPart then
		return
	end
	for _, part in ipairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			if _G.noclipdata[part] == nil then
				_G.noclipdata[part] = part.CanCollide
			end
			part.CanCollide = false
		end
	end
	if not CoreGui:FindFirstChild("HL_NoClip", true) then
		local hl = Instance.new("Highlight")
		hl.Name = "HL_NoClip"
		hl.Adornee = Character
		hl.FillColor = Color3.fromRGB(80, 15, 15)
		hl.FillTransparency = 0.5
		hl.OutlineTransparency = 0.3
		hl.OutlineColor = Color3.fromRGB(230, 75, 75)
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = CoreGui
	end
end

local function clearNoClip()
	if _G.noclipdata then
		for part, ori in pairs(_G.noclipdata) do
			if part and part:IsA("BasePart") then
				part.CanCollide = ori
			end
			local hl = CoreGui:FindFirstChild("HL_NoClip", true)
			if hl then
				hl:Destroy()
			end
		end
		table.clear(_G.noclipdata)
	end
end

local noclip = _G.CharacterGroupbox:CreateToggle({
	Name = "No Clip",
	Icon = _G.NebulaIcons:GetIcon("flip-horizontal-2", "Lucide"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		Disconnect("NoClip")
		clearNoClip()
		if state then
			_G.Conns["NoClip"] = RunEvery(0, getNoClip)
		end
	end,
}, "ToggleNoClip")

local animationtrack_idle
local animationtrack_moving
local current_animation = nil -- Track which animation is currently playing

local function getAnimation()
	if not Character and not HumanoidRootPart then
		return
	end
	local animate = Character:FindFirstChild("Animate")
	if animate then
		animate.Enabled = false
	end

	local animator = Humanoid:FindFirstChild("Animator") or Instance.new("Animator", Humanoid)
	if animator then
		-- Load idle animation
		local animation_idle = Instance.new("Animation")
		animation_idle.AnimationId = "rbxassetid://73980801925168"
		animationtrack_idle = animator:LoadAnimation(animation_idle)
		animationtrack_idle.Priority = Enum.AnimationPriority.Action
		animationtrack_idle.Looped = true

		-- Load moving animation
		local animation_moving = Instance.new("Animation")
		animation_moving.AnimationId = "rbxassetid://132105268936736"
		animationtrack_moving = animator:LoadAnimation(animation_moving)
		animationtrack_moving.Priority = Enum.AnimationPriority.Action
		animationtrack_moving.Looped = true

		-- Start with idle animation
		animationtrack_idle:Play()
		current_animation = "idle"
	end
end

local function getFloat()
	if not Character and not HumanoidRootPart then
		return
	end

	if not _G.FloatForce then
		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.Name = "Karbid_Float"
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.P = 1250
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = HumanoidRootPart
		_G.FloatForce = bodyVel
	end

	local camCF = Camera.CFrame
	local moveVec = Vector3.zero
	local isMoving = false

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		moveVec = moveVec + camCF.LookVector
		isMoving = true
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		moveVec = moveVec - camCF.LookVector
		isMoving = true
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		moveVec = moveVec - camCF.RightVector
		isMoving = true
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		moveVec = moveVec + camCF.RightVector
		isMoving = true
	end

	moveVec = Vector3.new(moveVec.X, 0, moveVec.Z)
	if moveVec.Magnitude > 0 then
		moveVec = moveVec.Unit * _G.modwalkspeed
	end

	local verticalY = 0
	if isMoving then
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			verticalY = math.clamp(camCF.LookVector.Y, -0.7, 0.7) * _G.modwalkspeed
		elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
			verticalY = -math.clamp(camCF.LookVector.Y, -0.7, 0.7) * _G.modwalkspeed
		end
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		verticalY = verticalY + 10
	end

	_G.FloatForce.Velocity = moveVec + Vector3.new(0, verticalY, 0)

	-- Switch animation based on movement
	if isMoving and current_animation ~= "moving" then
		if animationtrack_idle then
			animationtrack_idle:Stop()
		end
		if animationtrack_moving then
			animationtrack_moving:Play()
		end
		current_animation = "moving"
	elseif not isMoving and current_animation ~= "idle" then
		if animationtrack_moving then
			animationtrack_moving:Stop()
		end
		if animationtrack_idle then
			animationtrack_idle:Play()
		end
		current_animation = "idle"
	end
end

local function clearFloat()
	local karbidfloat = HumanoidRootPart:FindFirstChild("Karbid_Float")
	if _G.FloatForce then
		_G.FloatForce:Destroy()
		_G.FloatForce = nil
	end
	if karbidfloat then
		karbidfloat:Destroy()
	end
	if animationtrack_idle then
		animationtrack_idle:Stop()
		animationtrack_idle = nil
	end
	if animationtrack_moving then
		animationtrack_moving:Stop()
		animationtrack_moving = nil
	end
	current_animation = nil
	local animate = Character:FindFirstChild("Animate")
	if animate then
		animate.Enabled = true
	end
end

_G.CharacterGroupbox:CreateToggle({
	Name = "Float",
	Icon = _G.NebulaIcons:GetIcon("plane", "Lucide"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		noclip:Set({ CurrentValue = state })
		Disconnect("Float")
		if state then
			getAnimation()
			local takeoff = HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			TweenService:Create(HumanoidRootPart, tweenInfo, { CFrame = takeoff }):Play()
			_G.Conns["Float"] = RunEvery(0, getFloat)
		else
			clearFloat()
		end
	end,
}, "ToggleFloat")

_G.CharacterGroupbox:CreateDivider()

local animationlist = {
	["Floating Aura"] = "rbxassetid://139381788459274",
	["Aura Farming"] = "rbxassetid://98843005619029",
	["Cute Kicking"] = "rbxassetid://127951396668003",
	["Floating"] = "rbxassetid://73980801925168",
	["Coffin Walkout"] = "rbxassetid://126771729094882",
	["Mosh"] = "rbxassetid://96147994216119",
	["Jason Vorhees Dance Goofy"] = "rbxassetid://120452122477461",
	["Demon Slayer Douma Sit"] = "rbxassetid://127626736897320",
	["Seizure"] = "rbxassetid://98719422024341",
	["I Wanna Run Away"] = "rbxassetid://104428851742579",
	["Boxing"] = "rbxassetid://80933111363555",
	["SpiderMan Hang"] = "rbxassetid://83345430870757",
	["Speed Mirage"] = "rbxassetid://96731289267640",
	["Helicopter"] = "rbxassetid://76510079095692",
	["Possessed Glitcher"] = "rbxassetid://80103653497738",
	["Take The L"] = "rbxassetid://81809682819287",
	["Basketball Head"] = "rbxassetid://138243322520289",
	["Be tall creature"] = "rbxassetid://91348372558295",
}

local animationname = {}
for name, _ in pairs(animationlist) do
	table.insert(animationname, name)
end
table.sort(animationname, function(a, b)
	return a < b
end)

local selectedanim

local function getPlayAnimation(animId)
	if _G.animTrack then
		_G.animTrack:Stop()
		_G.animTrack:Destroy() -- optional, just to fully clean up
		_G.animTrack = nil
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = animId

	_G.animTrack = Humanoid:LoadAnimation(animation)
	_G.animTrack:Play()
end

local function clearAnimation()
	if _G.animTrack then
		_G.animTrack:Stop()
		_G.animTrack:Destroy()
		_G.animTrack = nil
	end
end

_G.CharacterGroupbox
	:CreateLabel({
		Name = "Select Animation [R15]",
		Icon = _G.NebulaIcons:GetIcon("camera_roll", "Material"),
	}, "LabelAnim")
	:AddDropdown({
		Options = animationname,
		CurrentOptions = {},
		Placeholder = "None Selected",
		Callback = function(opt)
			selectedanim = opt[1]
		end,
	}, "DDAnim")

_G.CharacterGroupbox:CreateButton({
	Name = "Play Animation",
	Icon = _G.NebulaIcons:GetIcon("circle-play", "Lucide"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		if selectedanim and animationlist[selectedanim] then
			getPlayAnimation(animationlist[selectedanim])
		end
	end,
}, "BtnPlayAnim")

_G.CharacterGroupbox:CreateButton({
	Name = "Stop Animation",
	Icon = _G.NebulaIcons:GetIcon("square-pause", "Lucide"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		clearAnimation()
	end,
}, "BtnStopAnim")

_G.CharacterGroupbox:CreateDivider()
_G.CharacterGroupbox:CreateButton({
	Name = "Server",
	Style = 1,
	CenterContent = true,
	Callback = function() end,
}, "BtnServer")

local originalCache = { Lighting = {}, Terrain = {}, Visuals = {} }

local function getProps(obj, props)
	local t = {}
	for _, prop in ipairs(props) do
		t[prop] = obj[prop]
	end
	return t
end

local function clearProps(obj, props)
	for prop, val in pairs(props) do
		obj[prop] = val
	end
end

local function getFPSBoost()
	if not originalCache.Lighting.GlobalShadows then
		originalCache.Lighting = getProps(game.Lighting, { "GlobalShadows", "Brightness", "FogEnd" })
		originalCache.QualityLevel = settings().Rendering.QualityLevel
	end

	if not originalCache.Terrain.WaterWaveSize then
		originalCache.Terrain =
			getProps(workspace.Terrain, { "WaterWaveSize", "WaterWaveSpeed", "WaterReflectance", "WaterTransparency" })
	end

	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	game.Lighting.GlobalShadows = false
	game.Lighting.Brightness = 1
	game.Lighting.FogEnd = 9e9
	workspace.Terrain.WaterWaveSize = 0
	workspace.Terrain.WaterWaveSpeed = 0
	workspace.Terrain.WaterReflectance = 0
	workspace.Terrain.WaterTransparency = 0

	-- Optimize visuals (save originals)
	if not originalCache.VisualsCached then
		originalCache.Visuals = {}
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				if not originalCache.Visuals[v] then
					originalCache.Visuals[v] = getProps(v, { "Material", "Reflectance" })
				end
				v.Material = Enum.Material.Plastic
				v.Reflectance = 0
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				if not originalCache.Visuals[v] then
					originalCache.Visuals[v] = getProps(v, { "Enabled" })
				end
				v.Enabled = false
			end
		end
		originalCache.VisualsCached = true
	end
end

local function clearFPSBoost()
	if originalCache.Lighting.GlobalShadows ~= nil then
		clearProps(game.Lighting, originalCache.Lighting)
	end
	if originalCache.QualityLevel then
		settings().Rendering.QualityLevel = originalCache.QualityLevel
	end
	if originalCache.Terrain.WaterWaveSize ~= nil then
		clearProps(workspace.Terrain, originalCache.Terrain)
	end
	if originalCache.Visuals then
		for inst, props in pairs(originalCache.Visuals) do
			if inst then
				clearProps(inst, props)
			end
		end
	end

	originalCache.VisualsCached = false
end

_G.CharacterGroupbox:CreateToggle({
	Name = "FPS Boost",
	Icon = _G.NebulaIcons:GetIcon("4k", "Material"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		Disconnect("FPSBoost")
		if state then
			getFPSBoost()
			_G.Conns["FPSBoost"] = RunEvery(2, getFPSBoost) -- Re-apply periodically for new objects
		else
			clearFPSBoost()
		end
	end,
}, "ToggleFPSBoost")

local originalLighting = originalLighting or {}

local function getFullBright()
	if not originalLighting.Brightness then
		originalLighting = getProps(Lighting, { "Brightness", "ClockTime", "FogEnd", "Ambient", "OutdoorAmbient" })
	end
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.Ambient = Color3.fromRGB(230, 230, 230)
	Lighting.OutdoorAmbient = Color3.fromRGB(230, 230, 230)
end

local function clearFullBright()
	if originalLighting.Brightness then
		clearProps(Lighting, originalLighting)
	end
end

_G.CharacterGroupbox:CreateToggle({
	Name = "Full Bright",
	Icon = _G.NebulaIcons:GetIcon("brightness_6", "Material"),
	CurrentValue = false,
	Style = 2,
	Callback = function(state)
		Disconnect("Bright")
		if state then
			getFullBright()
			_G.Conns["Bright"] = Lighting.Changed:Connect(getFullBright)
		else
			clearFullBright()
		end
	end,
}, "ToggleFullBright")

_G.CharacterGroupbox:CreateDivider()

local function getAntiAFK()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end

_G.CharacterGroupbox:CreateToggle({
	Name = "Anti AFK",
	Icon = _G.NebulaIcons:GetIcon("snooze", "Material"),
	CurrentValue = true,
	Style = 2,
	Callback = function(state)
		Disconnect("AntiAFK")
		if state then
			_G.Conns["AntiAFK"] = RunEvery(60, getAntiAFK)
		end
	end,
}, "ToggleAntiAFK")

_G.CharacterGroupbox:CreateToggle({
	Name = "Anti Rejoin",
	Icon = _G.NebulaIcons:GetIcon("access_alarm", "Material"),
	CurrentValue = true,
	Style = 2,
	Callback = function(state)
		if state then
			if not _G.OldTeleport then
				_G.OldTeleport = hookfunction(TeleportService.Teleport, function(self, placeId, ...)
					if placeId == game.PlaceId then
						warn("[Karbid - Anti Rejoin] Blocked AFK rejoin teleport to same PlaceId:", placeId)
						return
					end
					return _G.OldTeleport(self, placeId, ...)
				end)
			end
		else
			if _G.OldTeleport then
				hookfunction(game:GetService("TeleportService").Teleport, _G.OldTeleport)
				_G.OldTeleport = nil
			end
		end
	end,
}, "ToggleAntiRejoin")

local function getRejoin()
	local successRejoin, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Plr)
	end)
	if not successRejoin then
		TeleportService:Teleport(PlaceId)
	end
end

_G.CharacterGroupbox:CreateButton({
	Name = "Server Rejoin ",
	Icon = _G.NebulaIcons:GetIcon("cloud_download", "Material"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		getRejoin()
	end,
}, "BtnRejoin")

-- ...existing code...

local ServerHop = {}
local TEMP_FILE = "server-hop-temp.json"
local SERVERS_API = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"

local function loadVisitedServers()
	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile(TEMP_FILE))
	end)

	if success and type(data) == "table" then
		return data
	end

	local visited = { hour = os.date("!*t").hour, servers = {} }
	pcall(function()
		writefile(TEMP_FILE, HttpService:JSONEncode(visited))
	end)
	return visited
end

local function saveVisitedServers(data)
	pcall(function()
		writefile(TEMP_FILE, HttpService:JSONEncode(data))
	end)
end

local function cleanupIfNeeded(visitedData)
	local currentHour = os.date("!*t").hour
	if visitedData.hour ~= currentHour then
		pcall(function()
			delfile(TEMP_FILE)
		end)
		return { hour = currentHour, servers = {} }
	end
	return visitedData
end

local function isServerVisited(serverId, visitedServers)
	for _, id in ipairs(visitedServers) do
		if id == serverId then
			return true
		end
	end
	return false
end

local function fetchServers(placeId, cursor)
	local url = string.format(SERVERS_API, placeId)
	if cursor and cursor ~= "" then
		url = url .. "&cursor=" .. cursor
	end

	local success, response = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	if not success then
		warn("[ServerHop] Failed to fetch servers:", response)
		return nil
	end

	return response
end

local function attemptTeleport(placeId, serverId, visitedData)
	table.insert(visitedData.servers, serverId)
	saveVisitedServers(visitedData)

	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(placeId, serverId, Plr)
	end)

	if not success then
		warn("[ServerHop] Teleport failed:", err)
		return false
	end

	return true
end

function ServerHop:Teleport(placeId)
	placeId = placeId or PlaceId
	local visitedData = cleanupIfNeeded(loadVisitedServers())
	local cursor = ""
	local attempts = 0
	local maxAttempts = 10

	while attempts < maxAttempts do
		attempts = attempts + 1

		local serverData = fetchServers(placeId, cursor)
		if not serverData or not serverData.data then
			warn("[ServerHop] No server data available")
			task.wait(2)
			cursor = ""
			continue
		end

		for _, server in ipairs(serverData.data) do
			local serverId = tostring(server.id)
			local hasSpace = tonumber(server.playing) < tonumber(server.maxPlayers)
			local notVisited = not isServerVisited(serverId, visitedData.servers)

			if hasSpace and notVisited then
				print(
					string.format(
						"[ServerHop] Joining server %s (%d/%d players)",
						serverId,
						server.playing,
						server.maxPlayers
					)
				)

				if attemptTeleport(placeId, serverId, visitedData) then
					return true
				end

				task.wait(4)
			end
		end

		if serverData.nextPageCursor and serverData.nextPageCursor ~= "null" then
			cursor = serverData.nextPageCursor
		else
			cursor = ""
			task.wait(2)
		end
	end

	warn("[ServerHop] Failed to find suitable server after", maxAttempts, "attempts")
	return false
end

_G.CharacterGroupbox:CreateButton({
	Name = "Server Hop ",
	Icon = _G.NebulaIcons:GetIcon("cloud_upload", "Material"),
	Style = 2,
	IndicatorStyle = 2,
	Callback = function()
		ServerHop:Teleport(PlaceId)
	end,
}, "BtnServerHop")
