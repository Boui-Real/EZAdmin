--Fake lag manager

local FakelagManager = {
	Ticks = 16;
	Enabled = false;
}

local NetworkClient = game:GetService("NetworkClient")

function FakelagManager.Enable()
	FakelagManager.Enabled = true

	local CurrentTick = 0

	while wait() do
		if FakelagManager.Enabled == false then break end

		if CurrentTick < FakelagManager.Ticks then
			CurrentTick += 1
			NetworkClient:SetOutgoingKBPSLimit(1)
		else
			CurrentTick = 0
			NetworkClient:SetOutgoingKBPSLimit(9e9) 
		end
	end

	NetworkClient:SetOutgoingKBPSLimit(9e9)
end

function FakelagManager.Disable()
	FakelagManager.Enabled = false

	NetworkClient:SetOutgoingKBPSLimit(9e9)
end

return FakelagManager
