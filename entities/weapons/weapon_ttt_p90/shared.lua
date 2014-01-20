---- P90 SWEP for TTT
---- Created by [LDT] FRAG

if SERVER then

   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_p90.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_p90.vmt" )
end

if CLIENT then
   SWEP.PrintName = "P90"
   SWEP.Slot      = 2

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   
   SWEP.Icon = "VGUI/ttt/icon_p90"
end

SWEP.Base				= "weapon_tttbase"
SWEP.HoldType			= "ar2"



SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil		= 1.2
SWEP.Primary.Sound		= Sound( "Weapon_P90.Single" )

SWEP.ViewModel			= "models/weapons/v_smg_p90.mdl"

SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"



SWEP.HeadshotMultiplier = 1.5 -- brain fizz, does exactly what it says :D

SWEP.IronSightsPos = Vector( 5, -3, 2.4 )

SWEP.IronSightsAng = Vector( 5, -3, 0 )


SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true

-- This will be done when FastDL is up, It's an updated effect system for a new P90 model

/*
SWEP.MuzzleEffect			= "rg_muzzle_rifle" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.EjectDelay			= 0
*/


//-----------------------------------------------------------
//Icon
//-----------------------------------------------------------

//I don't have an icon to add, leaving the default code here

//****FRAG - Remember to change this bit, you silly person!

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "VGUI/ttt/icon_p90"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = ""
   };
end

-- Tell the server that it should download our icon to clients.
if SERVER then
   -- It's important to give your icon a unique name. GMod does NOT check for
   -- file differences, it only looks at the name. This means that if you have
   -- an icon_ak47, and another server also has one, then players might see the
   -- other server's dumb icon. Avoid this by using a unique name.
   resource.AddFile("materials/VGUI/ttt/icon_p90.vmt")
end

