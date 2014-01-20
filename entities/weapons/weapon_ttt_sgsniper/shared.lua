if (SERVER) then
 
        AddCSLuaFile( "shared.lua" )
       
end
 
SWEP.HoldType                   = "ar2"
 
 
if (CLIENT) then
 
        SWEP.PrintName                  = "SIG SG 550"  
        SWEP.Slot                       = 2      
        SWEP.Icon = "VGUI/ttt/icon_sg550"    
end
 
SWEP.Base                               = "weapon_tttbase"
SWEP.Spawnable                          = true
SWEP.AdminSpawnable                     = true
 
SWEP.ViewModel                          = "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel                         = "models/weapons/w_snip_sg550.mdl"
 
SWEP.Kind = WEAPON_HEAVY
 
SWEP.AutoSwitchTo                       = false
SWEP.AutoSwitchFrom                     = false
SWEP.AutoSpawnable      = true
SWEP.Primary.Sound                      = Sound( "Weapon_sg550.Single" )
SWEP.Primary.Recoil                     = 0.5
SWEP.Primary.Damage                     = 20
SWEP.Primary.NumShots           = 1
SWEP.Primary.Cone                       = 0.0001 --starting cone, it WILL increase to something higher, so keep it low
SWEP.Primary.ClipSize           = 30
SWEP.Primary.Delay                      = 0.25
SWEP.Primary.DefaultClip        = 30
SWEP.Primary.ClipMax            = 90
SWEP.Primary.Automatic          = true
SWEP.Primary.Ammo                       = "smg1"
SWEP.MoveSpread                         = 8 --multiplier for spread when you are moving
SWEP.JumpSpread                         = 15 --multiplier for spread when you are jumping
SWEP.CrouchSpread                       = 0.5 --multiplier for spread when you are crouching
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
 
 
function SWEP:SetZoom(state)
    if CLIENT then
       return
    else
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end
 
-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
   
    bIronsights = not self:GetIronsights()
   
    self:SetIronsights( bIronsights )
   
    if SERVER then
        self:SetZoom(bIronsights)
     else
       
    end
   
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end
 
function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end
 
function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end
 
 
function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end
 
if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()
 
         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
 
         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
 
 
         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
 
         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)
 
         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)
 
         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
 
      else
         return self.BaseClass.DrawHUD(self)
      end
   end
 
   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end
 
 
 
 
 
 
SWEP.Primary.MaxSpread          = 0.15 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle                     = 0.5 --how many seconds you have to wait between each shot before the spread is at its best
SWEP.Primary.SpreadIncrease     = 0.21/15 --how much you add to the cone after each shot
 
SWEP.IncreasesSpread            = true --unlike the AWP, this does increase spread, thus we need to declare this variable
SWEP.Primary.MaxSpread          = 0.10 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle                     = 0.6
SWEP.Primary.SpreadIncrease = 0.2/15
 
SWEP.Zoom0Cone                          = 0.1 --spread for when not zoomed
SWEP.Zoom1Cone                          = 0.01 --spread for when zoomed once
SWEP.Zoom2Cone                          = 0.01 --spread for when zoomed twice
 
SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = true
SWEP.Secondary.Ammo                     = "none"
 
SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )