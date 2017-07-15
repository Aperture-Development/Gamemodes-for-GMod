include("sv_mode_teams.lua")
PlayModes = PlayModes or {}
PlayModes.Teams = PlayModes.Teams or {}
PlayModes.Teams.Builder = PlayModes.Teams.Builder or {}
PlayModes.Teams.Fighter = PlayModes.Teams.Fighter or {}
PlayModes.Teams.Spectator = PlayModes.Teams.Spectator or {}
PlayModes.ChatCommands = {
	"/gamemodes",
	"!gamemodes",
	"/modes",
	"!modes"
}

PlayModes.AdminChatCommands = {
	"/modesadmin",
	"!modesadmin"
}

util.AddNetworkString("playmodes_message")
util.AddNetworkString("playmodes_openmenu")
util.AddNetworkString("playmodes_openadminmenu")
util.AddNetworkString("playmodes_client_to_server")
util.AddNetworkString("playmodes_setTeam_other")


function PlayModes.LoadPerms()
	
	if not file.Exists( "gamemodes", "DATA" ) then
		PlayModes.SavePerms()
	else
		
		PlayModes.Teams.Builder.Perms = util.JSONToTable(file.Read( "gamemodes/builder_perms.txt", "DATA" ))
		PlayModes.Teams.Fighter.Perms = util.JSONToTable(file.Read( "gamemodes/fighter_perms.txt", "DATA" ))
		PlayModes.Teams.Spectator.Perms = util.JSONToTable(file.Read( "gamemodes/spectator_perms.txt", "DATA" ))
		
	end
	
end

function PlayModes.SavePerms()
	
	if not file.Exists( "gamemodes", "DATA" ) then
		file.CreateDir( "gamemodes" )
	end
	
	file.Write( "gamemodes/builder_perms.txt", 	 util.TableToJSON( PlayModes.Teams.Builder.Perms ) )
	file.Write( "gamemodes/fighter_perms.txt", 	 util.TableToJSON( PlayModes.Teams.Fighter.Perms ) )
	file.Write( "gamemodes/spectator_perms.txt", util.TableToJSON( PlayModes.Teams.Spectator.Perms ) )
	
end

function PlayModes.HasPermission(ply,perm)
	
	local plyTeam = PlayModes.GetTeam(ply)
	
	if table.HasValue( PlayModes.Teams[plyTeam].Perms, perm ) then
		return nil
	else
		return false
	end
	
end

function PlayModes.GetTeam(ply)
	
	return ply:GetNWString( "gamemode_team", "Spectator" )
	
end

function PlayModes.PM(ply,message)
	
	net.Start("playmodes_message")
		net.WriteString(message)
	net.Send(ply)
	
end

function PlayModes.Broadcast(message)
	
	net.Start("playmodes_message")
		net.WriteString(message)
	net.Broadcast()
	
end

function PlayModes.OpenMenu(ply)
	
	net.Start("playmodes_openmenu")
	net.Send(ply)
	
end

function PlayModes.CheckPermission(ply,perm)
	
	if ULib then
		return ULib.ucl.query(ply,perm)
	elseif evolve then
		return ply:EV_HasPrivilege( perm )
	else
		return ply:IsSuperAdmin()
	end
	
end

function PlayModes.OpenAdminMenu(ply)
	
	net.Start("playmodes_openadminmenu")
		net.WriteTable(PlayModes.Teams)
	net.Send(ply)
	
end

function PlayModes.SetTeam(ply,plyTeam,chatPrint)

	if chatPrint==nil then
		chatPrint=false
	end
	
	if PlayModes.GetTeam(ply)==plyTeam then return end;
	if not ply:GetNWBool( "changed_team", true ) then
	
		ply:SetNWBool( "changed_team", true )
		timer.Simple(5,function(ply) ply:SetNWBool( "changed_team", true ) end)
		
	else
		PlayModes.PM(ply,"Whoa buddy, You can't change your team just after you changed it. Please wait 5 seconds.")
		return end;
	end
	
	ply:SetNWString( "gamemode_team", plyTeam )
	
	if chatPrint then
		PlayModes.Broadcast((ply:Nick() or "Someone").."'s team changed! New team: "..plyTeam)
	end

	
	PlayModes.TeamInit[plyTeam](ply)
	
end



net.Receive( "playmodes_client_to_server", function( len, pl )
	
	--if not PlayModes.CheckPermission(ply,"modes_admin_gui") then return end;
	
	local cmd = net.ReadString()
	
	if cmd=="set_team" then
		PlayModes.SetTeam(pl,net.ReadString(),true)
	else
	
		if PlayModes.CheckPermission(pl,"modes_admin_gui") then
			
			if cmd=="send_settings" then
				PlayModes.Teams = net.ReadTable()
			elseif cmd=="playmodes_reload" then	
				net.Start("playmodes_reload")
					net.WriteTable(PlayModes.Teams)
				net.Send(ply)
			elseif cmd=="playmodes_reset_violations" then	
				player.GetBySteamID64(net.ReadString()):SetNWInt( "violations", 0 )
			elseif cmd=="playmodes_kick" then	
				player.GetBySteamID64(net.ReadString()):Kick([[
						
					[Kicked by Gamemodes]
					You got kicked from the game due to too much violations.
					Kicked by ]]..pl:Nick()..[[
				]])
			end
		end
		
	end
	
	
end )

net.Receive( "playmodes_setTeam_other", function( len, pl )

	if not PlayModes.CheckPermission(pl,"modes_admin_gui") then return end;
	
	if PlayModes.CheckPermission(pl,"modes_admin_gui") then
	
		local steamid = net.ReadString()
		local newTeam = net.ReadString()
		local ply = nil
		
		for k,v in pairs(player.GetAll()) do
			if v:SteamID64()==steamid then
				ply = v
			end
		end
		
		if not ply then return end;
		
		PlayModes.SetTeam(ply,newTeam,true)
	end
	
end )

include("sv_mode_hooks.lua")
