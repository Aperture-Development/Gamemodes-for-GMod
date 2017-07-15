PlayModes = PlayModes or {}
PlayModes.Teams = PlayModes.Teams or {}
PlayModes.Teams.Builder = PlayModes.Teams.Builder or {}
PlayModes.Teams.Fighter = PlayModes.Teams.Fighter or {}
PlayModes.Teams.Spectator = PlayModes.Teams.Spectator or {}

hook.Add("PlayerSpawnProp","Modes_SpawnProp",function(ply,model)

	local HasPerm = PlayModes.HasPermission(ply,"spawn_prop")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnEffect","Modes_SpawnEffect",function(ply,model)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_effect")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnNPC","Modes_SpawnNPC",function(ply,npc_type)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_npc")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnObject","Modes_SpawnObject",function(ply,model)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_object")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnRagdoll","Modes_SpawnRagdoll",function(ply,model)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_ragdoll")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnSENT","Modes_SpawnSENT",function(ply,class)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_entity")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerSpawnSWEP","Modes_SpawnSWEP",function(ply,weapon)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_swep")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add("PlayerGiveSWEP","Modes_GiveSWEP",function(ply,weapon)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_swep")
	local bool_tool = nil

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	if PlayModes.Teams.Tools[weapon] then
		bool_tool = false
	end
	

	
	return bool_tool or HasPerm 
	
end)

hook.Add("PlayerSpawnVehicle","Modes_SpawnVehicles",function(ply,model)
	
	local HasPerm = PlayModes.HasPermission(ply,"spawn_vehicles")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end)

hook.Add( "PlayerNoClip", "Modes_Noclip", function( ply, desiredNoClipState )

	local HasPerm = PlayModes.HasPermission(ply,"use_noclip")

	if HasPerm==false then
		
		PlayModes.PM(ply,"I am sorry but your team has no permissions for that!")
		
	end
	
	return HasPerm
	
end )

hook.Add("PlayerShouldTakeDamage","Modes_TakeDamage",function(ply,attacker)
	
	local dmg_HasPerm = PlayModes.HasPermission(ply,"can_be_killed")
	local attacker_hasperms = PlayModes.HasPermission(ply,"can_kill")
	
	
	if attacker_hasperms==false and not (ply==attacker) then
	
		
		local gamemodes_violations = attacker:GetNWInt( "violations", 0)
		
		if gamemodes_violations<2 and not attacker:GetNWBool("got_warning",false) then
		
			attacker:SetNWInt( "violations", gamemodes_violations+1 )
			
			PlayModes.PM(attacker,"You tryed to violate the team permissions!")
			PlayModes.PM(attacker,"You got 1 Warning point. After 3 Points you will be set into 'Spectator'")
			PlayModes.PM(attacker,"Your current warning Points are:"..gamemodes_violations+1)
			
			attacker:SetNWBool( "got_warning", true )
			
			timer.Create( "violation_timer", 5, 1, function() attacker:SetNWBool( "got_warning", false ) end)
			
		elseif not attacker:GetNWBool("got_warning",false) then
			attacker:SetNWInt( "violations", 0 )
			PlayModes.PM(attacker,"You were set to 'Spectator' due to permission Violation!")
			PlayModes.SetTeam(attacker,"Spectator")
		end
		
	end
	
	return dmg_HasPerm
	
end)

hook.Add("PlayerInitialSpawn","Modes_InitSpawn",function(ply)
	
	timer.Simple(5,function()
		PlayModes.OpenMenu(ply)
		--PlayModes.SetTeam(ply,"Spectator")
	end)
	
end)

hook.Add("PlayerLoadout","Modes_ReSpawn",function(ply)

	local plyTeam = ply:GetNWString( "gamemode_team", "Null" )
	
	
	if plyTeam=="Null" then
		timer.Simple(5,function()
			PlayModes.SetTeam(ply,"Spectator")
		end)
	else
		PlayModes.TeamInit[plyTeam](ply)
	end
	
	return false
	
end)


hook.Add("Initialize","Modes_InitScript",function()
	
	PlayModes.LoadPerms()
	
	if ULib then
		ULib.ucl.registerAccess("modes_admin_gui","superadmin","Grants access to the Admin GUI of GMfG","Command")
	elseif evolve then
		table.Add( evolve.privileges, "modes_admin_gui" ) 
		table.sort( evolve.privileges )
	end

	
end)

hook.Add( "PlayerSay", "PlayerSayExample", function( ply, text, team )
	local str = string.Explode( " ", text )
	if table.HasValue(PlayModes.ChatCommands,str[1]) then 
		PlayModes.OpenMenu(ply)
	elseif table.HasValue(PlayModes.AdminChatCommands,str[1]) and PlayModes.CheckPermission(ply,"modes_admin_gui") then
		PlayModes.OpenAdminMenu(ply)
	end
end )
