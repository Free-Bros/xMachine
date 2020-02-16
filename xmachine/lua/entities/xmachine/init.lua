AddCSLuaFile("shared.lua")

include("shared.lua")
	
function ENT:Initialize()
	self:SetModel( "models/props_wasteland/laundry_washer003.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.isTrs = false
	self.finishTrsTime = 0
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "photontube" and self.isTrs == false then
		ent:Remove()

		self.isTrs = true
		self.finishTrsTime = CurTime() + 180

		self.sound = CreateSound(self, Sound("npc/combine_gunship/dropship_engine_distant_loop1.wav"))
        self.sound:SetSoundLevel(80)
        self.sound:PlayEx(1, 100)
	end
end

function ENT:Think()
	if self.isTrs == true then
		self:SetColor(Color(255,0,0))
	else
		self:SetColor(Color(0,255,0))
	end
	
	if self.isTrs == true then
		if self.finishTrsTime <= CurTime() then
			self.isTrs = false

   			local effectdata = EffectData()
    		effectdata:SetOrigin(self:GetPos())
    		effectdata:SetMagnitude(1)
    		effectdata:SetScale(1)
    		effectdata:SetRadius(2)
    		util.Effect("Sparks", effectdata)

			if self.sound then
        		self.sound:Stop()
    		end

			self.sound = CreateSound(self, Sound("items/battery_pickup.wav"))
        	self.sound:SetSoundLevel(100)
        	self.sound:PlayEx(1, 100)
			local energy = ents.Create("energy")
			energy:SetPos(self:GetPos() + Vector(0,25,0))
			energy:Spawn()
		end
	end
end

function ENT:OnRemove()
    if self.sound then
        self.sound:Stop()
    end
end
