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

local songlist = {
};

local Music

function ENT:Initialize()
   self:SetModel(self.Model)
   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_NONE)
   self:SetupSongTable()
   song = songlist[math.random(1, #songlist)]
   if SERVER then
	self:SetMaxHealth(40)
   end
   self:SetHealth(40)
	
   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end
   if CLIENT then
	self:StartSong(song)
   end
   self.fingerprints = {}
  
end

function ENT:SetupSongTable()
	table.insert(songlist, "http://66.150.214.164/music/beachboysshred.mp3")
	table.insert(songlist, "http://66.150.214.164/music/bobsaget.mp3")
	table.insert(songlist, "http://66.150.214.164/music/canyoufeelthesunshine.mp3")
	table.insert(songlist, "http://66.150.214.164/music/damnfiddle.mp3")
	table.insert(songlist, "http://66.150.214.164/music/fortyyearsofgaming.mp3")
	table.insert(songlist, "http://66.150.214.164/music/hello.mp3")
	table.insert(songlist, "http://66.150.214.164/music/heyyaaaaheyyaaaah.mp3")
	table.insert(songlist, "http://66.150.214.164/music/hiimdaisy.mp3")
	table.insert(songlist, "http://66.150.214.164/music/letsgoaway.mp3")
	table.insert(songlist, "http://66.150.214.164/music/liketoygorrillas.mp3")
	table.insert(songlist, "http://66.150.214.164/music/livinginthecity.mp3")
	table.insert(songlist, "http://66.150.214.164/music/lolrap.mp3")
	table.insert(songlist, "http://66.150.214.164/music/lookatdis.mp3")
	table.insert(songlist, "http://66.150.214.164/music/okayokayokay.mp3")
	table.insert(songlist, "http://66.150.214.164/music/paydaytwonightclub.mp3")
	table.insert(songlist, "http://66.150.214.164/music/hotpiss.mp3")
	table.insert(songlist, "http://66.150.214.164/music/pikminpark.mp3")
	table.insert(songlist, "http://66.150.214.164/music/rollingstart.mp3")
	table.insert(songlist, "http://66.150.214.164/music/sanicweedhog.mp3")
	table.insert(songlist, "http://66.150.214.164/music/sickashellsonicmashup.mp3")
	table.insert(songlist, "http://66.150.214.164/music/slapchop.mp3")
	table.insert(songlist, "http://66.150.214.164/music/sonicboomrap.mp3")
	table.insert(songlist, "http://66.150.214.164/music/sonicunderground.mp3")
	table.insert(songlist, "http://66.150.214.164/music/sonicrap.mp3")
	table.insert(songlist, "http://66.150.214.164/music/supersonicracing.mp3")
	table.insert(songlist, "http://66.150.214.164/music/tinytim.mp3")
	table.insert(songlist, "http://66.150.214.164/music/tttrap.mp3")
	table.insert(songlist, "http://66.150.214.164/music/whodoyouvoodoo.mp3")
	table.insert(songlist, "http://66.150.214.164/music/waittillyouseemydick.mp3")
	table.insert(songlist, "http://66.150.214.164/music/dontevensmokecrack.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/goro.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/johnnycage.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/liukang.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/rayden.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/scorpion.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/sonya.mp3")
	table.insert(songlist, "http://66.150.214.164/music/mortalkombat/subzero.mp3")
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
self:StopSong()
end



function ENT:StartSong(dasong)
MsgAll(dasong)
if CLIENT then
	sound.PlayURL ( dasong, "play", function( station )
		Music = station
	end )
end
end

function ENT:StopSong()
	if CLIENT then
		if Music:IsValid() then
			Music:Stop()
		end
	end
end