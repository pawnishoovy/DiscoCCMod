function Create(self)

	self.fingerPistol9mmSound = CreateSoundContainer("Harry Finger Pistol 9mm", "Disco.rte")

	self.voiceSounds = {
	Death = CreateSoundContainer("Harry VO Death", "Disco.rte"),
	GibDeath = CreateSoundContainer("Harry VO GibDeath", "Disco.rte"),
	PainLight = CreateSoundContainer("Harry VO PainLight", "Disco.rte"),
	PainMedium = CreateSoundContainer("Harry VO PainMedium", "Disco.rte"),
	PainStrong = CreateSoundContainer("Harry VO PainStrong", "Disco.rte"),
	Recover = CreateSoundContainer("Harry VO Recover", "Disco.rte"),
	Spot = CreateSoundContainer("Harry VO Spot", "Disco.rte")};
	
	self.voiceSound = CreateSoundContainer("Harry VO Spot", "Disco.rte") -- placeholder

	self.updateTimer = Timer();

	self.spotDelay = 300;
	self.spotTimer = Timer();
	self.spotLoseDelay = 7000;
	self.spotLoseTimer = Timer();

	self.oldHealth = 100
	self.healAmount = 2;
	self.regenInitialDelay = 7000
	self.regenInitialTimer = Timer();
	self.regenDelay = 300;
	self.regenTimer = Timer();
	
	self.blinkTimer = Timer()
	self.blinkResetTime = 5000
	
	self.talkFrame = 0
	self.talkTimer = Timer()
	self.talkResetTime = 150
	
	self.lastWoundCount = self.WoundCount;
	self.lastHealth = self.Health;
	
	self.originalArmOffsetFG = ToArm(self.FGArm).IdleOffset
	self.originalArmOffsetBG = ToArm(self.BGArm).IdleOffset
	
	self.nodFactor = 0
end
function Update(self)

	if UInputMan:KeyPressed(46) then
		self:ReloadScripts();
	end

	local player = self:IsPlayerControlled();
	
	if self.voiceSound:IsBeingPlayed() and not player then
		self.voiceSound:Stop(-1);
	end
	
	-- DEATH LOGIC
	
	if self.Health < 1 and self.deathSequenceStarted ~= true then
		self.deathSequenceStarted = true
		if player then
			TimerMan.TimeScale = 0.2
			self.voiceSound:Stop(-1);
			if not self.Head then
				self.voiceSound = self.voiceSounds.GibDeath
				self.voiceSound:Play(self.Pos);
			else
				self.voiceSound = self.voiceSounds.Death
				self.voiceSound:Play(self.Pos);
			end

		end
	end
	
	if self.deathSequenceStarted then
		self.HUDVisible = false;
		self.Health = 1;
		self.Status = 1;
		if not player then
			self.voiceSound:Stop(-1);
		end
		if not self.voiceSound:IsBeingPlayed() then
			TimerMan.TimeScale = 1
			self.Health = -100;
			self.Status = 4;
		end
	end
	
	-- HEALTH AND PAIN LOGIC
	
	if self.updateTimer:IsPastSimMS(500) or self.Health < self.oldHealth then
		self.updateTimer:Reset();
		self.aggressive = self.Health < self.MaxHealth * 0.5;
		if self.Health < self.oldHealth then
			self.regenInitialTimer:Reset();
			self.Healing = false;
			if player and math.random(0, 100) < 40 and self.Health > 0 then
				if not self.voiceSound:IsBeingPlayed() then
					if self.oldHealth - self.Health > 40 then
						self.voiceSound = self.voiceSounds.PainStrong
						self.voiceSound:Play(self.Pos);
					elseif self.oldHealth - self.Health > 15 then
						self.voiceSound = self.voiceSounds.PainMedium
						self.voiceSound:Play(self.Pos);
					elseif  self.oldHealth - self.Health > 5 then
						self.voiceSound = self.voiceSounds.PainLight
						self.voiceSound:Play(self.Pos);
					end
				end
			end
		end
		self.oldHealth = self.Health;
	end
	
	self.controller = self:GetController()
	if not self.controller then return end
	
	--[[
	if self.Head then
		self.Head.Frame = math.floor((7 - math.min(self.blinkTimer.ElapsedSimTimeMS / 300, 1) * 3) + 0.55)--3
		if self.controller:IsState(Controller.WEAPON_FIRE) or self.aggressive then
			self.Head.Frame = self.Head.Frame - 4
		end
	end]]
	
	if self.Head then
		self.Head.Frame = math.floor((7 - math.min(self.blinkTimer.ElapsedSimTimeMS / 300, 1) * 3) + 0.55)
		if self.controller:IsState(Controller.WEAPON_FIRE) then-- or (self.Health > 99 or (self.Health > 47.313 and self.Health < 48.211)) then
			self.Head.Frame = self.Head.Frame - 4
		end
		
		
		ToArm(self.FGArm).IdleOffset = self.originalArmOffsetFG
		ToArm(self.BGArm).IdleOffset = self.originalArmOffsetBG
		
		local player = self:IsPlayerControlled()
		if (UInputMan:KeyHeld(6) and player) or (UInputMan:KeyHeld(7) and not player) then -- F or G
			
			if self.talkTimer:IsPastSimMS(self.talkResetTime) then
				if math.random() < 0.7 then
					
					if math.random() < 0.3 then
						if math.random() < 0.5 then
							self.talkFrame = 2
						else
							self.talkFrame = 0
						end
					elseif math.random() < 0.5 then
						if math.random() < 0.5 then
							self.talkFrame = 6
						else
							self.talkFrame = 4
						end
					else
						self.talkFrame = 9
					end
					
				end
				self.talkTimer:Reset()
			end
			
			self.Head.Frame = self.talkFrame
			
			self.Head.RotAngle = self.Head.RotAngle + 0.02
			self.nodFactor = self.nodFactor + TimerMan.DeltaTimeSecs * 10
			
			if self.talkFrame == 0 or self.talkFrame == 2 then
				ToArm(self.FGArm).IdleOffset = Vector(7, 3);
				ToArm(self.BGArm).IdleOffset = Vector(8, 5);
			elseif self.talkFrame == 4 or self.talkFrame == 6 then
				ToArm(self.FGArm).IdleOffset = Vector(6, 3);
				ToArm(self.BGArm).IdleOffset = Vector(10, -1);
			elseif self.talkFrame == 9 then
				ToArm(self.FGArm).IdleOffset = Vector(9, -3);
				ToArm(self.BGArm).IdleOffset = Vector(7, 5);
			end
		end
		
		if (UInputMan:KeyHeld(14) and player) or (UInputMan:KeyHeld(8) and not player) then -- N or H
			if not self.fingerPistol9mmSoundPlayed then
				self.fingerPistol9mmSoundPlayed = true;
				self.fingerPistol9mmSound:Play(self.Pos);
			end
			self.Head.Frame = 8
			self.Head.RotAngle = self.Head.RotAngle + 0.02 * math.sin(self.nodFactor)
			self.Head.Pos = self.Head.Pos + Vector(0, -math.sin(self.nodFactor) * 1.0)
			self.nodFactor = self.nodFactor + TimerMan.DeltaTimeSecs * 10
			
			ToArm(self.FGArm).IdleOffset = Vector(7, 3);
			ToArm(self.BGArm).IdleOffset = Vector(8, 6);
		else
			self.fingerPistol9mmSoundPlayed = false;
		end
		if (UInputMan:KeyHeld(13) and player) or (UInputMan:KeyHeld(10) and not player) then -- M or J
			self.Head.Frame = 9
			self.Head.RotAngle = self.Head.RotAngle - 0.05
			self.nodFactor = self.nodFactor + TimerMan.DeltaTimeSecs * 10
			
			ToArm(self.FGArm).IdleOffset = Vector(6, 12);
			ToArm(self.BGArm).IdleOffset = Vector(3, 12);
		end
		
		
		if self.Health < 1 then
			self.Head.Frame = 6
		end
	end
	
	if self.blinkTimer:IsPastSimMS(self.blinkResetTime) then
		self.blinkResetTime = math.random(1000,6000)
		self.blinkTimer:Reset()
	end
	
	-- REGEN LOGIC
	
	if self.Health < 80 then
		self.toHeal = true;
	else
		self.toHeal = false;
		self.Healing = false;
	end
	
	if not self.deathSequenceStarted and self.toHeal == true and self.regenInitialTimer:IsPastSimMS(self.regenInitialDelay) and not self.Healing then
		self.Healing = true;
		if not self.voiceSound:IsBeingPlayed() and self.Health < 30 and player then	
			self.voiceSound = self.voiceSounds.Recover
			self.voiceSound:Play(self.Pos);
		end
	end
	
	if self.Healing and not self.deathSequenceStarted then
		if self.regenTimer:IsPastSimMS(self.regenDelay) then
			self.regenTimer:Reset();
			if self.Health > 0 then
				if self.Health < 100 then
					self:AddHealth(self.healAmount);
				end
				
				local damageRatio = (self.WoundCount - self.lastWoundCount) / self:GetGibWoundLimit(true, false, false) + (self.lastHealth - self.Health)/self.MaxHealth;
				if damageRatio > 0 then
					self.regenDelay = self.regenDelay * (1 + damageRatio);
				else
					local healed = self:RemoveWounds(1);
					if healed ~= 0 and self.Health < self.MaxHealth then
						if self.Health > self.MaxHealth	then
							self.Health = self.MaxHealth;
						end
					end
				end
			end
			self.lastWoundCount = self.WoundCount;
			self.lastHealth = self.Health;
		end
	end
	
	-- SPOTTING TARGET LOGIC!!
	if player then
		if self.spotTimer:IsPastSimMS(self.spotDelay) then
			self.spotTimer:Reset();
			local viewAngDeg = RangeRand(50, 120)
			local FoundMO = self:LookForMOs(viewAngDeg, rte.grassID, false)
			if FoundMO and IsActor(FoundMO) then
				FoundMO = ToActor(FoundMO)
				if self.Team ~= FoundMO.Team and FoundMO.Status < 2 then	
					self.spotLoseTimer:Reset();
					if self.spotTarget == nil then
						self.spotTarget = FoundMO
						if not self.voiceSound:IsBeingPlayed() then
							self.voiceSound = self.voiceSounds.Spot
							self.voiceSound:Play(self.Pos);
						end
					end
				end
			elseif self.spotLoseTimer:IsPastSimMS(self.spotLoseDelay) then
				self.spotTarget = nil;
			end
			
		end
	else
		self.spotTarget = nil
	end
	
end

function OnDestroy(self)
	self.voiceSound:Stop(-1)
	TimerMan.TimeScale = 1
end