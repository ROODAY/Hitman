if (SERVER) then --the init.lua stuff goes in here
 
 
   AddCSLuaFile ("shared.lua");
 
 
   SWEP.Weight = 5;
   SWEP.AutoSwitchTo = false;
   SWEP.AutoSwitchFrom = false;
 
end
 
if (CLIENT) then --the cl_init.lua stuff goes in here
 
 
   SWEP.PrintName = "Lrn2Spel";
   SWEP.Slot = 8;
   SWEP.SlotPos = 0;
   SWEP.DrawAmmo = true;
   SWEP.DrawCrosshair = false;
 
end

SWEP.Base = "weapon_tttbase"
 
SWEP.Author = "Mr. Admin Sir";
SWEP.Contact = "tgngaming.info";
SWEP.Purpose = "Assists in throwing chairs";
SWEP.Instructions = "Left click to throw an office chair; right click to throw a wooden chair";
SWEP.Category = "Prop Launchers"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true;
 
SWEP.ViewModel				= "models/weapons/v_RPG.mdl"
SWEP.WorldModel				= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 3
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 3
SWEP.Secondary.DefaultClip = 3
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
 
local ShootSound = Sound("npc/assassin/ball_zap1.wav")

function SWEP:Reload()
end
 
function SWEP:Think()
end
 
/* Spawn and throw the specified model */
function SWEP:throw_attack (model_file)
	//Get an eye trace. This basically finds out where the shot hit
	//This SWEP makes very little use of the trace, except to calculate
	//the amount of force to apply to the object to throw it.
	local tr = self.Owner:GetEyeTrace();
 
	//We now make some shooting noises and effects using the sound we
	//loaded up earlier
	self:EmitSound (ShootSound);
	self.BaseClass.ShootEffects (self);
 
	//We now exit if this function is not running on the server
	if (!SERVER) then return end;
 
	//The next task is to create a physics entity based on the supplied model.
	local ent = ents.Create ("prop_physics");
	ent:SetModel (model_file);
 
	//Set the initial position of the object. This might need some fine tuning; but it
	//seems to work for the models I have tried
	ent:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector() * 16));
	ent:SetAngles (self.Owner:EyeAngles());
	ent:Spawn();
 
	//Now we need to get the physics object for our entity so we can apply a force to it
	local phys = ent:GetPhysicsObject();
 
	//Time to apply the force. My method for doing this was almost entirely empirical 
	//and it seems to work fairly intuitively with chairs.
	local shot_length = tr.HitPos:Length();
	phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() *  math.pow(shot_length, 3));
 
	//Now for the all important part of adding the spawned objects to the undo and cleanup data.
	cleanup.Add (self.Owner, "props", ent);
 
	undo.Create ("Thrown chair");
	undo.AddEntity (ent);
	undo.SetPlayer (self.Owner);
	undo.Finish();
end
 
//Throw an office chair on primary attack
function SWEP:PrimaryAttack()
if ( !self:CanPrimaryAttack() ) then return end
        //Call the throw attack function, with the office chair model
        self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        self:TakePrimaryAmmo(1)
        self:throw_attack("models/props/cs_office/Bookshelf1.mdl")
end
 
//Throw an office chair on primary attack
function SWEP:SecondaryAttack()
if ( !self:CanSecondaryAttack() ) then return end
        //Call the throw attack function, with the office chair model
        self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        self:TakePrimaryAmmo(1)
        self:throw_attack("models/props_c17/FurnitureChair001a.mdl")
end
/* Throw a discombobulator on secondary attack */
function SWEP:SecondaryAttack()
	return "ttt_confgrenade_proj"
end

SWEP.Kind = WEAPON_EQUIP1
 
SWEP.AutoSpawnable = false
 
SWEP.AllowDrop = true
 
SWEP.IsSilent = false
 
SWEP.NoSights = true
 
SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
 
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )