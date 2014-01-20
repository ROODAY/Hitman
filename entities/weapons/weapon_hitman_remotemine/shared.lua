    if SERVER then
       AddCSLuaFile( "shared.lua" )
       resource.AddFile("materials/SSR/icon_tripwire.png")
    end
     
    SWEP.HoldType                           = "slam"
     
    if CLIENT then
     
       SWEP.PrintName    = "Remote Mine"
       SWEP.Slot         = 6
     
       SWEP.ViewModelFlip = true
       SWEP.ViewModelFOV                    = 64
       
       SWEP.EquipMenuData = {
          type = "item_weapon",
          desc = [[A mine, which is triggered by remote, placeable on walls. 
          Can be shot and destroyed by innocents and detectives.]]
       };
     
       SWEP.Icon = "SSR/icon_tripwire.png"
    end
SWEP.Base = "weapon_tttbase"
     
    SWEP.ViewModel                          = "models/weapons/v_slam.mdl"   -- Weapon view model
    SWEP.WorldModel                         = "models/weapons/w_slam.mdl"   -- Weapon world model
    SWEP.FiresUnderwater = false
     
    SWEP.Primary.Sound                      = Sound("")             -- Script that calls the primary fire sound
    SWEP.Primary.Delay                      = .5                    -- This is in Rounds Per Minute
    SWEP.Primary.ClipSize                   = 2             -- Size of a clip
    SWEP.Primary.DefaultClip                = 2             -- Bullets you start with
    SWEP.Primary.Automatic                  = false         -- Automatic = true; Semi Auto = false
    SWEP.Primary.Ammo                       = "slam"
    SWEP.LimitedStock = true
    
    SWEP.NoSights = true
     
    SWEP.AllowDrop = true
    SWEP.Kind = WEAPON_EQUIP
    SWEP.CanBuy = {ROLE_TRAITOR}
    
    local mines = {}
     
    function SWEP:Deploy()
            self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
            return true
    end
     
    function SWEP:SecondaryAttack()
        if SERVER then
		    local ply = self.Owner
            if table.Count(mines) > 0 then
                self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
                for _,v in pairs(mines) do
                    if v:IsValid() then						
						local effectdata = EffectData()
						local pos = v:GetPos()
						effectdata:SetStart(pos)
	                    effectdata:SetOrigin(pos)
	                    effectdata:SetScale(1)
						sound.Play( "weapons/hegrenade/explode3.wav", pos, 100)
	                    util.Effect("HelicopterMegaBomb", effectdata, true, true)
                        util.BlastDamage(v, ply, pos, 256, 150)
						v:Remove()
                    end
                end
                mines = {}
            end
            
            if self.Weapon:Clip1() == 0 && table.Count(mines) == 0 then self:Remove() end
        end
        return true
    end
  
     
    function SWEP:OnRemove()
       if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
          RunConsoleCommand("lastinv")
       end
    end
     
function SWEP:PrimaryAttack()
    if self.Weapon:Clip1() == 0 then return end
    self:TripMineStick()
    self.Weapon:EmitSound( Sound( "Weapon_SLAM.SatchelThrow" ) )
    self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
end
     
function SWEP:TripMineStick()
 if SERVER then
    local ply = self.Owner
    if not IsValid(ply) then return end
 
 
    local ignore = {ply, self.Weapon}
    local spos = ply:GetShootPos()
    local epos = spos + ply:GetAimVector() * 80
    local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
 
    if tr.HitWorld then
        local mine = ents.Create("npc_satchel")
        if IsValid(mine) then
 
            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, mine)
 
            if tr_ent.HitWorld then
 
               local ang = tr_ent.HitNormal:Angle()
               ang.p = ang.p + 90
 
               mine:SetPos(tr_ent.HitPos + (tr_ent.HitNormal * 3))
               mine:SetAngles(ang)
               mine:SetOwner(ply)
               mine:Spawn()
               mine:GetPhysicsObject():EnableMotion(false)
 
                                mine.fingerprints = self.fingerprints
                                
                                table.insert(mines, mine)
                                
                                self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH )
                               
                                local holdup = self.Owner:GetViewModel():SequenceDuration()
                               
                                timer.Simple(holdup,
                                function()
                                if SERVER then
                                        self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH2 )
                                end    
                                end)
                                       
                                timer.Simple(holdup + .1,
                                function()
                                        if SERVER then
                                                if self.Owner == nil then return end
                                                if self.Weapon:Clip1() == 0 && self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 && #mines <= 0 then
                                                self:Remove()
                                                else
                                                self:Deploy()
                                                end
                                        end
                                end)

                                self.Planted = true
                                self:TakePrimaryAmmo( 1 )
                               
                        end
            end
         end
      end
end

function SWEP:Reload()
   return false
end