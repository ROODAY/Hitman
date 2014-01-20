-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
 
if CLIENT then
   SWEP.PrintName = "Noctua Sucks"
   SWEP.Slot      = 6 -- add 1 to get the slot number key
   SWEP.Icon = "pack/icon_riot.png"
   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
end
 
-- Always derive from weapon_tttbase.
SWEP.Base                               = "weapon_tttbase"
 
--- Standard GMod values
 
SWEP.HoldType                   = "ar2"
 
SWEP.Primary.Delay       = 0.05
SWEP.Primary.Recoil      = 2.0
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 35
SWEP.Primary.Cone        = 0.05
SWEP.Primary.Ammo        ="smg1"
SWEP.Primary.ClipSize    = 200
SWEP.Primary.ClipMax     = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Sound       = Sound( "Weapon_Crowbar.Single" )
 
--SWEP.IronSightsPos = Vector (-0.5419, -3.3774, 1.5757)
--SWEP.IronSightsAng = Vector (0, 0, 0)
SWEP.IronSightsPos      = Vector( 5, -15, -2 )
SWEP.IronSightsAng      = Vector( 2.6, 1.37, 3.5 )
 
SWEP.ViewModel  = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

 
--- TTT config values
 
-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_EQUIP1
 
-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = false
 
-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
 
-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true
 
-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false
 
-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false
 
-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "pack/icon_sg552.png"
 
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Sexy ass SG552."
   };
end

function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
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
function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end
-- Tell the server that it should download our icon to clients.