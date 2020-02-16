AddCSLuaFile("shared.lua")

include("shared.lua")
	
function ENT:Initialize()
	self:SetNWString( "Nükleer Enerji Alıcısı" );
	self:SetModel( "models/props_lab/reciever_cart.mdl")
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
	if ent:GetClass() == "energy" and self.isTrs == false then
		ent:Remove()
		self.isTrs = true
		self.finishTrsTime = CurTime() + 1
	end
end

function ENT:Think()
	if self.isTrs == true then
		if self.finishTrsTime <= CurTime() then
			self.isTrs = false
			if self.isTrs == false then
				EmitSound( Sound( "garrysmod/save_load1.wav" ), Entity( 1 ):GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
				DarkRP.createMoneyBag(self:GetPos() + Vector(0, 0,-18), 25000)
			end
		end
	end
end