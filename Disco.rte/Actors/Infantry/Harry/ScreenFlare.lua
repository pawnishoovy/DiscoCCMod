function Create(self)

end
function Update(self)
	self.Pos = SceneMan:GetOffset(Activity.PLAYER_1) + Vector(FrameMan.PlayerScreenWidth * 0.5, FrameMan.PlayerScreenHeight * 0.5);
end