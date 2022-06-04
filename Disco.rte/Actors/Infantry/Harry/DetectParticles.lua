
function Create(self)
	self.detectedParticles = {}
	self.detectedParticleClose = false
	self.detectedParticleCloseLasting = 0
	
	self.soundFlyby = CreateSoundContainer("Harry Dodge Flyby", "Harry.rte")
end


function Update(self)
	self.detectedParticleClose = false
	self.detectedParticleCloseLasting = math.max(self.detectedParticleCloseLasting - TimerMan.DeltaTimeSecs * 3, 0)
	
	if not self:IsPlayerControlled() then
		return
	end
	
	for mo in MovableMan.AddedParticles do
		if (mo.ClassName == "MOPixel" or mo.ClassName == "MOSParticle" or mo.ClassName == "MOSRotating" or mo.ClassName == "A") and mo.HitsMOs and mo.Sharpness > 0 and mo.Team ~= self.Team then-- and (string.find(mo.PresetName, "Pellet") or string.find(mo.PresetName, "Bullet") or string.find(mo.PresetName, "Projectile")) then
			self.detectedParticles[mo.UniqueID] = mo
		end
	end
	
	--PrimitiveMan:DrawCirclePrimitive(self.Pos, self.Radius, 13)
	for uniqueID, mo in pairs(self.detectedParticles) do
		--local mo = MovableMan:FindObjectByUniqueID(uniqueID)
		--print(MovableMan:ValidMO(moOriginal))
		if MovableMan:ValidMO(mo) then
			local difference = SceneMan:ShortestDistance(self.Pos, mo.Pos, SceneMan.SceneWrapsX)
			local distance = difference.X * difference.X + difference.Y * difference.Y
			
			--local distance = difference.Magnitude
			if (mo.Vel.X * mo.Vel.X + mo.Vel.Y * mo.Vel.Y) > 25 * 25 and (difference.Normalized:Dot(Vector(mo.Vel.X, mo.Vel.Y).Normalized) < -0.97 or distance < 64 * 64) and distance < 160 * 160 then
				PrimitiveMan:DrawCirclePrimitive(mo.Pos, 6, 13)
				self.detectedParticleClose = true
				self.detectedParticleCloseLasting = 1
				
				if self.dodgeDuration > 0 and distance < 90 * 90 then
					mo.HitsMOs = false
					self.detectedParticles[uniqueID] = nil
					self.soundFlyby:Play(mo.Pos)
					
					self.RotAngle = self.RotAngle + RangeRand(-1, 1) * math.rad(25)
					self.AngularVel = self.AngularVel + RangeRand(-1, 1) * math.rad(15) 
				end
			end
		else
			self.detectedParticles[uniqueID] = nil
		end
	end
end