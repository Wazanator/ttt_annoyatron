---- Annoy A tron, it plays really loud annoying music

AddCSLuaFile()

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "vgui/ttt/icon_radio"
   ENT.PrintName = "annoy-A-Tron"
end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/radio.mdl")

ENT.CanUseKey = true
ENT.CanHavePrints = false
ENT.SoundLimit = 5
ENT.SoundDelay = 0.5



function ENT:Initialize()
   self:SetModel(self.Model)
   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_NONE)
   if SERVER then
      self:SetMaxHealth(40)
   end
   self:SetHealth(40)
   -- Check to make sure the song list exists
	CheckSongTxt()
	-- Populate our song table
	FillSongTable()
   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   if SERVER then
	self:StartSong()
   end
   self.fingerprints = {}
  
end

function CheckSongTxt()
	-- Setup Default contents
	local contents = [[
music/hl1_song25_remix3.mp3]]
	--Check if the ttt directory exists
	if file.IsDir("tt", "DATA") != true then
		file.CreateDir("ttt")
	end
	--Check if the file exists
	if file.Read("ttt/annoyatrongsongs.txt") == nil then
		file.Write("ttt/annoyatrongsongs.txt", contents)
	end
end

function ENT:UseOverride(activator)
   if IsValid(activator) and activator:IsPlayer() and activator:IsActiveTraitor() then
      local prints = self.fingerprints or {}
      self:Remove()

      local wep = activator:Give("weapon_ttt_annoyatron")
      if IsValid(wep) then
         wep.fingerprints = wep.fingerprints or {}
         table.Add(wep.fingerprints, prints) 
      end
   end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   if self:Health() < 0 then
      self:Remove()
		
      local effect = EffectData()
      effect:SetOrigin(self:GetPos())
      util.Effect("cball_explode", effect)
      sound.Play(zapsound, self:GetPos())

      if IsValid(self:GetOwner()) then
         LANG.Msg(self:GetOwner(), "radio_broken")
      end
   end
end

function ENT:OnRemove()
self:StopSong(true)
end

local songlist = {
};

function FillSongTable()
	local songFile = file.Read("ttt/annoyatrongsongs.txt")
	local songTableTemp = string.Explode("\n", songFile)
	for k, v in pairs(songTableTemp) do
		table.insert(songlist, k, Sound(v))
	end
end

function ENT:StartSong()
   if not self.Song then
	self.Song = CreateSound(self, table.Random(songlist))
	self.Song:SetSoundLevel(0)
   end

   if not self.Song:IsPlaying() then
      self.Song:PlayEx(1, 100)
	  self.Song:SetSoundLevel(0)
   end
end

function ENT:StopSong(force)
   if self.Song and self.Song:IsPlaying() then
      self.Song:FadeOut(0.5)
   end

   if self.Song and force then
      self.Song:Stop()
   end
end
