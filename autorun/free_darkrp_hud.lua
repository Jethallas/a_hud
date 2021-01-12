--[[
  Free DarkRP HUD v2
  Coded by: Jethallas
]]

--Replaced model with steam avatar
--Set the font to something everyone has
--removed "DrawFillableBars" and similar functions which were either never used or unnecessary
--Removed Table.Hasvalue for HUDShouldDraw (performance)
--Removed CreateHUD and defined it in hook (performance, no double func call)
--Color(255,255,255) -> COLOR_WHITE (doesnt create a new color object)
--Made top and main box into one
--moved local static variables out of the loop

--surface.CreateFont("ammof", {font = "BebasNeue", size = 35, weight = 500, antialias = true, shadow = false})
--surface.CreateFont("ammofsmall", {font = "BebasNeue", size = 25, weight = 500, antialias = true, shadow = false})
surface.CreateFont( "ElegantHUDFont", { font = "Consolas", size = 18, weight = 0 } )
surface.CreateFont( "ElegantAmmoFont", { font = "Consolas", size = 48, weight = 0 } )
--Montserrat

local health_icon = Material( "icon16/heart.png" )
local shield_icon = Material( "icon16/shield.png" )
local cash_icon = Material( "icon16/money.png" )
local star_icon = Material( "icon16/star.png" )
local tick_icon = Material( "icon16/tick.png" )

hook.Add( 'HUDShouldDraw', 'HUD_HIDE_DEFAULT', function( vs )
  if vs == "DarkRP_HUD" or vs == "CHudBattery" or vs == "CHudHealth" then return false end
  if vs == "CHudSecondaryAmmo" or vs == "CHudAmmo" then return false end
end)

local function CreateImageIcon( icon, x, y, col, val )
    surface.SetDrawColor( col )
    surface.SetMaterial( icon )
    local w, h = 16, 16
    if val then
        surface.SetDrawColor( Color( 255, 255, 255 ) )
    end
    surface.DrawTexturedRect( x, y, w, h )
end

--local vars for HUD
local avatar
local scrw = ScrW()
local scrh = ScrH()
local startX = 5
local startY = scrh-172
local baseWidth = 320
local baseHeight = 140

local barX = 100
local barY = startY + 40
local barWidth = 190
local badHeight = 24
local maxBarSize = 220
local iconOffset = 25

if avatar then avatar:Remove() end
hook.Add( 'HUDPaint', 'HUD_DRAW_HUD', function()
  local ply = LocalPlayer()
  --MainBox
  surface.SetDrawColor(Color(14, 14, 14, 250))
  surface.DrawRect(startX, startY, baseWidth, baseHeight)
  --Job
  surface.SetFont("ElegantHUDFont")
  local job = team.GetName( ply:Team() )
  local jobOffset = surface.GetTextSize(job)
  draw.SimpleText( ply:Nick(), "ElegantHUDFont", 12, startY + 17, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  draw.SimpleText( job, "ElegantHUDFont", baseWidth-2-jobOffset, startY + 17, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  --Avatar
  if !IsValid(avatar) then
    avatar = vgui.Create("AvatarImage")
    avatar:SetPos( startX + 10, startY + 39 )
    avatar:SetSize( 75, 75)
    avatar:SetPlayer(ply, 64)
    avatar:ParentToHUD()
    avatar.Think = function(self)
      wep = LocalPlayer():GetActiveWeapon()
      if wep:IsValid() and wep:GetClass() == "gmod_camera" then
        self:Remove()
      end
    end
    avatar.OnScreenSizeChanged = function(self)
      self:SetPos(startX + 10, startY + 39)
      scrw = ScrW()
      scrh = ScrH()
      startY = ScrH()-172
      barY = startY + 40
    end
  end
  --backgrounds
  surface.SetDrawColor(Color(26,26,26))
  surface.DrawRect(barX, barY, maxBarSize, badHeight)
  surface.DrawRect(barX, barY + 28, maxBarSize, badHeight)
  surface.DrawRect(barX, barY + 55, maxBarSize, badHeight)
  --HP
  surface.SetDrawColor(Color(220, 20, 60, 190))
  surface.DrawRect(barX + iconOffset, barY, ((ply:Health()*maxBarSize)/ply:GetMaxHealth()) - iconOffset, badHeight)
  draw.SimpleText(ply:Health() > 0 and ply:Health() or 0, "ElegantHUDFont", 215, barY + 4, COLOR_WHITE, TEXT_ALIGN_CENTER)
  --Armor
  surface.SetDrawColor(Color(30, 144, 255))
  surface.DrawRect(barX + iconOffset, barY + 28, ((ply:Armor()*maxBarSize)/ply:GetMaxArmor()) - iconOffset, badHeight)
  draw.SimpleText(ply:Armor() > 0 and ply:Armor() or 0, "ElegantHUDFont", 215, barY + 32, COLOR_WHITE, TEXT_ALIGN_CENTER)
  --Green Money
  surface.SetDrawColor(Color(46, 204, 113))
  surface.DrawRect(barX + iconOffset, barY + 55, maxBarSize - iconOffset, badHeight)
  draw.SimpleText(DarkRP.formatMoney(ply:getDarkRPVar( "money" )), "ElegantHUDFont", 215, startY + 99, COLOR_WHITE, TEXT_ALIGN_CENTER)
  --Icons
  CreateImageIcon(health_icon, 104, startY + 44, Color(255, 0, 0))
  CreateImageIcon(shield_icon, 103,startY + 71, Color(30,144,255))
  CreateImageIcon(cash_icon, 104, startY + 99, Color(255, 255, 255))
  CreateImageIcon(star_icon, 30, startY + 119, Color(40, 40, 40), ply:isWanted() )
  CreateImageIcon(tick_icon, 55, startY + 120, Color(40, 40, 40), ply:getDarkRPVar("HasGunlicense") )
  
  wep = ply:GetActiveWeapon()
	if wep:IsValid() then
		local veh = ply:GetVehicle()
		if veh:IsValid() and !ply:GetAllowWeaponsInVehicle() then return end
		wep_class = wep:GetClass()
		wep_name = wep:GetPrintName() or wep_class or "Unbekannt"
    ammo_type = wep:GetPrimaryAmmoType()
    if ammo_type == -1 then
      surface.SetDrawColor(Color(14, 14, 14, 250))
      surface.DrawRect(scrw-245, scrh-170, 200, 30)
      draw.SimpleText(wep_name, "ElegantHUDFont", scrw-240, scrh-165, COLOR_WHITE, TEXT_ALIGN_LEFT)
    end
    if ammo_type ~= -1 then
      surface.SetDrawColor(Color(14, 14, 14, 250))
      surface.DrawRect(scrw-245, scrh-170, 200, 105)
      draw.SimpleText(wep_name, "ElegantHUDFont", scrw-240, scrh-165, COLOR_WHITE, TEXT_ALIGN_LEFT)
      draw.SimpleText(wep:Clip1(), "ElegantAmmoFont", scrw-145, scrh-150, COLOR_WHITE, TEXT_ALIGN_RIGHT)
      draw.SimpleText(ply:GetAmmoCount(ammo_type), "ElegantHUDFont", scrw-100, scrh-113, COLOR_WHITE, TEXT_ALIGN_RIGHT)
      surface.SetDrawColor(Color(255,155,0))
      surface.DrawRect(scrw-240,scrh-90,(wep:Clip1()*190)/wep:GetMaxClip1(),20)
    end
  end
end)

------- OVERHEAD STARTS HERE-------
--Include Config for Above Head---
include('e_config.lua')    
----------------------------------

if (E.Config.Font == 1) then		
      surface.CreateFont ("EName", {
      size = 23,
      weight = 200,
      antialias = true,					
      shadow = false,
      font = "coolvetica"})
end		
  
if (E.Config.Font == 2) then
    surface.CreateFont ("EName", {
    size = 23,
    weight = 400,
    antialias = true,
    shadow = false,
    font = "DejaVu Sans"})
end

if (E.Config.Font == 3) then
    surface.CreateFont ("EName", {	
    size = 20,
    weight = 400,
    antialias = true,
    shadow = false,
    font = "akbar"})
end


local function drb(r, x, y, w, h, col)
    draw.RoundedBox(r, x, y, w, h, col)
end

local function ddt(text, font, x, y, col, align)
    draw.DrawText(text, font, x, y, col, align or 0)
end

local function dicon(mat, x, y, w, h)
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( Material(mat) )
    surface.DrawTexturedRect( x, y, w, h)
end

function DrawE(ply)
    local pos = ply:EyePos()
    pos.z = pos.z + 15
    pos = pos:ToScreen()
    pos.y = pos.y - 60

	if E.Config.DarkRP then
		ply.DarkRPVars = ply.DarkRPVars or {}
	end

    local RankData = E.Config.Ranks[ply:GetUserGroup()] or {}
    local hasRank = (RankData[1] and true or false)
    local x, y = pos.x - 115 , pos.y + 1
    local w, h = 200, (hasRank and E.Config.Showrank and 60 or 60)
    local tcol = team.GetColor(ply:Team())
    local name = ply:Nick() or "Joe Doe"
	local rankpos = 2


    if E.Config.Round == 1 then
		round = 6
	elseif E.Config.Round == 2 then
		round = 0
    end

	if E.Config.Second then
		drb(round, x, y, w, h, RankData[3] or Color(0,0,0))
	elseif (E.Config.Second == false) then			
		drb(round, x, y, w, 32, RankData[3] or Color(0,0,0))
	end		

    drb(round, x + 3, y + 3, w - 6, 25, E.Config.Color.Nametext)
    ddt(name, "EName", x + w / 2, y + 4, E.Config.Color.Namebg, TEXT_ALIGN_CENTER)

	if E.Config.DarkRP and E.Config.Second then
		ddt(ply:getDarkRPVar("job") or "", "EName", x + w / 2, y + 34, E.Config.Color.Jobtext, TEXT_ALIGN_CENTER)
	end

    if (E.Config.ShowEx == "health") or (E.Config.ShowEx == "armor") and (E.Config.Second == true)  then
    if (E.Config.ShowEx == "health") then
		ex = ply:Health()
	elseif (E.Config.ShowEx == "armor") then
		ex = ply:Armor()
	end

    local unit = (w - 6) / 100			

    if (ex < 1) and E.Config.Second then
		drb(round, x + 3, y + 32, w - 6, 25, Color(tcol.r / 2, tcol.g / 2, tcol.b / 2))
	elseif (E.Config.Second == false) then

	else
		drb(round, x + 3, y + 32, w - 6, 25, Color(tcol.r / 2, tcol.g / 2, tcol.b / 2))
		drb(round, x + 3, y + 32, math.Clamp(ex * unit, 12, w - 6), 25, tcol)
	end
    else
		drb(round, x + 3, y + 32, w - 6, 25, tcol)
    end
	
	if E.Config.DarkRP and E.Config.Second then
		ddt(ply:getDarkRPVar("job") or "", "EName", x + w / 2, y + 34, E.Config.Color.Jobtext, TEXT_ALIGN_CENTER)
    end



    if hasRank and E.Config.Showrank and E.Config.Second then
        local rank = RankData[1]
        surface.SetFont("EName")
        local tw = surface.GetTextSize(rank) + 30
        local txtPos = x + w / rankpos - tw / 2
        drb(round, txtPos, pos.y + 62, tw, 25, E.Config.Color.Rankbg)
        ddt(rank, "EName", txtPos + 24, y + 64, RankData[4] or E.Config.Color.Ranktext)
        dicon("icon16/" .. RankData[2] .. ".png", txtPos + 4, y + 66, 16, 16)	
	end


    if ply:getDarkRPVar("HasGunlicense") and E.Config.DarkRP then
        dicon("icon16/" .. E.Config.Icon.Paper .. ".png", x + 7, y + 62, 23, 23)
        dicon("icon16/" .. E.Config.Icon.Gun .. ".png", x + 9, y + 66, 16, 16)
    end


    if E.Config.Showwanted and ply:getDarkRPVar("wanted") and E.Config.DarkRP then
	    local wantedtext = "Wanted by The Police"
		local wantedpos = 30
        local wy = y - wantedpos
        drb(round, x, wy, w, 25, Color(0, 0, 0, 200))
        ddt(wantedtext, "EName", x + w / 2 - 1, wy + 3, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end
			

function ADisplay()
    local localply = LocalPlayer()
    local localpos = localply:GetShootPos()

	if localply:Alive() and not (localply:GetNWString("E_TOGGLE") == "false") then
    for k, v in pairs(player.GetAll()) do
        local pos = v:GetShootPos()
	if (v:Team() == E.Config.Patrol ) or (v:GetUserGroup() == E.Config.RHide) and (v:GetVehicle() == "nil") then
		-- Hmm?
	else
    if localpos:Distance(pos) < E.Config.Range and v:Alive() and (localply:SteamID() != v:SteamID()) then
        local diff = pos - localpos
        local trace = util.QuickTrace(localpos, diff, localply)	
    if trace.Hit and trace.Entity ~= v then return end
        DrawE(v)
	end
	end
	end
	end
end	
timer.Simple( 12, function() hook.Add("HUDPaint", "DrawAntiHud", ADisplay) end )

-- Doors start here --			
local TitleColor = Color( 255, 255, 255, 255 )
local TitleOutlineColor = Color( 0, 0, 0, 200 )

local OwnerColor = Color( 255, 255, 255, 255 )
local OwnerOutlineColor = Color( 0, 0, 0, 200 )

local CoownerColor = Color( 255, 255, 255, 255 )
local CoownerOutlineColor = Color( 0, 0, 0, 200 )

local AllowedGroupsColor = Color( 255, 255, 255, 255 )
local AllowedGroupsOutlineColor = Color( 0, 0, 0, 200 )

local PurchaseColor = Color( 255, 255, 255, 255 )
local PurchaseOutlineColor = Color( 0, 0, 0, 255 )

local DrawDistance = 350
	
      surface.CreateFont ("EName2", {
      size = 27,
      weight = 250,
      antialias = true,					
      shadow = false,
      font = "coolvetica"})
      surface.CreateFont ("EName3", {
      size = 24,
      weight = 220,
      antialias = true,					
      shadow = false,
      font = "coolvetica"})

AddCSLuaFile()

if SERVER then return end

local doorInfo = {}

local function computeFadeAlpha( time, dur, sa, ea, start )
	time = time - (start or 0)

	if time < 0 then return sa end	
	if time > dur then return ea end

	return sa + ((math.sin( (time / dur) * (math.pi / 1.5) )^1.5) * (ea - sa))
end

local function colorMulAlpha( col, mul )
	return Color( col.r, col.g, col.b, col.a * mul )
end

local function isDoor( door )
	if door.isDoor and door.isKeysOwnable then    
		return door:isDoor() and door:isKeysOwnable()
	end
end

local function isOwnable( door )
	if door.getKeysNonOwnable then
		return door:getKeysNonOwnable() != true
	end
end

local function getTitle( door )
	if door.getKeysTitle then
		return door:getKeysTitle()
	end
end

local function getOwner( door )
	if door.getDoorOwner then
		local owner = door:getDoorOwner()

		if IsValid( owner ) then
			return owner
		end
	end
end

local function getCoowners( door )
	local owner = getOwner( door )
	local coents = {}

	if door.isKeysOwnedBy then
		for _, ply in pairs( player.GetAll() ) do
			if door:isKeysOwnedBy( ply ) and ply != owner then
				table.insert( coents, ply )
			end
		end
	end

	return coents
end

local function isAllowedToCoown( door, ply )
	if door.isKeysAllowedToOwn and door.isKeysOwnedBy then
		return door:isKeysAllowedToOwn( ply ) and !door:isKeysOwnedBy( ply )
	end
end

local function getAllowedGroupNames( door )
	local ret = {}

	if door.getKeysDoorGroup and door:getKeysDoorGroup() then
		table.insert( ret, door:getKeysDoorGroup() )
	elseif door.getKeysDoorTeams then
		for tid in pairs( door:getKeysDoorTeams() or {} ) do
			local tname = team.GetName( tid )

			if tname then
				table.insert( ret, tname )
			end
		end
	end

	return ret
end

    

hook.Add( "HUDDrawDoorData", "sh_doordisplay_hudoverride", function( door )
	if isDoor( door ) and isOwnable( door ) then
		if #getAllowedGroupNames( door ) < 1 then
			local dist = door:GetPos():Distance( LocalPlayer():GetShootPos() )
			local admul = math.cos( (dist / DrawDistance) * (math.pi / 2) )^2 

			if !getOwner( door ) then
				draw.SimpleTextOutlined(
					"Press F2 to purchase",
					"EName",
					ScrW() / 2, ScrH() / 2,
					colorMulAlpha( PurchaseColor, admul ),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,
					1, colorMulAlpha( PurchaseOutlineColor, admul )
				)
			elseif isAllowedToCoown( door, LocalPlayer() ) then
				draw.SimpleTextOutlined(
					"Press F2 to co-own",
					"EName",
					ScrW() / 2, ScrH() / 2,
					colorMulAlpha( PurchaseColor, admul ),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,
					1, colorMulAlpha( PurchaseOutlineColor, admul )
				)
			end
		end

		return true
	end
end )

hook.Add( "PostDrawTranslucentRenderables", "sh_doordisplay_drawdisplay", function()
	for _, door in pairs( ents.GetAll() ) do
		if !isDoor( door ) or !isOwnable( door ) then continue end
    
		local dinfo = doorInfo[door]
    
		if !dinfo then
			dinfo = {
				coownCollapsed = true
			}

			local dimens = door:OBBMaxs() - door:OBBMins()
			local center = door:OBBCenter()
			local min, j 

			for i=1, 3 do
				if !min or dimens[i] <= min then
					j = i
					min = dimens[i]
				end
			end

			local norm = Vector()
			norm[j] = 1

			local lang = Angle( 0, norm:Angle().y + 90, 90 )

			if door:GetClass() == "prop_door_rotating" then
				dinfo.lpos = Vector( center.x, center.y, 30 ) + lang:Up() * (min / 6)
			else    
				dinfo.lpos = center + Vector( 0, 0, 20 ) + lang:Up() * ((min / 2) - 0.1)
			end
			
			dinfo.lang = lang
  
			doorInfo[door] = dinfo
		end

		local dist = door:GetPos():Distance( LocalPlayer():GetShootPos() )

		if dist <= DrawDistance then
			dinfo.viewStart = dinfo.viewStart or CurTime()

			local title = getTitle( door )
			local owner = getOwner( door )
			local coowners = getCoowners( door ) or {}
			local allowedgroups = getAllowedGroupNames( door )

			local lpos, lang = Vector(), Angle()
			lpos:Set( dinfo.lpos )
			lang:Set( dinfo.lang )

			local ang = door:LocalToWorldAngles( lang )
			local dot = ang:Up():Dot( 
				LocalPlayer():GetShootPos() - door:WorldSpaceCenter()
			)

			if dot < 0 then
				lang:RotateAroundAxis( lang:Right(), 180 )

				lpos = lpos - (2 * lpos * -lang:Up())
				ang = door:LocalToWorldAngles( lang )
			end
    
			local pos = door:LocalToWorld( lpos )
			local scale = 0.14

			local vst = dinfo.viewStart
			local ct = CurTime()
      local w = 300 
      local w2 = 250
			local h = 150
      local h2 = 100


			cam.Start3D2D( pos, ang, scale )
				local admul = math.cos( (dist / DrawDistance) * (math.pi / 4) )^4
				local amul = computeFadeAlpha( ct, 0.75, 0, 4, vst ) * admul

				if #allowedgroups < 1 then
					if title and #title > 16 then
						title = title:Left( 16 ) .. "..." 
					end
            surface.SetDrawColor(Color(0, 0, 0, 200))		  
            surface.DrawRect(-w2/2, h2 - 120, w2, 35)
            surface.SetDrawColor(Color(255, 255, 255, 150))     
            surface.DrawLine(-w2/2 -1, h - 136, w2/2, h - 136) 
            surface.DrawLine(-w2/2 -1, h2 - 121, w2/2, h2 - 121)
					draw.SimpleTextOutlined( owner and (title or "Owned by:") or "Unowned","EName2",0, 10,colorMulAlpha( TitleColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, colorMulAlpha( TitleOutlineColor, amul ))    

					if owner then   
					 amul = computeFadeAlpha( ct, 0.75, 0, 1, vst + 0.35 ) * admul            
           surface.SetDrawColor(Color(0, 0, 0, 200))		  
            surface.DrawRect(-w2/2, h - 135, w2, 40)    
            surface.SetDrawColor(Color(255, 255, 255, 150))    
            surface.DrawLine(-w2/2 - 1, h - 95, w2/2, h - 95)   
						draw.SimpleTextOutlined(owner:Nick(),"EName3",0, 50,colorMulAlpha( OwnerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, colorMulAlpha( OwnerOutlineColor, amul ))  

						if #coowners > 0 then
							if !dinfo.coownCollapsed then
								local conames = {}    

								for i=1, #coowners do
									table.insert( conames, coowners[i]:Nick() )
								end 

								table.sort( conames )   

								for i=1, #conames do    
									amul = computeFadeAlpha( ct, 1, 0, 1, dinfo.coownExpandStart + 0.1*i ) * admul
                  surface.SetDrawColor(Color(0, 0, 0, 200))		      
                  surface.DrawRect(-w2/2, h/5.6 + 30*i, w2, 30)   
                  surface.SetDrawColor(Color(255, 255, 255, 150))                     
                  surface.DrawLine(-w2/2 - 1, h/2.68  + 30*i, w2/2, h/2.68+ 30*i)   
									draw.SimpleTextOutlined(conames[i],"EName3",0, 60 + 25*i,colorMulAlpha( CoownerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,	1, colorMulAlpha( CoownerOutlineColor, amul ))
								end
							else
								amul = computeFadeAlpha( ct, 0, 0, 0, vst ) * admul

								local whitpos = util.IntersectRayWithPlane( LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(),pos, ang:Up())
								local cy = 0
								local cactive = false

								if whitpos and LocalPlayer():GetEyeTrace().Entity == door then
									local hitpos = door:WorldToLocal( whitpos ) - lpos 
                  cy = -hitpos.z / scale
									cactive = true        
								end
  
								if (ct - vst) >= 0 and cactive and cy >= 50 and cy <= 80 + 800 then
									dinfo.coownExpandRequestStart = dinfo.coownExpandRequestStart or CurTime()  

									if CurTime() - dinfo.coownExpandRequestStart >= 0.35 then
										dinfo.coownCollapsed = false
										dinfo.coownExpandStart = CurTime()      
										dinfo.coownExpandRequestStart = nil
									end

									amul = computeFadeAlpha( ct, 10, 1, 0, dinfo.coownExpandRequestStart  ) * admul --fade out
								else      
									dinfo.coownExpandRequestStart = nil 
								end
                 surface.SetDrawColor(Color(0, 0, 0, 200))		  
                 surface.DrawRect(-w2/2, h - 94, w2, 30)    
                 surface.SetDrawColor(Color(255, 255, 255, 150))    
                  surface.DrawLine(-w2/2 - 1, h - 65, w2/2, h - 65)   
								draw.SimpleTextOutlined("And " .. #coowners .. " other(s)","EName",	0, 80, colorMulAlpha( CoownerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, colorMulAlpha( CoownerOutlineColor, amul )	)
							end
						end   
					end
				else    
					for i=1, #allowedgroups do
						amul = computeFadeAlpha( ct, 0.75, 0, 1, vst + 0.2*i ) * admul
            surface.SetDrawColor(Color(0, 0, 0, 200))		
            surface.DrawRect(-w/2, h - 135, w, 50)
            surface.SetDrawColor(Color(255, 255, 255, 150))
            surface.DrawLine(-w/2 -1, h - 136, w/2, h - 136)
            surface.DrawLine(-w/2 - 1, h - 85, w/2, h - 85)            
						draw.SimpleTextOutlined(allowedgroups[i],"EName",0, 50 + 30*(i-1),colorMulAlpha( AllowedGroupsColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, colorMulAlpha( AllowedGroupsOutlineColor, amul ))
					end
				end
			cam.End3D2D()
		else
			dinfo.viewStart = nil
			dinfo.coownCollapsed = true
		end
	end
end )
