function Create(self)
	self.updateTimer = Timer();

	self.healAmount = 2;
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
	if self.updateTimer:IsPastSimMS(1000) then
		self.updateTimer:Reset();
		self.aggressive = self.Health < self.MaxHealth * 0.5;
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
					else
						if math.random() < 0.5 then
							self.talkFrame = 6
						else
							self.talkFrame = 4
						end
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
			self.Head.Frame = 8
			self.Head.RotAngle = self.Head.RotAngle + 0.02 * math.sin(self.nodFactor)
			self.Head.Pos = self.Head.Pos + Vector(0, -math.sin(self.nodFactor) * 1.0)
			self.nodFactor = self.nodFactor + TimerMan.DeltaTimeSecs * 10
			
			ToArm(self.FGArm).IdleOffset = Vector(7, 3);
			ToArm(self.BGArm).IdleOffset = Vector(8, 10);
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