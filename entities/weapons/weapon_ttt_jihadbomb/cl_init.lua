
include('shared.lua')

SWEP.PrintName			= "Jihad Bomb"			
SWEP.Slot				= 8
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false


--Bewm
function SWEP:WorldBoom()
	
	surface.EmitSound( "siege/big_explosion.wav" )

end