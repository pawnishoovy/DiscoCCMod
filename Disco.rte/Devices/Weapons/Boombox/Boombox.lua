
function Create(self)

	self.onFirstSound = CreateSoundContainer("Disco Boombox On First", "Disco.rte");
	self.onSound = CreateSoundContainer("Disco Boombox On", "Disco.rte");
	
	self.wantToBeFree = CreateSoundContainer("Disco Boombox Want To Be Free", "Disco.rte");
	self.wantToBeFreeEcho = CreateSoundContainer("Disco Boombox Want To Be Free Echo", "Disco.rte");
	
	self.Rave = CreateSoundContainer("Disco Boombox Rave", "Disco.rte");
	self.raveEcho = CreateSoundContainer("Disco Boombox Rave Echo", "Disco.rte");
	
	self.Secret = CreateSoundContainer("Disco Boombox Secret", "Disco.rte");
	self.secretEcho = CreateSoundContainer("Disco Boombox Secret Echo", "Disco.rte");

end

function Update(self)

	if self:GetRootParent().UniqueID ~= self.UniqueID then
		self.parent = ToAHuman(self:GetRootParent())
	else
		self.parent = nil;
	end
	
	if self.checkIfDropped then
		self.checkIfDropped = false;
		if not self.parent then
			self.turnedOn = false;
			
			self:RemoveNumberValue("Song")

			self.onFirstSound:Stop(-1);
			self.onSound:Stop(-1);
			self.wantToBeFree:Stop(-1);
			self.wantToBeFreeEcho:Stop(-1);
			self.Rave:Stop(-1);
			self.raveEcho:Stop(-1);
			self.Secret:Stop(-1);
			self.secretEcho:Stop(-1);
		end
	end
	
	self.onFirstSound.Pos = self.Pos;
	self.onSound.Pos = self.Pos;
	self.wantToBeFree.Pos = self.Pos;
	self.wantToBeFreeEcho.Pos = self.Pos;
	self.Rave.Pos = self.Pos;
	self.raveEcho.Pos = self.Pos;
	self.Secret.Pos = self.Pos;
	self.secretEcho.Pos = self.Pos;
	
	self.wantToBeFree.Volume = TimerMan.TimeScale;
	self.Rave.Volume = TimerMan.TimeScale;
	self.Secret.Volume = TimerMan.TimeScale;
	
	self.wantToBeFreeEcho.Volume = 0.2 + (1 - (TimerMan.TimeScale));
	self.raveEcho.Volume = 0.2 + (1 - (TimerMan.TimeScale));
	self.secretEcho.Volume = 0.2 + (1 - (TimerMan.TimeScale));
	
	if self.turnedOn and not (self.wantToBeFreeEcho:IsBeingPlayed() or self.raveEcho:IsBeingPlayed() or self.secretEcho:IsBeingPlayed()) then
		self:SetValueExists("Switch", 1)
	end

	if self:NumberValueExists("Switch") then
		self:RemoveNumberValue("Switch")
		if not self.turnedOn then
			self.turnedOn = true
			self.onFirstSound:Play(self.Pos);
			self.wantToBeFree:Play(self.Pos);
			self.wantToBeFreeEcho:Play(self.Pos);
			
			self.currentSong = 1;
			self:SetNumberValue("Song", self.currentSong);
		elseif self.currentSong ~= 3 and math.random(0, 100) < 2 then
			self.onSound:Play(self.Pos);
			
			self.wantToBeFree:Stop(-1);
			self.wantToBeFreeEcho:Stop(-1);
			self.Rave:Stop(-1);
			self.raveEcho:Stop(-1);				
			
			self.Secret:Play(self.Pos);
			self.secretEcho:Play(self.Pos);
			
			self.currentSong = 3;
			self:SetNumberValue("Song", self.currentSong);
		elseif self.currentSong == 1 then
			self.onSound:Play(self.Pos);
			
			self.wantToBeFree:Stop(-1);
			self.wantToBeFreeEcho:Stop(-1);			
			
			self.Rave:Play(self.Pos);
			self.raveEcho:Play(self.Pos);
			
			self.currentSong = 2;
			self:SetNumberValue("Song", self.currentSong);
		elseif self.currentSong == 2 or self.currentSong == 3 then
			self.onSound:Play(self.Pos);
			
			self.Rave:Stop(-1);
			self.raveEcho:Stop(-1);	
			self.Secret:Stop(-1);
			self.secretEcho:Stop(-1);	

			
			self.wantToBeFree:Play(self.Pos);
			self.wantToBeFreeEcho:Play(self.Pos);
			
			self.currentSong = 1;
			self:SetNumberValue("Song", self.currentSong);
		end
	end

end 

function Destroy(self)

	self.onFirstSound:Stop(-1);
	self.onSound:Stop(-1);
	self.wantToBeFree:Stop(-1);
	self.wantToBeFreeEcho:Stop(-1);
	self.Rave:Stop(-1);
	self.raveEcho:Stop(-1);
	self.Secret:Stop(-1);
	self.secretEcho:Stop(-1);
	
end

function OnDetach(self, mo)

	if IsArm(mo) then
		-- set a flag to check on Update whether we're attached to an actor still, indicating we just switched hands
		-- checking rootparent here will return self
		self.checkIfDropped = true;
	else

		self.turnedOn = false;
		
		self:RemoveNumberValue("Song")

		self.onFirstSound:Stop(-1);
		self.onSound:Stop(-1);
		self.wantToBeFree:Stop(-1);
		self.wantToBeFreeEcho:Stop(-1);
		self.Rave:Stop(-1);
		self.raveEcho:Stop(-1);
		self.Secret:Stop(-1);
		self.secretEcho:Stop(-1);
		
	end
	
end