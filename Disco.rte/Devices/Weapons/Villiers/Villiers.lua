function Create(self)
	self.parent = nil
	self.parentSet = false;
	
	self.soundChamber = CreateSoundContainer("Disco Villiers Chamber", "Disco.rte");
	
	self.rotation = 0
	self.rotationTarget = 0
	self.rotationSpeed = 7
	
	self.preFireTimer = Timer()
	self.preFire = false
	self.preFireFired = false
	self.preFireActive = false
	self.preDelay = 200
	
	self.parentSet = false;
	
	self.recoil = 0
	self.accuracy = 1
	self.accuracySway = 0
	
	self.targeting = false
	self.targetingActor = nil
	self.targetingAnimationProgress = 0
	
	self.targetingAwaitingSkillCheck = false
	self.targetingSuccess = false
	
	self.VOTriggerTimer = Timer();
	self.VOTriggerDelay = 5000;
	
end
function Update(self)
	
	self.rotationTarget = 0
	
	if self.ID == self.RootID then
		self.parent = nil;
		self.parentSet = false;
	elseif self.parentSet == false then
		local actor = self:GetRootParent()
		if actor and IsAHuman(actor) then
			self.parent = ToAHuman(actor);
			self.parentSet = true;
		end
		
		-- Worth checking the UID!
		--self.checkBrokenUIDTimer:Reset()
	end
	
	--self.Reloadable = false
	
	if self:NumberValueExists("DiceRollQueued") or self.recoil > 0 then
		self:Deactivate()
	end
	
	-- if not self:NumberValueExists("DiceRollQueued") then
		-- self.targetingAwaitingSkillCheck = false
	-- end
	
	-- TARGETING!!!
	if self.parent then
		local controller = self.parent:GetController()
		if controller:IsState(Controller.AIM_SHARP) == true and
			controller:IsState(Controller.MOVE_LEFT) == false and
			controller:IsState(Controller.MOVE_RIGHT) == false and
			self.recoil <= 0 and
			(self.Magazine and self.Magazine.RoundCount > 0) and
			not self:IsReloading() and 
			not self.preFireActive and
			not self.targetingAwaitingSkillCheck
		then
			self.targeting = true
		else
			self.targeting = false
		end
		
		
		if self.targeting then
			local targets = {}
			
			local rayOrigin = Vector(self.Pos.X, self.Pos.Y)
			local rayVec = Vector(600 * self.FlipFactor, 0):RadRotate(self.RotAngle);
			
			local maxi = 3
			for i = -maxi, maxi do
				local factor = i / maxi
				local spread = math.rad(5)
				
				local moCheck = SceneMan:CastMORay(rayOrigin, Vector(rayVec.X, rayVec.Y):RadRotate(factor * spread), 255, self.parent.Team, 0, false, math.random(4, 6)); -- Raycast
				if moCheck ~= rte.NoMOID then
					local mo = MovableMan:GetMOFromID(moCheck)
					if IsMOSRotating(mo) then
						local parent = mo:GetRootParent()
						if parent and IsActor(parent) then
							local actor = ToActor(parent)
							if actor.Status < 2 then
								table.insert(targets, {actor, factor})
							end
						end
						
					end
					
				end
			end
			
			if #targets > 0 then
				local bestActor
				local bestFactor = math.huge
				for i, target in ipairs(targets) do
					local actor = target[1]
					local factor = target[2]
					
					if math.abs(factor) < math.abs(bestFactor) then
						bestFactor = factor
						bestActor = actor
					end
				end
				
				
				if self.targetingActor and self.targetingActor ~= bestActor.UniqueID then
					self.targetingAnimationProgress = 0
				end
				if self.recoil <= 0 then
					self.parent:SetNumberValue("SlowmoDuration", 0.7)
				end
				self.targetingActor = bestActor.UniqueID
				self.targetingAnimationProgress = math.min(self.targetingAnimationProgress + TimerMan.DeltaTimeSecs / TimerMan.TimeScale * 2, 1)
			else
				if self.recoil <= 0 and not self.preFireActive and not self.targetingAwaitingSkillCheck then
					self.targetingAnimationProgress = math.max(self.targetingAnimationProgress - TimerMan.DeltaTimeSecs / TimerMan.TimeScale * 2, 0)
					if self.targetingAnimationProgress <= 0 then
						self.targetingActor = nil
					end
				end
			end
		else
			if self.recoil <= 0 and not self.preFireActive and not self.targetingAwaitingSkillCheck then
				self.targetingAnimationProgress = math.max(self.targetingAnimationProgress - TimerMan.DeltaTimeSecs / TimerMan.TimeScale * 2, 0)
				if self.targetingAnimationProgress <= 0 then
					self.targetingActor = nil
				end
			end
		end
		
		if self.targetingActor then
			if self.VOTriggerTimer:IsPastSimMS(self.VOTriggerDelay) and self.targetingVOPlayed == false then
				if math.random() < 0.2 then
					self.parent:SetNumberValue("Targeting VO", 1);
				end
				self.targetingVOPlayed = true;
				self.VOTriggerTimer:Reset();
			end
			local actor = MovableMan:FindObjectByUniqueID(self.targetingActor)
			if actor and IsActor(actor) then
				actor = ToActor(actor)
				
				-- Skill check
				if self.targeting then
					local thershold = 6
					
					local difference = SceneMan:ShortestDistance(self.Pos, actor.Pos, SceneMan.SceneWrapsX)
					local distance = difference.Magnitude
					
					local factor = distance / 100
					thershold = math.floor(factor + (1 - self.accuracy) * 10 * math.abs(math.sin(self.accuracySway))) + 2
					
					self.parent:SetNumberValue("SkillChanceThreshold", thershold)
					if self:IsActivated() then
						self.parent:SetNumberValue("DiceRollThreshold", thershold)
						self.targetingAwaitingSkillCheck = true
					end
				end
				
				-- HUD
				local center = Vector(actor.Pos.X, actor.Pos.Y)
				
				local highest = 0
				local lowest = 0
				local right = 0
				local left = 0
				for limb in actor.Attachables do
					local pos = Vector(limb.Pos.X, limb.Pos.Y)
					local offset = center - pos
					
					local radius = limb.IndividualRadius
					
					if (offset.X + radius) > right then right = offset.X + radius end
					if (offset.X - radius) < left then left = offset.X - radius end
					
					if (offset.Y - radius) < lowest then lowest = offset.Y - radius end
					if (offset.Y + radius) > highest then highest = offset.Y + radius end
					
					
					for gear in limb.Attachables do
						local pos = Vector(gear.Pos.X, gear.Pos.Y)
						local offset = center - pos
						
						local radius = limb.IndividualRadius
						if (offset.X + radius) > right then right = offset.X + radius end
						if (offset.X - radius) < left then left = offset.X - radius end
						
						if (offset.Y - radius) < lowest then lowest = offset.Y - radius end
						if (offset.Y + radius) > highest then highest = offset.Y + radius end
						
						--PrimitiveMan:DrawCirclePrimitive(pos, radius, 5)
					end
					
					--PrimitiveMan:DrawCirclePrimitive(pos, radius, 5)
				end
				highest = -highest
				lowest = -lowest
				right = -right
				left = -left
				
				local factor = self.targetingAnimationProgress *self.targetingAnimationProgress
				local color = 223
				local colorBG = 173--200
				local origin = actor.Pos
				
				local hudUpperPos = origin + Vector(0, highest - 5)
				local hudLowerPos = origin + Vector(0, lowest)
				
				local hudRightPos = origin + Vector(right, 0)
				local hudLeftPos = origin + Vector(lowest, 0)
				
				
				
				-- Display foe name
				local name = actor.PresetName
				PrimitiveMan:DrawBoxFillPrimitive(hudLowerPos + Vector(-30 * factor, -5), hudLowerPos + Vector(30 * factor, 5), colorBG)
				--PrimitiveMan:DrawTextPrimitive(hudLowerPos + Vector(0, -7), "Foe:", true, 1)
				PrimitiveMan:DrawTextPrimitive(hudLowerPos + Vector(0, -5), string.sub(name, 0, math.floor(string.len(name) * factor + 0.5)), true, 1)
				PrimitiveMan:DrawCircleFillPrimitive(hudLowerPos + Vector(-30 * factor, 0) + Vector(-5, 0), 1, color)
				
				local hudLowerLine = Vector(25, 0) * self.targetingAnimationProgress
				PrimitiveMan:DrawLinePrimitive(hudLowerPos - hudLowerLine + Vector(0, -7), hudLowerPos + hudLowerLine + Vector(0, -7), color)
				
				
				-- Active skill check
				if self.targeting then
					PrimitiveMan:DrawCirclePrimitive(hudLowerPos + Vector(0, -7), math.ceil(2 * (1 - self.accuracy)), color)
					PrimitiveMan:DrawCircleFillPrimitive(hudLowerPos + hudLowerLine * math.sin(self.accuracySway) * (1 - self.accuracy) + Vector(0, -7), math.ceil(2 * (1 - self.accuracy)), color)
				end
				
				
				if actor and IsAHuman(actor) then
					actor = ToAHuman(actor)
					if actor.Head and math.random() <= self.accuracy then
						local rand = Vector(RangeRand(-1, 1), RangeRand(-1, 1)) * (1 - self.accuracy) * 2
						PrimitiveMan:DrawCirclePrimitive(actor.Head.Pos + rand, actor.Head.Radius + 7 * (1 - self.accuracy), color)
					end
				end
			end
		else
			self.targetingVOPlayed = false;
		end
	else
		self.targeting = false
		self.targetingActor = nil
		self.targetingAnimationProgress = 0
	end
	
	-- Targeting
	if self.parent then
		if self.targetingAwaitingSkillCheck then
			self.parent:SetNumberValue("SlowmoDuration", 0.1)
			if self.parent:NumberValueExists("DiceRollResult") then
				local result = self.parent:GetNumberValue("DiceRollResult")
				if result == 2 then
					self:Activate()
					self.parent:RemoveNumberValue("DiceRollResult")
					self.targetingAwaitingSkillCheck = false
					self.targetingSuccess = true
				elseif result == 1 then
					self:Activate()
					self.parent:RemoveNumberValue("DiceRollResult")
					self.targetingAwaitingSkillCheck = false
					self.targetingSuccess = false
				else
					self:Deactivate()
				end
			else
				self:Deactivate()
			end
		end
	end
	
	
	-- Prefire (delayed fire)
	--if (self.Magazine and self.Magazine.RoundCount > 0 and not self:IsReloading()) and self.preDelay > 0 then
	if (not self:IsReloading()) and self.preDelay > 0 then
		local active = self:IsActivated()
		--if (active or self.preFire) and (self.fireTimer:IsPastSimMS(60000/self.RateOfFire) or self.preFireTimer:IsPastSimMS(self.preDelay)) then
		if active or self.preFire then
			if not self.preFireActive then
				self.soundChamber:Play(self.Pos)
				self.soundChamber.Pitch = 0.5
				self.preFire = true
				self.preFireActive = true
			end
			
			if self.preFireTimer:IsPastSimMS(self.preDelay) then
				if self.FiredFrame then
					self.preFireFired = false
					self.preFire = false
				elseif not self.preFireFired then
					self:Activate()
					if not (self.Magazine and self.Magazine.RoundCount > 0) then
						self.preFireFired = false
						self.preFire = false
					end
				end
				
			else
				self:Deactivate()
			end
		else
			self.preFireActive = active
			self.preFireTimer:Reset()
		end
	end
	
	-- Frame animation
	
	if self.preFireActive then
		local factor = self.preFireTimer.ElapsedSimTimeMS / self.preDelay
		self.Frame = math.floor(4 * factor + 0.5)
	end
	
	if self:IsReloading() then
		-- Just in case!
		self.preFireFired = false
		self.preFire = false
	end
	
	if self.FiredFrame then
		self.recoil = 1
		self.rotation = self.rotation + 5
		
		self.accuracy = 0
		
		local VOPlayed = false;
		
		-- Kill
		if self.parent and self.targetingSuccess then
			local actor = MovableMan:FindObjectByUniqueID(self.targetingActor)
			if actor and IsAHuman(actor) then
				actor = ToAHuman(actor)
				
				actor.Status = 1
				actor.Vel = actor.Vel + Vector(10 * self.FlipFactor,0):RadRotate(self.RotAngle)
				actor.AngularVel = actor.AngularVel + RangeRand(-1, 1) * 5
				actor.Health = actor.Health - 50
				if math.random() < 0.25 then
					--if self.VOTriggerTimer:IsPastSimMS(self.VOTriggerDelay) and math.random(0, 100) < 90 then
					if math.random(0, 100) < 75 then
						VOPlayed = true;
						self.parent:SetNumberValue("Fired Headshot VO", 1);
						self.VOTriggerTimer:Reset();
					end
					--end
					if actor.Head then
						if math.random() < 0.5 then
							local head = actor.Head
							actor:RemoveAttachable(head, true, true)
							head.Vel = actor.Vel + Vector(10 * (math.random() - 0.5), -10)
						else
							actor.Head:GibThis()
						end
					end
				else
					local limbs = {actor.FGArm, actor.BGArm, actor.FGLeg, actor.BGLeg}
					local limbsShuffled = {}
					for i, v in ipairs(limbs) do
						local pos = math.random(1, #limbsShuffled + 1)
						table.insert(limbsShuffled, pos, v)
					end
					for i, limb in ipairs(limbsShuffled) do
						
						if limb and limb:GetParent() then
							limb:GibThis()
							break
						end
					end
					
					--if self.VOTriggerTimer:IsPastSimMS(self.VOTriggerDelay) and math.random(0, 100) < 45 then
					if math.random(0, 100) < 45 then
						VOPlayed = true;
						self.parent:SetNumberValue("Fired Hit VO", 1);
						self.VOTriggerTimer:Reset();
					end
				end
				
			end
		elseif self.parent and self.targetingActor then
			if self.VOTriggerTimer:IsPastSimMS(self.VOTriggerDelay) and math.random(0, 100) < 5 then
				VOPlayed = true;
				self.parent:SetNumberValue("Fired Missed VO", 1);
				self.VOTriggerTimer:Reset();
			end
		end
		
		if VOPlayed == false then
			if self.parent and self.VOTriggerTimer:IsPastSimMS(self.VOTriggerDelay) and math.random(0, 100) < 5 then
				self.parent:SetNumberValue("Fired VO", 1);
				self.VOTriggerTimer:Reset();
			end
		end
		
		self.targetingSuccess = false
		
		-- Smoke puff
		local maxi = math.floor(RangeRand(12, 24) + 0.5)
		for i = 1, maxi do
			local factor = (1 + (i / maxi)) * 0.5
			local spread = math.rad(RangeRand(-1, 1) * 15)
			local velocity = 60 * RangeRand(0.1, 0.9) * factor;
			
			local particle = CreateMOSParticle(math.random() < 0.5 and "Small Smoke Ball 1" or "Smoke Ball 1");
			particle.Pos = self.MuzzlePos
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread)
			particle.Lifetime = particle.Lifetime * RangeRand(0.9, 1.6) * 3
			particle.AirThreshold = particle.AirThreshold * 0.5 * (1 - factor)
			particle.GlobalAccScalar = 0
			particle.AirResistance = particle.AirResistance * 0.5 * RangeRand(0.9,1.1)
			MovableMan:AddParticle(particle);
		end
		
		-- Muzzle flash
		local spread = math.rad(40) + 0.1
		for i = 1, 3 do
			local flash = CreateMOPixel("Flash Muzzleloader", "Disco.rte");
			flash.Pos = self.MuzzlePos;
			flash.Vel = Vector(i * 7 * self.FlipFactor, 0):RadRotate(self.RotAngle + (math.random() * spread) - (spread/2));
			MovableMan:AddParticle(flash);
		end
		
		-- Lasting tiny flames
		for i = 1, math.ceil(RangeRand(8, 12)) do
			local spreadFactor = RangeRand(-1, 1)
			local spread = math.rad(spreadFactor * 5)
			local velocity = 25 * 0.6 * RangeRand(0.2,1.1) * (2 - math.abs(spreadFactor))
			
			local positionOffset = Vector(math.random() * self.FlipFactor, RangeRand(-2, 2)) * 2
			
			local particle = CreateMOSParticle("Muzzleloader Flame Smoke", "Disco.rte")
			particle.Pos = self.MuzzlePos + positionOffset
			particle.Vel = self.Vel + Vector(velocity * self.FlipFactor,0):RadRotate(self.RotAngle + spread)
			particle.Team = self.Team
			particle.Lifetime = particle.Lifetime * RangeRand(0.5,3.2)
			particle.AirResistance = particle.AirResistance * 1 * RangeRand(0.9,1.1)
			particle.IgnoresTeamHits = true
			particle.AirThreshold = particle.AirThreshold * 0.5
			MovableMan:AddParticle(particle);
		end
		
	end
	
	-- Animation
	if self.parent then
		self.recoil = math.max(self.recoil - 0.8 * TimerMan.DeltaTimeSecs, 0)
		self.accuracy = math.min(self.accuracy + 0.35 * TimerMan.DeltaTimeSecs, 1)
		if not self.targetingAwaitingSkillCheck and not self.preFireActive then
			self.accuracySway = self.accuracySway + 1.5 * TimerMan.DeltaTimeSecs / TimerMan.TimeScale
		end
		
		-- Recoil
		self.rotationTarget = self.rotationTarget + (self.recoil * self.recoil + math.sin(self.recoil * math.pi) * 0.5) * 20
		
		self.rotationTarget = self.rotationTarget + (1 - self.accuracy) * (math.sin(self.accuracySway * 2.0) + math.sin(self.accuracySway * 1.5 + 1) * 1.1 - math.cos(self.accuracySway * 4.15 - 0.5) * 0.6 + math.sin(self.accuracySway - 2.51) * 1.3) * 3
		
		-- Final rotation
		self.rotation = (self.rotation + self.rotationTarget * TimerMan.DeltaTimeSecs * self.rotationSpeed) / (1 + TimerMan.DeltaTimeSecs * self.rotationSpeed)
		local total = math.rad(self.rotation)
		
		self.InheritedRotAngleOffset = total
	end
end


function OnDetach(self)
	self.preFireFired = false
	self.preFire = false
	self.targetingAwaitingSkillCheck = false
end