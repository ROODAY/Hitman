

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_mp5.vmt")
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"


if CLIENT then

   SWEP.PrintName = "MP5 navy"			
   SWEP.Author = "Draks + Goupyl"
   SWEP.Slot      = 2
   SWEP.SlotPos		= 1
   SWEP.IconLetter			= "w"

   SWEP.Icon = "VGUI/ttt/icon_mp5"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_HEAVY

SWEP.Primary.Delay			= 0.13
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Damage = 17
SWEP.Primary.Cone = 0.028
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 15
SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")

SWEP.IronSightsPos = Vector(4.7659, -3.0823, 1.8818)
SWEP.IronSightsAng = Vector(0.9641, 0.0252, 0)




