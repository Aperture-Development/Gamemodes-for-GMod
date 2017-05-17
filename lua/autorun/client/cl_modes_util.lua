PlayModes = PlayModes or {}
PlayModes.Col = {
	["Spectator"] = Color( 120, 120, 120, 255 ),
	["Builder"] = Color( 0, 161, 255, 255 ),
	["Fighter"] = Color(200,0,0,255)
}

function PlayModes.AddPermList(tbl,DList)
	DList:Clear()
	for k,v in pairs(tbl) do
		DList:AddLine(v)
	end
end

function PlayModes.AddPlayerList(tbl,DList)
	DList:Clear()
	for k,v in pairs(tbl) do
		DList:AddLine(v:Nick(),v:SteamID64(),v:GetNWInt( "violations", 0),v:GetNWString( "gamemode_team","Spectator"))
	end
end

function PlayModes.RemoveLineMenu(panel,lineid)
	local RemoveLineMenu = DermaMenu()
	RemoveLineMenu:SetPos(gui.MousePos())
	RemoveLineMenu:AddOption( "Remove" )
	RemoveLineMenu:Open()
	RemoveLineMenu.OptionSelected = function(p,p_opt,sel)
		if sel=="Remove" then
			panel:RemoveLine(lineid)
		end
	end
end

function PlayModes.CMD(command,data,data_2)
	
	net.Start("playmodes_client_to_server")
		net.WriteString(command)
		if type(data)=="string" then
			net.WriteString(data)
		elseif type(data)=="table" then
			net.WriteTable(data)
		end
	net.SendToServer()
	
end

function PlayModes.SetTeamOther(steamid,newTeam)
	
	net.Start("playmodes_setTeam_other")
		net.WriteString(steamid)
		net.WriteString(newTeam)
	net.SendToServer()
	
end

function PlayModes.SaveTables(tbl_obj,tbl)
	
	tbl = {}
	
	print("Saving...")
	
	for k, line in pairs( tbl_obj:GetLines())  do
		table.insert( tbl , tbl_obj:GetLine(k):GetValue(1) )
		print(line:GetValue(1))
	end
	
	
end