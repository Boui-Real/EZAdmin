repeat
	 wait()
until game:IsLoaded()

local Player = game.Players.LocalPlayer

if getgenv().ezAdmin ~= nil and getgenv().ezAdmin.Runned == true then
	return
end

local RunService = game:GetService("RunService")

getgenv().ezAdmin = {
	Flying = false;
	Noclip = false;
	Runned = true;
	Swim = {
		Swimming = false;
		Reset = nil;
		OldGravity = 0;
	};
	Chams = false;
	Teamcheck = true;
}

if makefolder ~= nil then
	makefolder("ezadmin")
	makefolder("ezadmin/custom_modules")
end

function isAlive(plr)
	if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") then
		return true
	end
	return false
end

function boxhandle(part,color)

	if typeof(part) == "Instance" then
		if part:IsA("BasePart") then
			local Adorn = Instance.new("BoxHandleAdornment", part)
			Adorn.Name = "chams_ez"
			Adorn.Color3 = color
			Adorn.Size = part.Size
			Adorn.Adornee = part
			Adorn.AlwaysOnTop = true
			Adorn.ZIndex = 1

			spawn(function()
				while part ~= nil and getgenv().ezAdmin.Chams do
					wait()
				end
				Adorn:Destroy()
			end)
		end
	end
end

function getCount(t)
	local count = 0

	for i,v in pairs(t) do
		count += 1
	end

	return count
end

local Commands = {
	["explorer"] = {Name = "explorer", Aliases = {"dex"}, Description = "Load game explorer",func = function()
		local Dex = game:GetObjects("rbxassetid://3567096419")[1]
		Dex.Parent = (gethui() ~= nil and gethui() or game:GetService("CoreGui"))

		local function Load(Obj, Url)
			local function GiveOwnGlobals(Func, Script)
				local Fenv = {}
				local RealFenv = {script = Script}
				local FenvMt = {}
				FenvMt.__index = function(a,b)
					if RealFenv[b] == nil then
						return getfenv()[b]
					else
						return RealFenv[b]
					end
				end
				FenvMt.__newindex = function(a, b, c)
					if RealFenv[b] == nil then
						getfenv()[b] = c
					else
						RealFenv[b] = c
					end
				end
				setmetatable(Fenv, FenvMt)
				setfenv(Func, Fenv)
				return Func
			end
			local function LoadScripts(Script)
				if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
					task.spawn(function()
						GiveOwnGlobals(loadstring(Script.Source, "=" .. Script:GetFullName()), Script)()
					end)
				end
				for i,v in pairs(Script:GetChildren()) do
					LoadScripts(v)
				end
			end
			LoadScripts(Obj)
		end

		Load(Dex)
	end};
	["hide"] = {Name = "hide", Aliases = {"hideez","hideadmin"}, Description = "Hide admin console",func = function()
		rconsoleclose()
	end};
	["fly"] = {Name = "fly", Aliases = {}, Description = "Start flying", Arguments = {["speed"] = "int"}, func = function(speed)
		repeat
    		wait()
		until Player and Player.Character and
		    Player.Character:findFirstChild("Head") and
		    Player.Character:findFirstChild("Humanoid")
		local mouse = Player:GetMouse()
		getgenv().ezAdmin.Flying = true
		repeat
		    wait()
		until mouse
		local torso = Player.Character.Head
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}

		function Fly()
		    local bg = Instance.new("BodyGyro", torso)
		    bg.P = 9e4
		    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		    bg.cframe = torso.CFrame
		    local bv = Instance.new("BodyVelocity", torso)
		    bv.velocity = Vector3.new(0, 0.1, 0)
		    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		    repeat
		        wait()
		        Player.Character.Humanoid.PlatformStand = true
		        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
		            speed = speed + .5
		        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
		            speed = speed - 1
		            if speed < 0 then
		                speed = 0
		            end
		        end
		        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
		            bv.velocity =
		                ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) +
		                ((game.Workspace.CurrentCamera.CoordinateFrame *
		                    CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) -
		                    game.Workspace.CurrentCamera.CoordinateFrame.p)) *
		                speed
		            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
		        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
		            bv.velocity =
		                ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) +
		                ((game.Workspace.CurrentCamera.CoordinateFrame *
		                    CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) -
		                    game.Workspace.CurrentCamera.CoordinateFrame.p)) *
		                speed
		        else
		            bv.velocity = Vector3.new(0, 0.1, 0)
		        end
		        bg.cframe =
		            game.Workspace.CurrentCamera.CoordinateFrame *
		            CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50), 0, 0)
		    until not getgenv().ezAdmin.Flying
		    ctrl = {f = 0, b = 0, l = 0, r = 0}
		    lastctrl = {f = 0, b = 0, l = 0, r = 0}
		    speed = 0
		    bg:Destroy()
		    bv:Destroy()
		    Player.Character.Humanoid.PlatformStand = false
		end
		mouse.KeyDown:connect(
		    function(key)
		        if key:lower() == "w" then
		            ctrl.f = 1
		        elseif key:lower() == "s" then
		            ctrl.b = -1
		        elseif key:lower() == "a" then
		            ctrl.l = -1
		        elseif key:lower() == "d" then
		            ctrl.r = 1
		        end
		    end
		)
		mouse.KeyUp:connect(
		    function(key)
		        if key:lower() == "w" then
		            ctrl.f = 0
		        elseif key:lower() == "s" then
		            ctrl.b = 0
		        elseif key:lower() == "a" then
		            ctrl.l = 0
		        elseif key:lower() == "d" then
		            ctrl.r = 0
		        end
		    end
		)
		
		spawn(function()
			Fly()
		end)

	end};
	["nofly"] = {Name = "nofly", Aliases = {"unfly"}, Description = "Disable fly", func = function()
		getgenv().ezAdmin.Flying = false
	end};
	["noclip"] = {Name = "noclip", Aliases = {}, Description = "Go through objects", func = function()
		getgenv().ezAdmin.Noclip = true
		local function NoclipLoop()
			if getgenv().ezAdmin.Noclip and Player.Character ~= nil then
				for _, child in pairs(Player.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = false
					end
				end
			end
		end

		game:GetService("RunService").Stepped:Connect(NoclipLoop)
	end};
	["clip"] = {Name = "clip", Aliases = {"unnoclip","nonoclip"}, Description = "Disable noclip",func = function()
		getgenv().ezAdmin.Noclip = false
	end};
	["setfpscap"] = {Name = "setfpscap", Aliases = {"setfps"}, Description = "Set your max fps", Arguments = {["fps"] = "int"}, func = function(fps)
		if setfpscap ~= nil then
			setfpscap(fps)
		else
			rconsoleerr("Didn't find setfpscap function")
		end
	end};
	["swim"] = {Name = "swim", Aliases = {}, Description = "Swim everywhere", func = function()
		workspace.Gravity = 0
		
		local function onReset()
			getgenv().ezAdmin.Swim.Swimming = false
			workspace.Gravity = 198.2
		end

		getgenv().ezAdmin.Swim.Reset = Player.Character:FindFirstChildOfClass('Humanoid').Died:Connect(onReset)

		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		getgenv().ezAdmin.Swim.Swimming = true

	end};
	["noswim"] = {Name = "noswim", Aliases = {"unswim"}, Description = "Stop swimming everywhere", func = function()
		
		if getgenv().ezAdmin.Swim.Swimming then
			getgenv().ezAdmin.Swim.Swimming = false
			workspace.Gravity = 198.2

			if getgenv().ezAdmin.Swim.Reset then
				getgenv().ezAdmin.Swim.Reset:Disconnect()
			end

			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
			Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
			Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)

		end

	end};
	["gravity"] = {Name = "gravity", Aliases = {"setgravity","grav"}, Description = "Set local gravity", Arguments = {["amount"] = "int"}, func = function(amount)
		workspace.Gravity = amount
	end};
	["noclipcam"] = {Name = "noclipcamera", Aliases = {"nccam"}, Description = "Your camera will be able to go through objects", func = function()
		local sc = (debug and debug.setconstant) or setconstant
		local gc = (debug and debug.getconstants) or getconstants
		if not sc or not getgc or not gc then
			return rconsoleerr("Your exploit doesn't support setconstant or getconstants or getgc")
		end
		local pop = Player.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for _, v in pairs(getgc()) do
			if type(v) == 'function' and getfenv(v).script == pop then
				for i, v1 in pairs(gc(v)) do
					if tonumber(v1) == .25 then
						sc(v, i, 0)
					elseif tonumber(v1) == 0 then
						sc(v, i, .25)
					end
				end
			end
		end
	end};
	["clipcam"] = {Name = "clipcam", Aliases = {"ccam"}, Description = "Disable camera noclip", func = function()
		local sc = (debug and debug.setconstant) or setconstant
		local gc = (debug and debug.getconstants) or getconstants
		if not sc or not getgc or not gc then
			return rconsoleerr("Your exploit doesn't support setconstant or getconstants or getgc")
		end
		local pop = Player.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for _, v in pairs(getgc()) do
			if type(v) == 'function' and getfenv(v).script == pop then
				for i, v1 in pairs(gc(v)) do
					if tonumber(v1) == .25 then
						sc(v, i, 0)
					elseif tonumber(v1) == 0 then
						sc(v, i, .25)
					end
				end
			end
		end
	end};
	["chams"] = {Name = "chams", Aliases = {"esp"}, Description = "See players through", func = function()
		getgenv().ezAdmin.Chams = true

		RunService:BindToRenderStep("Chams",1,function()

			if getgenv().ezAdmin.Chams == false then return RunService:UnbindFromRenderStep("Chams") end

			for i,v in pairs(game.Players:GetPlayers()) do
				if v ~= Player then
					if Player.Team ~= nil and (getgenv().ezAdmin.Teamcheck == true and v.Team ~= Player.Team or false) then
						if isAlive(v) then
							for _,part in pairs(v.Character:GetChildren()) do
								if part:IsA("BasePart") then
									if not part:FindFirstChild("chams_ez") then
										boxhandle(part, v.Team.Color)
									end
								end
							end
						end
					elseif Player.Team == nil then
						if isAlive(v) then
							for _,part in pairs(v.Character:GetChildren()) do
								if part:IsA("BasePart") then
									if not part:FindFirstChild("chams_ez") then
										boxhandle(part, Color3.fromRGB(255, 0, 0))
									end
								end
							end
						end
					elseif getgenv().ezAdmin.Teamcheck == false then
						if isAlive(v) then
							for _,part in pairs(v.Character:GetChildren()) do
								if part:IsA("BasePart") then
									if not part:FindFirstChild("chams_ez") then
										boxhandle(part, Color3.fromRGB(255, 0, 0))
									end
								end
							end
						end
					end
				end
			end
		end)

	end};
	["nochams"] = {Name = "nochams", Aliases = {"noesp","unesp","unchams"}, Description = "Disable esp", func = function()
		getgenv().ezAdmin.Chams = false
	end};
	["hydroxide"] = {Name = "hydroxide", Aliases = {"remotespy"}, Description = "Load hydroxide script", func = function()
		local owner = "Upbolt"
		local branch = "revision"

		local function webImport(file)
		    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
		end

		webImport("init")
		webImport("ui/main")
	end}
}

local listfiles = listfiles or listdir or syn_io_listdir

if listfiles ~= nil then
	for i,v in pairs(listfiles("ezadmin/custom_modules")) do
		if v:sub(-3) == ".ez" then

			local vTable = loadstring("return " .. readfile(v))()

			vTable.Custom = true

			table.insert(Commands, vTable)
		end
	end
end

function rconsolecustomprint(header, headerColor, text)
	rconsoleprint('[')
	rconsoleprint("@@" .. headerColor .. "@@")
	rconsoleprint(header)
	rconsoleprint("@@WHITE@@")
	rconsoleprint("] " .. text)
end

function getCommand(name)
	for i,v in pairs(Commands) do
		if v.Name:lower() == name:lower() then
			return v
		else
			for i2,v2 in pairs(v.Aliases) do
				if v2:lower() == name:lower() then
					return v
				end
			end
		end
	end
end

local function displayAdmin()
	rconsolename("EZAdmin v1.0")
	rconsoleclear()
	rconsoleinfo("Script made by boui")
	
	function askCommand()
		rconsolecustomprint("EZADMIN","GREEN","Please, enter command: ")
		local commandText = rconsoleinput()

		repeat
			wait()
		until commandText ~= nil

		local command = getCommand(commandText)

		if command ~= nil then
			if command.Name:lower() ~= "hide" then
				if command.Arguments ~= nil then
					if getCount(command.Arguments) == 1 then
						for i,v in pairs(command.Arguments) do
							if v == "int" then
								rconsolecustomprint("EZADMIN","GREEN","Please, enter " .. i:lower() .. ": ")
								local int = rconsoleinput()

								repeat
									wait()
								until int ~= nil

								command.func(tonumber(int))
							end
						end
					end
				else
					command.func()
				end
				--rconsoleprint("\n")
				askCommand()
			else
				command.func()
			end
		else
			if commandText == "cmds" or commandText == "commands" then
				for i,v in pairs(Commands) do
					local astring = ""

					if getCount(v.Aliases) > 0 then
						for i2,v2 in pairs(v.Aliases) do
							if i2 == getCount(v.Aliases) then
								astring = astring .. v2
							else
								astring = astring .. v2 .. ", "
							end
						end
					end

					if astring ~= "" then
						rconsoleinfo(v.Name .. " or " .. astring .. ": " .. v.Description)
					else
						rconsoleinfo(v.Name .. ": " .. v.Description)
					end
				end
				askCommand()
			else
				rconsoleerr("Command not found")
				askCommand()
			end
		end

	end

	askCommand()

end

Player.Chatted:Connect(function(msg)
	if msg:lower() == "/e admin" then
		displayAdmin()
	end
end)
