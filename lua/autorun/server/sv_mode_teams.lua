PlayModes = PlayModes or {}
PlayModes.Teams = PlayModes.Teams or {}
PlayModes.TeamInit = PlayModes.TeamInit or {}
PlayModes.Teams.Builder = PlayModes.Teams.Builder or {}
PlayModes.Teams.Fighter = PlayModes.Teams.Fighter or {}
PlayModes.Teams.Spectator = PlayModes.Teams.Spectator or {}

PlayModes.Teams.Weapons = {
	"weapon_357",
	"weapon_ar2",
	"weapon_crossbow",
	"weapon_crowbar",
	"weapon_frag",
	"weapon_pistol",
	"weapon_rpg",
	"weapon_shotgun",
	"weapon_slam",
	"weapon_smg1",
	"weapon_stunstick",
	"weapon_fists"
}

PlayModes.Teams.Tools = {
	["gmod_tool"] = true,
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true
}

--[[
	Team Builder
]]
PlayModes.Teams.Builder.Perms = PlayModes.Teams.Builder.Perms or {
	
	"spawn_entity",
	"spawn_prop",
	"spawn_effect",
	"spawn_npc",
	"spawn_object",
	"spawn_ragdoll",
	"spawn_vehicles",
	"use_noclip"
	
}
function PlayModes.TeamInit.Builder(ply)
	
	ply:StripWeapons()
	ply:Give( "gmod_tool" )
	ply:Give( "weapon_physgun" )
	ply:Give( "weapon_physcannon" )
	
	ply:DrawShadow( true )
	ply:SetMaterial( "" )
	ply:SetRenderMode( RENDERMODE_NORMAL )
	ply:Fire( "alpha", 255, 0 )

end

--[[
	Team Fighter
]]
PlayModes.Teams.Fighter.Perms = PlayModes.Teams.Fighter.Perms or {
	
	"can_kill",
	"can_be_killed",
	"spawn_swep"
	
}
function PlayModes.TeamInit.Fighter(ply)
	
	ply:StripWeapons()
	
	for k,v in pairs(PlayModes.Teams.Weapons) do
		ply:Give( v )
	end
	
	ply:DrawShadow( true )
	ply:SetMaterial( "" )
	ply:SetRenderMode( RENDERMODE_NORMAL )
	ply:Fire( "alpha", 255, 0 )
	
end

--[[
	Team Spectator
]]
PlayModes.Teams.Spectator.Perms = PlayModes.Teams.Spectator.Perms or {
	
	"use_noclip"
	
}
function PlayModes.TeamInit.Spectator(ply)
	
	ply:ConCommand( "noclip 1" )
	ply:StripWeapons()
	
	ply:DrawShadow( false )
	ply:SetMaterial( "models/effects/vol_light001" )
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:Fire( "alpha", 10, 0 )
	
end

--[[
	All Permissions
]]
PlayModes.Teams.Perms = {
	"spawn_entity",
	"spawn_prop",
	"spawn_effect",
	"spawn_npc",
	"spawn_object",
	"spawn_ragdoll",
	"spawn_swep",
	"spawn_vehicles",
	"can_kill",
	"can_be_killed",
	"use_noclip"
}