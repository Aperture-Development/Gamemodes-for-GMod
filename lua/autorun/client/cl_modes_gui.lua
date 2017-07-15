PlayModes = PlayModes or {}
include("cl_modes_util.lua")

surface.CreateFont( "Gamemode_selection", {
	font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


net.Receive( "playmodes_message", function( len, pl )
	
	local text = net.ReadString()
	chat.AddText(Color(255,255,255),"[",Color(255,0,0),"Gamemodes",Color(255,255,255),"] "..text)
	
end )

net.Receive( "playmodes_openmenu", function( len, pl )
	
	local SelectionPanel = vgui.Create( "DFrame" )
	SelectionPanel:SetPos(ScrW()/2-150,ScrH()/2-100)
	SelectionPanel:SetSize( 300, 200 )
	SelectionPanel:SetTitle( "Gamemode Selection" )
	SelectionPanel:SetDraggable( true )
	SelectionPanel:MakePopup()
	SelectionPanel.Paint = function( p, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 230 ) )
	end
	
	local FighterButton = vgui.Create( "DButton", SelectionPanel ) 
	FighterButton:SetText("Fighter")
	FighterButton:SetFont("Gamemode_selection")
	FighterButton:SetTextColor(Color(255,255,255,255))
	FighterButton:SetPos( 25, 50 )					
	FighterButton:SetSize( 250, 30 )					
	FighterButton.DoClick = function()				
		PlayModes.CMD("set_team","Fighter")
		SelectionPanel:Close()	
	end
	FighterButton.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 0, 0, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 0, 0, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	local Builder = vgui.Create( "DButton", SelectionPanel ) 
	Builder:SetText("Builder")
	Builder:SetFont("Gamemode_selection")
	Builder:SetTextColor(Color(255,255,255,255))
	Builder:SetPos( 25, 90 )					
	Builder:SetSize( 250, 30 )					
	Builder.DoClick = function()				
		PlayModes.CMD("set_team","Builder")	
		SelectionPanel:Close()
	end
	Builder.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 161, 255, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 81, 255, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 10, 255, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	
	
	local Spectator = vgui.Create( "DButton", SelectionPanel ) 
	Spectator:SetText("Spectator")
	Spectator:SetFont("Gamemode_selection")
	Spectator:SetTextColor(Color(255,255,255,255))
	Spectator:SetPos( 25, 130 )					
	Spectator:SetSize( 250, 30 )					
	Spectator.DoClick = function()				
		PlayModes.CMD("set_team","Spectator")
		SelectionPanel:Close()
	end
	Spectator.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	 
end )

net.Receive( "playmodes_openadminmenu", function( len, pl )
	
	PlayModes.Teams = net.ReadTable()
	
	--PrintTable(PlayModes.Teams)
	
	
	
	PlayModes.AdminPanel = vgui.Create( "DFrame" )
	PlayModes.AdminPanel:SetPos(ScrW()/2-400,ScrH()/2-200)
	PlayModes.AdminPanel:SetSize( 800, 400 )
	PlayModes.AdminPanel:SetTitle( "Gamemode Admin Gui" )
	PlayModes.AdminPanel:SetDraggable( true )
	PlayModes.AdminPanel:MakePopup()
	PlayModes.AdminPanel.Paint = function( p, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 230 ) )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h ) 
	end
	
	PlayModes.PermList = vgui.Create( "DListView",PlayModes.AdminPanel )
	PlayModes.PermList:SetMultiSelect( false )
	PlayModes.PermList:SetPos(50,55)
	PlayModes.PermList:SetSize( 150, 180 )
	PlayModes.PermList:AddColumn( "All Permissions" )
	PlayModes.PermList.OnRowSelected = function(panel_line,lineid)
		PlayModes.Temp = panel_line:GetLine(lineid):GetValue(1)
	end
	
	
	
	
	PlayModes.FighterPermList = vgui.Create( "DListView",PlayModes.AdminPanel )
	PlayModes.FighterPermList:SetMultiSelect( false )
	PlayModes.FighterPermList:SetPos(210,55)
	PlayModes.FighterPermList:SetSize( 150, 150 )
	PlayModes.FighterPermList:AddColumn( "Fighter Permissions" )
	PlayModes.FighterPermList.OnRowRightClick = function(p,lineid)
		PlayModes.RemoveLineMenu(p,lineid)
	end
	
	
	PlayModes.FighterAddPerm = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.FighterAddPerm:SetText("Add Permission")
	PlayModes.FighterAddPerm:SetFont("Gamemode_selection")
	PlayModes.FighterAddPerm:SetTextColor(Color(255,255,255,255))
	PlayModes.FighterAddPerm:SetPos( 210, 205 )					
	PlayModes.FighterAddPerm:SetSize( 150, 30 )					
	PlayModes.FighterAddPerm.DoClick = function()				
		PlayModes.FighterPermList:AddLine(PlayModes.Temp)		
	end
	PlayModes.FighterAddPerm.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	
	
	
	
	PlayModes.BuilderPermList = vgui.Create( "DListView",PlayModes.AdminPanel )
	PlayModes.BuilderPermList:SetMultiSelect( false )
	PlayModes.BuilderPermList:SetPos(370,55)
	PlayModes.BuilderPermList:SetSize( 150, 150 )
	PlayModes.BuilderPermList:AddColumn( "Builder Permissions" )
	PlayModes.BuilderPermList.OnRowRightClick = function(p,lineid)
		PlayModes.RemoveLineMenu(p,lineid)
	end
	
	
	PlayModes.BuilderAddPerm = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.BuilderAddPerm:SetText("Add Permission")
	PlayModes.BuilderAddPerm:SetFont("Gamemode_selection")
	PlayModes.BuilderAddPerm:SetTextColor(Color(255,255,255,255))
	PlayModes.BuilderAddPerm:SetPos( 370, 205 )					
	PlayModes.BuilderAddPerm:SetSize( 150, 30 )					
	PlayModes.BuilderAddPerm.DoClick = function()				
		PlayModes.BuilderPermList:AddLine(PlayModes.Temp)			
	end
	PlayModes.BuilderAddPerm.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	
	
	
	
	PlayModes.SpectatorPermList = vgui.Create( "DListView",PlayModes.AdminPanel )
	PlayModes.SpectatorPermList:SetMultiSelect( false )
	PlayModes.SpectatorPermList:SetPos(530,55)
	PlayModes.SpectatorPermList:SetSize( 150, 150 )
	PlayModes.SpectatorPermList:AddColumn( "Spectator Permissions" )
	PlayModes.SpectatorPermList.OnRowRightClick = function(p,lineid)
		PlayModes.RemoveLineMenu(p,lineid)
	end
	
	
	PlayModes.SpectatorAddPerm = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.SpectatorAddPerm:SetText("Add Permission")
	PlayModes.SpectatorAddPerm:SetFont("Gamemode_selection")
	PlayModes.SpectatorAddPerm:SetTextColor(Color(255,255,255,255))
	PlayModes.SpectatorAddPerm:SetPos( 530, 205 )					
	PlayModes.SpectatorAddPerm:SetSize( 150, 30 )					
	PlayModes.SpectatorAddPerm.DoClick = function()				
		PlayModes.SpectatorPermList:AddLine(PlayModes.Temp)				
	end
	PlayModes.SpectatorAddPerm.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	
	
	
	PlayModes.PlayerList = vgui.Create( "DListView",PlayModes.AdminPanel )
	PlayModes.PlayerList:SetMultiSelect( false )
	PlayModes.PlayerList:SetPos(50,245)
	PlayModes.PlayerList:SetSize( 630, 100 )
	PlayModes.PlayerList:AddColumn( "Player" )
	PlayModes.PlayerList:AddColumn( "SteamID 64" )
	PlayModes.PlayerList:AddColumn( "Violations" )
	PlayModes.PlayerList:AddColumn( "Team" )
	PlayModes.PlayerList.OnRowRightClick = function(p,lineid) 
	
		PlayModes.PlayerListMenu = DermaMenu()
		PlayModes.PlayerListMenu:SetPos(gui.MousePos())
		PlayModes.PlayerListMenu:AddOption( "Kick" )
		PlayModes.PlayerListMenu:AddOption( "Reset Violations" )
		PlayModes.PlayerListMenu:AddSpacer()	
		PlayModes.PlayerListMenu:AddOption( "Set Team Fighter" )
		PlayModes.PlayerListMenu:AddOption( "Set Team Builder" )
		PlayModes.PlayerListMenu:AddOption( "Set Team Spectator" )
		PlayModes.PlayerListMenu:Open()
		PlayModes.PlayerListMenu.OptionSelected = function(pan,p_opt,sel)
		
			if sel=="Set Team Fighter" or sel=="Set Team Builder" or sel=="Set Team Spectator" then
			
				local str = string.Explode( " ", sel )
				PlayModes.SetTeamOther(p:GetLine(lineid):GetValue(2),str[3])
				timer.Simple(1,function() PlayModes.AddPlayerList(player.GetAll(),PlayModes.PlayerList) end)
				
			elseif sel=="Kick" then
			
				PlayModes.CMD("playmodes_kick",p:GetLine(lineid):GetValue(2))
				timer.Simple(1,function() PlayModes.AddPlayerList(player.GetAll(),PlayModes.PlayerList) end)
				
			elseif sel=="Reset Violations" then
			
				PlayModes.CMD("playmodes_reset_violations",p:GetLine(lineid):GetValue(2))
				
			end
		end
		
	end
	
	
	
	
	
	
	
	PlayModes.SaveButton = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.SaveButton:SetText("Save Settings")
	PlayModes.SaveButton:SetFont("Gamemode_selection")
	PlayModes.SaveButton:SetTextColor(Color(255,255,255,255))
	PlayModes.SaveButton:SetPos( 150, 350 )					
	PlayModes.SaveButton:SetSize( 150, 30 ) 					
	PlayModes.SaveButton.DoClick = function()
	
		--PlayModes.SaveTables(PlayModes.SpectatorPermList,PlayModes.Teams.Spectator.Perms)
		--PlayModes.SaveTables(PlayModes.BuilderPermList	,PlayModes.Teams.Builder.Perms)
		--PlayModes.SaveTables(PlayModes.FighterPermList	,PlayModes.Teams.Fighter.Perms)
		
		for k, line in pairs( PlayModes.SpectatorPermList:GetLines())  do
			table.insert( PlayModes.Teams.Spectator.Perms , line:GetValue(1) )
		end
	
		for k, line in pairs( PlayModes.BuilderPermList:GetLines())  do
			table.insert( PlayModes.Teams.Builder.Perms , line:GetValue(1) )
		end
		
		for k, line in pairs( PlayModes.FighterPermList:GetLines())  do
			table.insert( PlayModes.Teams.Fighter.Perms , line:GetValue(1) )
		end
		
		PrintTable(PlayModes.Teams)
		PlayModes.CMD("send_settings",PlayModes.Teams)	
		
	end
	PlayModes.SaveButton.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	PlayModes.ReloadButton = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.ReloadButton:SetText("Reload")
	PlayModes.ReloadButton:SetFont("Gamemode_selection")
	PlayModes.ReloadButton:SetTextColor(Color(255,255,255,255))
	PlayModes.ReloadButton:SetPos( 305, 350 )				
	PlayModes.ReloadButton:SetSize( 150, 30 )					
	PlayModes.ReloadButton.DoClick = function()				
		PlayModes.CMD("playmodes_reload")				
	end
	PlayModes.ReloadButton.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	PlayModes.CloseButton = vgui.Create( "DButton", PlayModes.AdminPanel ) 
	PlayModes.CloseButton:SetText("Close")
	PlayModes.CloseButton:SetFont("Gamemode_selection")
	PlayModes.CloseButton:SetTextColor(Color(255,255,255,255))
	PlayModes.CloseButton:SetPos( 460, 350 )				
	PlayModes.CloseButton:SetSize( 150, 30 )					
	PlayModes.CloseButton.DoClick = function()				
		PlayModes.AdminPanel:Close()
	end
	PlayModes.CloseButton.Paint = function( p,w,h )		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 170, 170, 170, 255 ) )
		if p:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 120, 120, 120, 255 ) )
			if p:IsDown() then
				draw.RoundedBox( 0, 0, 0, w, h, Color( 70, 70, 70, 255 ) )
			end
		end
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
	PlayModes.AddPermList(PlayModes.Teams.Builder.Perms,PlayModes.BuilderPermList)
	PlayModes.AddPermList(PlayModes.Teams.Fighter.Perms,PlayModes.FighterPermList)
	PlayModes.AddPermList(PlayModes.Teams.Spectator.Perms,PlayModes.SpectatorPermList)
	PlayModes.AddPermList(PlayModes.Teams.Perms,PlayModes.PermList)
	PlayModes.AddPlayerList(player.GetAll(),PlayModes.PlayerList)
end )

net.Receive( "playmodes_reload", function( len, pl )
	
	PlayModes.Teams = net.ReadTable()
	PlayModes.AddPermList(PlayModes.Teams.Builder,PlayModes.BuilderPermList)
	PlayModes.AddPermList(PlayModes.Teams.Fighter,PlayModes.FighterPermList)
	PlayModes.AddPermList(PlayModes.Teams.Spectator,PlayModes.SpectatorPermList)
	PlayModes.AddPermList(PlayModes.Teams,PlayModes.PermList)
	PlayModes.AddPlayerList(player.GetAll(),PlayModes.PlayerList)
	
end )

function DrawTeam( ply )
 
	if !ply:Alive() then return end
 
	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
	local plyTeam = ply:GetNWString( "gamemode_team", "No-Team" )
 
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
		draw.DrawText( plyTeam, "Trebuchet24", 2, 2, PlayModes.Col[plyTeam], TEXT_ALIGN_CENTER )
	cam.End3D2D()
 
end
hook.Add( "PostPlayerDraw", "Modes_DrawTeam", DrawTeam )