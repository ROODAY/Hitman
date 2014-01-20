if SERVER then
 
    AddCSLuaFile( "shared.lua" )
    SWEP.Weight             = 5
    SWEP.HoldType           = "pistol"
    SWEP.AutoSwitchTo       = false
    SWEP.AutoSwitchFrom     = false
 
 
end
 
if CLIENT then

    SWEP.DrawCrosshair      = false
    SWEP.ViewModelFOV       = 65
    SWEP.ViewModelFlip      = false
    SWEP.Slot               = 1
     
    SWEP.PrintName          = "Dual Elites"
    SWEP.Author             = "Teta_Bonita"
    SWEP.Contact            = ""
    SWEP.Purpose            = ""
    SWEP.Instructions       = "Aim away from face"
     
 
end
SWEP.Kind = WEAPON_PISTOL
SWEP.Spawnable          = true
SWEP.AutoSpawnable          = true
SWEP.AdminSpawnable     = true
SWEP.Base = "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel         = "models/weapons/w_pist_elite.mdl"
 
SWEP.Primary.Sound          = Sound( "Weapon_Elite.Single" )
SWEP.Primary.Damage         = 15
SWEP.Primary.NumShots       = 1
SWEP.Primary.Delay          = 0.12
SWEP.Primary.Cone           = 0.03
SWEP.Primary.Recoil         = 2
 
SWEP.Primary.ClipSize       = 20
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip    = 20
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
 
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
 
 
function SWEP:Initialize()
 
    if SERVER then
        self:SetWeaponHoldType( self.HoldType )
    end
     
    self.ShootRight = true
    self.LastShoot = 0
     
end
 
function SWEP:PrimaryAttack()
 
    self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
     
    if not self:CanPrimaryAttack() then return end
     
    self.Weapon:EmitSound( self.Primary.Sound )
    self:TakePrimaryAmmo( 1 )
     
    self:ShootBulletExample(
        self.Primary.Damage,
        self.Primary.Recoil,
        self.Primary.NumShots,
        self.Primary.Cone )
         
    self.LastShoot = CurTime()
     
end
 
 
function SWEP:SecondaryAttack()
 
end
 
 
function SWEP:Think()   
 
end
 
 
function SWEP:Reload()
 
    self.Weapon:DefaultReload( ACT_VM_RELOAD )
     
end
 
 
-- Sequence names
-- draw
-- idle
-- idle_leftempty
-- reload
-- shoot_left1
-- shoot_left2
-- shoot_leftlast
-- shoot_right1
-- shoot_right2
-- shoot_rightlast
 
-- Attachements
-- 1 = right muzzle
-- 2 = left muzzle
-- 3 = right shell eject
-- 4 = left shell eject
 
 
function SWEP:ShootBulletExample( dmg, recoil, numbul, cone )
 
    --send the bullet
    local bullet = {} 
    bullet.Num      = numbul 
    bullet.Src      = self.Owner:GetShootPos() 
    bullet.Dir      = self.Owner:GetAimVector()
    bullet.Spread   = Vector( cone, cone, 0 ) 
    bullet.Tracer   = 0  
    bullet.Force    = 3 
    bullet.Damage   = dmg  
     
    self.Owner:FireBullets( bullet )
     
    --play animations
    local sequence
    if self.ShootRight then
         
        if CurTime() - self.LastShoot > 0.3 then
            sequence = "shoot_right1"
        else
            sequence = "shoot_right2"
        end
     
        self.ShootRight = false
         
    else
     
        if CurTime() - self.LastShoot > 0.3 then
            sequence = "shoot_left1"
        else
            sequence = "shoot_left2"
        end
         
        self.ShootRight = true
         
    end
     
    local vm = self.Owner:GetViewModel()
    local attack = vm:LookupSequence( sequence )
    vm:ResetSequence( attack )  
     
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
 
    --apply recoil
    self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * recoil, math.Rand( -0.1, 0.1 ) * recoil, 0 ) )
 
end