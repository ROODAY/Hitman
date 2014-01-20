if SERVER then
	AddCSLuaFile( "shared.lua" )

end

if( CLIENT ) then
    SWEP.PrintName = "Cloaking Device";
    SWEP.Slot = 7;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
 
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Cloak yourself!"
   };
   
end

SWEP.Author= "SentientDEV"


SWEP.Base = "weapon_tttbase"
SWEP.Spawnable= false
SWEP.AdminSpawnable= true
SWEP.HoldType = "normal"

 
SWEP.Kind = WEAPON_EQUIP2
SWEP.InLoadoutFor = {ROLE_DETECTIVE}



SWEP.ViewModelFOV= 60
SWEP.ViewModelFlip= false
SWEP.ViewModel      = "models/weapons/v_slam.mdl"
SWEP.WorldModel      = ""

 --- PRIMARY FIRE ---
function SWEP:PrimaryAttack()
end
 
SWEP.AutoSpawnable = false
 
 
 --- SECONDARY FIRE ---
SWEP.Secondary.Delay= 0.1
SWEP.Secondary.Recoil= 0
SWEP.Secondary.Damage= 0
SWEP.Secondary.NumShots= 1
SWEP.Secondary.Cone= 0
SWEP.Secondary.ClipSize= -1
SWEP.Secondary.DefaultClip= -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo         = "none"
SWEP.AllowDrop = false

function SWEP:SecondaryAttack() // conceal yourself

if ( !self.conceal ) then
	self.Owner:SetColor( Color(255, 255, 255, 3) ) 			
	self.Owner:SetMaterial( "sprites/heatwave" )
	self.Weapon:SetMaterial("sprites/heatwave")
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Cloak On" )
	self.conceal = true
else
	self.Owner:SetMaterial("models/glass")
	self.Weapon:SetMaterial("models/glass")
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Cloak Off" )
	self.conceal = false
end
end

function SWEP:ShouldDropOnDie()
   return false
end

function SWEP:UnCloak()
    self.Owner:SetMaterial("models/glass")
    self.Weapon:SetMaterial("models/glass")
    self.Owner:PrintMessage( HUD_PRINTCENTER, "Cloak Off" )
    self.conceal = false
end
 
function SWEP:OnDrop()
   self:UnCloak()
   self:Remove()
end


hook.Add("TTTPrepareRound", "UnCloakAll",function()
    for k, v in pairs(player.GetAll()) do
        v:SetMaterial("models/glass")
    end
end
)