DiscoHarry = {}

function DiscoHarry.slowmoEnter(self)
	if self.slowmoOn then
		return
	end
	self.slowmoEnterSound:Play(self.Pos)
	self.slowmoOn = true
	
	self.slowmoLoop:Play(self.Pos);
	
	local slowdown = 7
	TimerMan.TimeScale = 1 / slowdown
	TimerMan.DeltaTimeSecs = self.slowmoSimSpeed / slowdown
end

function DiscoHarry.slowmoExit(self)
	if not self.slowmoOn then
		return
	end
	self.slowmoExitSound:Play(self.Pos)
	self.slowmoOn = false
	
	self.slowmoLoop:FadeOut(400);
	
	TimerMan.TimeScale = 1
	TimerMan.DeltaTimeSecs = self.slowmoSimSpeed
	
	--
end

function DiscoHarry.diceRollQueue(self, threshold)
	if self.skillCheckQueued then
		return false
	end
	
	self:SetNumberValue("DiceRollQueued", 1)
	
	self.skillCheckStartSound:Play(self.Pos)
	
	self.skillCheckThreshold = threshold
	self.skillCheckQueued = true
	return true
end

function DiscoHarry.diceRollQueued(self)
	local result = false
	self.skillCheckQueued = false
	
	self:RemoveNumberValue("DiceRollQueued")
	
	self.skillCheckDiceA = math.random(1, 6)
	self.skillCheckDiceB = math.random(1, 6)
	
	if self.skillCheckDiceA == 1 and self.skillCheckDiceB == 1 then
		result = false
	elseif self.skillCheckDiceA == 6 and self.skillCheckDiceB == 6 then
		result = true
	elseif self.skillCheckDiceA + self.skillCheckDiceB > self.skillCheckThreshold then
		result = true
	else
		result = false
	end
	
	if result then
		self.skillCheckSuccessSound:Play(self.Pos)
		self:SetNumberValue("DiceRollResult", 2)
		
		local flareName = "Harry Screen Flare Skill Check Success"
		if FrameMan.PlayerScreenWidth > 1920 or FrameMan.PlayerScreenHeight > 1080 then
			flareName = flareName .. " Big"
		end
		
		local flare = CreateMOPixel(flareName, "Disco.rte");
		flare.Pos = SceneMan:GetOffset(Activity.PLAYER_1) + Vector(FrameMan.PlayerScreenWidth * 0.5, FrameMan.PlayerScreenHeight * 0.5);
		MovableMan:AddParticle(flare);
	else
		self.skillCheckFailureSound:Play(self.Pos)
		self:SetNumberValue("DiceRollResult", 1)
		
		local flareName = "Harry Screen Flare Skill Check Failure"
		if FrameMan.PlayerScreenWidth > 1920 or FrameMan.PlayerScreenHeight > 1080 then
			flareName = flareName .. " Big"
		end
		
		local flare = CreateMOPixel(flareName, "Disco.rte");
		flare.Pos = SceneMan:GetOffset(Activity.PLAYER_1) + Vector(FrameMan.PlayerScreenWidth * 0.5, FrameMan.PlayerScreenHeight * 0.5);
		MovableMan:AddParticle(flare);
	end
	-- Set to 0 after used!
	
	self.skillCheckDisplayDuration = 2
	self.skillCheckDisplaySuccess = result
	
	return result
end

function DiscoHarry.diceRoll(self, threshold)
	local result = false
	
	local valueA = math.random(1, 6)
	local valueB = math.random(1, 6)
	
	if valueA == 1 and valueB == 1 then
		result = false
	elseif valueA == 6 and valueB == 6 then
		result = true
	elseif valueA + valueB > self.skillCheckThreshold then
		result = true
	else
		result = false
	end
	
	if result then
		self.skillCheckSuccessSound:Play(self.Pos)
	else
		self.skillCheckFailureSound:Play(self.Pos)
	end
	return result
end

function Create(self)
	self.skillCheckThreshold = threshold
	self.skillCheckQueued = false
	self.skillCheckDiceA = 0
	self.skillCheckDiceB = 0
	
	self.skillCheckDisplayDuration = 0
	self.skillCheckDisplaySuccess = false
	
	self.skillChanceDisplayDuration = 0
	self.skillChanceDisplayThreshold = 0
	
	self.skillCheckStartSound = CreateSoundContainer("Harry Skill Start", "Disco.rte")
	self.skillCheckSuccessSound = CreateSoundContainer("Harry Skill Success", "Disco.rte")
	self.skillCheckFailureSound = CreateSoundContainer("Harry Skill Failure", "Disco.rte")

	self.slowmoEnterSound = CreateSoundContainer("Harry Slowmo Enter", "Disco.rte")
	self.slowmoExitSound = CreateSoundContainer("Harry Slowmo Exit", "Disco.rte")
	self.slowmoLoop = CreateSoundContainer("Harry Slowmo Loop", "Disco.rte")
	
	self.fingerPistol9mmSound = CreateSoundContainer("Harry Finger Pistol 9mm", "Disco.rte")
	
	self.healthDamageSound = CreateSoundContainer("Harry Health Damage", "Disco.rte")
	self.healthCriticalSound = CreateSoundContainer("Harry Health Critical", "Disco.rte")
	self.healthRecoverSound = CreateSoundContainer("Harry Health Recover", "Disco.rte")
	self.finalDeathLoop = CreateSoundContainer("Harry Final Death Loop", "Disco.rte")
	
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

	self.timesDied = 0
	self.oldHealth = 100
	self.healAmount = 2;
	self.regenInitialDelay = 7000
	self.regenInitialTimer = Timer();
	self.regenDelay = 300;
	self.regenTimer = Timer();
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
	
	self.slowmoSimSpeed = 1 / 60
	self.slowmoOn = false
	self.slowmoDuration = 0
	
	self.spriteSkillChance = CreateMOSRotating("Harry Skill Chance", "Disco.rte")
	self.spriteSkillSuccess = CreateMOSRotating("Harry Skill Success", "Disco.rte")
	self.spriteSkillFailure = CreateMOSRotating("Harry Skill Failure", "Disco.rte")
	self.spriteDice = CreateMOSRotating("Harry Dice", "Disco.rte")
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
	
	if (not self.finalDeath) and self.Health < 1 and self.deathSequenceStarted ~= true then
		self.healthDamageSound:Play(self.Pos);
		self.healthCriticalSound:Play(self.Pos);
		DiscoHarry.slowmoEnter(self)
		self.slowmoDuration = 15000;
		self.deathSequenceStarted = true
		self.timesDied = self.timesDied + 1
		if player then
			self.voiceSound:Stop(-1);
			if not self.Head then
				self.finalDeath = true;
				self.voiceSound = self.voiceSounds.GibDeath
				self.voiceSound:Play(self.Pos);
				self.finalDeathLoop:Play(self.Pos);
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
		if not self.voiceSound:IsBeingPlayed() and not self.finalDeath then
			self.deathSaveRoll = true;
			DiscoHarry.diceRollQueue(self, 4 * math.max(1, self.timesDied))
		elseif not self.voiceSound:IsBeingPlayed() then
			self.healthCriticalSound:FadeOut(400);
			self.finalDeathLoop:FadeOut(400);
			self.Health = -1;
			self.Status = 4;
			DiscoHarry.slowmoExit(self)
			self.slowmoDuration = 0;
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
						self.healthDamageSound:Play(self.Pos);
						self.voiceSound = self.voiceSounds.PainStrong
						self.voiceSound:Play(self.Pos);
					elseif self.oldHealth - self.Health > 15 then
						self.healthDamageSound:Play(self.Pos);
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
		if self.controller:IsState(Controller.WEAPON_FIRE) or self.skillCheckQueued then-- or (self.Health > 99 or (self.Health > 47.313 and self.Health < 48.211)) then
			self.Head.Frame = self.Head.Frame - 4
		end
		
		if self.FGArm then
			ToArm(self.FGArm).IdleOffset = self.originalArmOffsetFG
		end
		if self.BGArm then
			ToArm(self.BGArm).IdleOffset = self.originalArmOffsetBG
		end
		
		local player = self:IsPlayerControlled()
		
		-- DICE ROLL
		if self:NumberValueExists("DiceRollThreshold") then
			DiscoHarry.diceRollQueue(self, self:GetNumberValue("DiceRollThreshold"))
			self:RemoveNumberValue("DiceRollThreshold")
		end
		
		if self.skillCheckQueued and not self.skillCheckStartSound:IsBeingPlayed() then
			DiscoHarry.diceRollQueued(self)
		end
		
		if self.deathSaveRoll and self:NumberValueExists("DiceRollResult") then
			self.deathSaveRoll = false;
			DiscoHarry.slowmoExit(self)
			self.slowmoDuration = 0;
			self.healthCriticalSound:FadeOut(400);
			self.finalDeathLoop:FadeOut(400);
			if self:GetNumberValue("DiceRollResult") == 2 then
				self.deathSequenceStarted = false;
				self.HUDVisible = true;
				self.Health = 35;
				self:RemoveWounds(4);
				self.controller.Disabled = false;
				self.Status = 0;
				if player then
					self.healthRecoverSound:Play(self.Pos);
					self.voiceSound = self.voiceSounds.Recover
					self.voiceSound:Play(self.Pos);
				end
			else
				self.finalDeath = true;
				self.deathSequenceStarted = false;
				self.Health = -100;
				self.Status = 4;
			end
			self:RemoveNumberValue("DiceRollResult");
		end
				
		--
		if self:NumberValueExists("SkillChanceThreshold") then
			self.skillChanceDisplayThreshold = self:GetNumberValue("SkillChanceThreshold")
			self:RemoveNumberValue("SkillChanceThreshold")
			self.skillChanceDisplayDuration = math.max(self.skillChanceDisplayDuration, 0.1)
		end
		if self:NumberValueExists("SkillChanceDuration") then
			local duration = self:GetNumberValue("SkillChanceDuration")
			self.skillChanceDisplayDuration = math.max(self.skillChanceDisplayDuration, duration)
			self:SetNumberValue("SkillChanceDuration", 0)
		end
		
		-- HUD
		if player then
			local origin = self.Pos + Vector(0, 50)
			
			-- Display skill check result
			if self.skillCheckStartSound:IsBeingPlayed() then
				for i = 1, 15 do
					local offsetA = Vector(40, 0):RadRotate(RangeRand(-1, 1) * math.rad(15)) * RangeRand(0.6, 1.1)
					local offsetB = Vector(-40, 0):RadRotate(RangeRand(-1, 1) * math.rad(15)) * RangeRand(0.6, 1.1)
					
					PrimitiveMan:DrawLinePrimitive(origin + offsetB, origin + offsetA, 222)
				end
			elseif self.skillCheckDisplayDuration > 0 then
				local randStr = math.pow(self.skillCheckDisplayDuration / 1.5, 3)
				local rand1 = Vector(RangeRand(-1, 1), RangeRand(-1, 1)) * randStr
				local rand2 = Vector(RangeRand(-1, 1), RangeRand(-1, 1)) * randStr
				local rand3 = Vector(RangeRand(-1, 1), RangeRand(-1, 1)) * randStr
				
				if self.skillCheckDisplaySuccess then
					PrimitiveMan:DrawBitmapPrimitive(origin + rand1, self.spriteSkillSuccess, 0, 0)
				else
					PrimitiveMan:DrawBitmapPrimitive(origin + rand1, self.spriteSkillFailure, 0, 0)
				end
				
				local originDice = origin + Vector(0, -20)
				local offset = Vector(-10, 0)
				PrimitiveMan:DrawBitmapPrimitive(originDice + offset + rand2, self.spriteDice, 0, self.skillCheckDiceA - 1)
				PrimitiveMan:DrawBitmapPrimitive(originDice - offset + rand3, self.spriteDice, 0, self.skillCheckDiceB - 1)
			else
				-- Display skill check chance
				if self.skillChanceDisplayDuration > 0 then
					local percent = math.floor(((1 - math.min(self.skillChanceDisplayThreshold, 12) / 12) * 0.94 + 0.03) * 100)
					local frame = 0
					
					local width = 1
					
					if percent < 4 then
						frame = 0
						width = width * 1.4
					elseif percent <= 20 then
						frame = 1
						width = width * 1.4
					elseif percent < 40 then
						frame = 2
					elseif percent <= 60 then
						frame = 3
					elseif percent <= 80 then
						frame = 4
					else
						frame = 5
						width = width * 1.4
					end
					
					--PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(-35 * width, -37), origin + Vector(35 * width, 10), 200)
					
					--PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(-35 * width, -33), origin + Vector(35 * width, -25), 87)
					
					--PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(-35 * width, -37), origin + Vector(-35 * width + 6, 10), 254)
					--PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(35 * width, -37), origin + Vector(35 * width - 6, 10), 254)
					
					PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(-35 * width, -15), origin + Vector(35 * width, 10), 200)
					
					PrimitiveMan:DrawBitmapPrimitive(origin + Vector(0, -5), self.spriteSkillChance, 0, frame)
					PrimitiveMan:DrawTextPrimitive(origin + Vector(0, 1), tostring(percent) .. "%", true, 1)
					
					PrimitiveMan:DrawBoxFillPrimitive(origin + Vector(-45, -23), origin + Vector(45, -15), 87)
					PrimitiveMan:DrawTextPrimitive(origin + Vector(0, -24), "HAND/EYE COORDINATION", true, 1)
				end
			end
		end
		
		self.skillCheckDisplayDuration = math.max(self.skillCheckDisplayDuration - TimerMan.DeltaTimeSecs / TimerMan.TimeScale, 0)
		self.skillChanceDisplayDuration = math.max(self.skillChanceDisplayDuration - TimerMan.DeltaTimeSecs / TimerMan.TimeScale, 0)
		
		-- EMOTIONS
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
		
		if (UInputMan:KeyHeld(14) and player) or (UInputMan:KeyHeld(8) and not player)
		or (self.EquippedItem and ToHeldDevice(self.EquippedItem):GetNumberValue("Song") == 2) or (self.EquippedBGItem and ToHeldDevice(self.EquippedBGItem):GetNumberValue("Song") == 2) then -- N or H
			if not self.fingerPistol9mmSoundPlayed and not self.EquippedItem then
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
		if (UInputMan:KeyHeld(13) and player) or (UInputMan:KeyHeld(10) and not player)
		or (self.EquippedItem and ToHeldDevice(self.EquippedItem):GetNumberValue("Song") == 1) or (self.EquippedBGItem and ToHeldDevice(self.EquippedBGItem):GetNumberValue("Song") == 1) then -- M or J
			self.Head.Frame = 9
			self.Head.RotAngle = self.Head.RotAngle - (0.05* self.FlipFactor)
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
	
	if (not self.deathSequenceStarted or self.finalDeath) and self.toHeal == true and self.regenInitialTimer:IsPastSimMS(self.regenInitialDelay) and not self.Healing then
		self.Healing = true;
		if not self.voiceSound:IsBeingPlayed() and self.Health < 30 and player then	
			self.voiceSound = self.voiceSounds.Recover
			self.voiceSound:Play(self.Pos);
		end
	end
	
	if self.Healing and (not self.deathSequenceStarted or self.finalDeath) then
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
	
	-- SLOWMO!
	if self:NumberValueExists("SlowmoDuration") then
		local duration = self:GetNumberValue("SlowmoDuration")
		self.slowmoDuration = math.max(self.slowmoDuration, duration)
		self:SetNumberValue("SlowmoDuration", 0)
	end
	
	if self.slowmoDuration > 0 then
		DiscoHarry.slowmoEnter(self)
		self.slowmoDuration = math.max(self.slowmoDuration - TimerMan.DeltaTimeSecs / TimerMan.TimeScale, 0)
	else
		DiscoHarry.slowmoExit(self)
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
	DiscoHarry.slowmoExit(self)
	
	self.slowmoLoop:FadeOut(400);
	self.finalDeathLoop:FadeOut(400);
end