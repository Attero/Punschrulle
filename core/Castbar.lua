--Aimed Shot workaround based on rais_Autoshot. All credit for that goes straight to raisnilt.

function Punsch_Castbar_Create()
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"]
	PunschEntities["Castbar"] = {}
	local e = PunschEntities["Castbar"]
	e.Type = "Castbar";
	Punsch_Bar_Create(e,db)

	e.text3 = e.TextFrame:CreateFontString(nil,"OVERLAY")
	e.text3:SetFont(GameFontHighlight:GetFont(), 10)
	e.text3:SetText("+0.0")

	e.lagBG = e.ContentFrame:CreateTexture(nil,"ARTWORK")
	e.lagBG:SetPoint("BOTTOMRIGHT",e.ContentFrame)
	e.lagBG:SetPoint("TOP",e.ContentFrame)
	e.lagBG:SetWidth(5)

	e.lagtxt = e.TextFrame:CreateFontString(nil,"OVERLAY")
	e.lagtxt:SetFont(GameFontHighlight:GetFont(), 8)
	e.lagtxt:SetText("0ms")
	e.lagtxt:SetPoint("RIGHT",e.lagBG,"BOTTOMRIGHT")

	e.isCasting = false;
	e.isChannel = false;
	e.spellName = "";
	e.delayedBy = 0;
	e.fadeTimeleft = 0;

	--initializing ranged haste for aimedshot workaround
	e.HasteFromBerserking = 1
	e.HasteFromQuickShots = 1
	e.HasteFromKiss = 1
	e.HasteFromRapid = 1

	--Channeling Ticks
	e.TickIndicators = {}

	e.TicksShown = 0

	for i=1,15 do 
		e.TickIndicators[i] = {}

		e.TickIndicators[i].texture = e.ContentFrame:CreateTexture(nil,"OVERLAY")
		e.TickIndicators[i].texture:SetTexture(0,0,0,1)
		e.TickIndicators[i].texture:Hide()
	end

	--Hooks
	PunschEntities["Castbar"].OriginalUseAction = UseAction
	UseAction = Punsch_Castbar_HookUseAction

	PunschEntities["Castbar"].OriginalCastSpell = CastSpell
	CastSpell = Punsch_Castbar_HookCastSpell

	PunschEntities["Castbar"].OriginalCastSpellByName = CastSpellByName
	CastSpellByName = Punsch_Castbar_HookCastSpellByName

	PunschEntities["Castbar"].OriginalDoTradeSkill = DoTradeSkill
	DoTradeSkill = Punsch_Castbar_HookDoTradeSkill

	e.self:SetScript("OnEvent",Punsch_Castbar_OnEvent)
	e.self:SetScript("OnUpdate",Punsch_Castbar_OnUpdate)

	e.self:RegisterEvent("SPELLCAST_CHANNEL_START")
	e.self:RegisterEvent("SPELLCAST_CHANNEL_STOP")
	e.self:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
	e.self:RegisterEvent("SPELLCAST_DELAYED")
	e.self:RegisterEvent("SPELLCAST_FAILED")
	e.self:RegisterEvent("SPELLCAST_INTERRUPTED")
	e.self:RegisterEvent("SPELLCAST_START")
	e.self:RegisterEvent("SPELLCAST_STOP")
	--keeps track of buffs on self
	e.self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	e.self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
	e.self:RegisterEvent("PLAYER_DEAD")

	--e.self:RegisterEvent("UNIT_MANA")
end

function Punsch_Castbar_Update(e)
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"]

	if db.HideBlizzardBar then
		CastingBarFrame:UnregisterEvent("SPELLCAST_START")
		CastingBarFrame:UnregisterEvent("SPELLCAST_STOP")
		CastingBarFrame:UnregisterEvent("SPELLCAST_FAILED")
		CastingBarFrame:UnregisterEvent("SPELLCAST_INTERRUPTED")
		CastingBarFrame:UnregisterEvent("SPELLCAST_DELAYED")
		CastingBarFrame:UnregisterEvent("SPELLCAST_CHANNEL_START")
		CastingBarFrame:UnregisterEvent("SPELLCAST_CHANNEL_UPDATE")
		CastingBarFrame:UnregisterEvent("SPELLCAST_CHANNEL_STOP")
	else
		CastingBarFrame:RegisterEvent("SPELLCAST_START")
		CastingBarFrame:RegisterEvent("SPELLCAST_STOP")
		CastingBarFrame:RegisterEvent("SPELLCAST_FAILED")
		CastingBarFrame:RegisterEvent("SPELLCAST_INTERRUPTED")
		CastingBarFrame:RegisterEvent("SPELLCAST_DELAYED")
		CastingBarFrame:RegisterEvent("SPELLCAST_CHANNEL_START")
		CastingBarFrame:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
		CastingBarFrame:RegisterEvent("SPELLCAST_CHANNEL_STOP")
	end

	e.lagBG:SetTexture(Punschrulle_GetTexture(db.Texture))
	e.lagBG:SetVertexColor(db.Lag.r,db.Lag.g,db.Lag.b,db.Lag.a)

	e.ShowLag = db.ShowLag
	e.TickEnable = db.Tick.Enable
	e.TickWidth = db.Tick.Width
	e.TickTop =  db.Tick.TopAnchor
	e.TickBot = db.Tick.BotAnchor

	e.fadeTolerance = db.Fade.Tolerance;
	e.fadesht = db.Fade.SuccessHoldTime;
	e.fadefht = db.Fade.FailureHoldTime;
	e.PlayerInterruptAsFailure = PlayerInterruptAsFailure;

	e.CountUpOnChannel = db.CountUpOnChannel;
	e.CountUpOnCast = db.CountUpOnCast;

	e.channelDelayToDuration = db.ChannelDelayToDuration;

	e.text3:SetFont(Punschrulle_GetFont(db.TextDelay.Font), db.TextDelay.FontSize)
	e.text3:SetShadowOffset(db.TextDelay.FontShadowX,db.TextDelay.FontShadowY)
	if db.TextDelay.AnchorToDuration then
		e.text3:SetPoint(db.TextDelay.Point, e.text2,db.TextDelay.rPoint,db.TextDelay.X,db.TextDelay.Y)
	else
		e.text3:SetPoint(db.TextDelay.Point, e.self,db.TextDelay.rPoint,db.TextDelay.X,db.TextDelay.Y)
	end
	e.text3:SetTextColor(db.TextDelay.r,db.TextDelay.g,db.TextDelay.b,db.TextDelay.a)
	e.text3:SetShadowColor(db.TextDelay.sr,db.TextDelay.sg,db.TextDelay.sb,db.TextDelay.sa)

	--needed for shadowoffset to properly update.
	local t = e.text3:GetText()
	e.text3:SetText("")	
	e.text3:SetText(t)

	e.lagtxt:SetFont(Punschrulle_GetFont(db.TextLag.Font), db.TextLag.FontSize)
	e.lagtxt:SetShadowOffset(db.TextLag.FontShadowX,db.TextLag.FontShadowY)
	e.lagtxt:SetTextColor(db.TextLag.r,db.TextLag.g,db.TextLag.b,db.TextLag.a)
	e.lagtxt:SetShadowColor(db.TextLag.sr,db.TextLag.sg,db.TextLag.sb,db.TextLag.sa)

	--needed for shadowoffset to properly update.
	local t = e.lagtxt:GetText()
	e.lagtxt:SetText("")	
	e.lagtxt:SetText(t)

	Punsch_Bar_Update(e,db)
	if e.ShowIcon then
		e.self:SetPoint(db.Anchor.Point,
			UIParent,
			db.Anchor.rPoint,
			db.Anchor.X+db.Height,
			db.Anchor.Y)
	else
		e.self:SetPoint(db.Anchor.Point,
			UIParent,
			db.Anchor.rPoint,
			db.Anchor.X,
			db.Anchor.Y)
	end

	for i=1,15 do 
		--Tick.ShowLag
		if db.Tick.AsSolidColor then
			e.TickIndicators[i].texture:SetTexture(db.Tick.r,db.Tick.g,db.Tick.b,db.Tick.a)
			e.TickIndicators[i].texture:SetVertexColor(1,1,1,1)
		else
			e.TickIndicators[i].texture:SetTexture(Punschrulle_GetTexture(db.Texture))
			e.TickIndicators[i].texture:SetVertexColor(db.Tick.r,db.Tick.g,db.Tick.b,db.Tick.a)
		end

		e.TickIndicators[i].texture:SetPoint("TOP",e.self,"TOP",0,-e.self:GetHeight()*e.TickTop)
		e.TickIndicators[i].texture:SetPoint("BOTTOM",e.self,"BOTTOM",0,e.self:GetHeight()*(1-e.TickBot))

		e.TickIndicators[i].texture:SetWidth(e.TickWidth)
	end

	--update the ticks currently shown to new width, purely cosmetic
	for i=1,e.TicksShown do
		e.TickIndicators[i].texture:SetPoint("LEFT",e.self,"RIGHT",(-i*(e.self:GetWidth()/(e.TicksShown)))-(e.TickWidth/2),0)
		e.TickIndicators[i].texture:SetWidth(e.TickWidth)
	end
end

local debugCastbar = nil
function Punsch_Castbar_OnEvent()
    if (event == "SPELLCAST_CHANNEL_START") then
    	-- arg1 casttime in ms
    	-- arg2 cast name (almost exclusively "Channeling")
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_CHANNEL_START " .. arg1 .. "    " .. arg2) end
    	Punsch_Castbar_OnChannelStart(arg2,arg1)
    elseif (event == "SPELLCAST_START") then
    	--arg1 spell name
    	--arg2 casttime in ms
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_START " .. arg1 .. "    " .. arg2) end
    	Punsch_Castbar_OnCastStart(arg1,arg2)
    elseif (event == "SPELLCAST_CHANNEL_STOP") then
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_CHANNEL_STOP ") end
    	Punsch_Castbar_OnChannelStop()
	elseif (event == "SPELLCAST_CHANNEL_UPDATE") then
		--arg1 timeleft in ms
		if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_CHANNEL_UPDATE " ..arg1) end
    	Punsch_Castbar_OnChannelUpdate(arg1)
    elseif (event == "SPELLCAST_DELAYED") then
    	--arg1 delayed by in ms
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_DELAYED " ..arg1) end
    	Punsch_Castbar_OnCastDelayed(arg1)
    elseif (event == "SPELLCAST_FAILED") then
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_FAILED ") end
    	Punsch_Castbar_OnCastFailed()
    elseif (event == "SPELLCAST_INTERRUPTED") then
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_INTERRUPTED") end
    	Punsch_Castbar_OnCastInterrupted()
    elseif (event == "SPELLCAST_STOP") then
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("SPELLCAST_STOP") end
    	Punsch_Castbar_OnCastStop()
    elseif (event == "CHAT_MSG_SPELL_AURA_GONE_SELF") then
    	local buffName = strsub(arg1,0, -17)
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG_SPELL_AURA_GONE_SELF '" .. buffName .. "'") end
    	if buffName == "Berserking" then
    		PunschEntities["Castbar"].HasteFromBerserking = 1
    	elseif buffName == "Quick Shots" then
    		PunschEntities["Castbar"].HasteFromQuickShots = 1
    	elseif buffName == "Kiss of the Spider" then
    		PunschEntities["Castbar"].HasteFromKiss = 1
    	elseif buffName == "Rapid Fire" then
    		PunschEntities["Castbar"].HasteFromRapid = 1
    	end
    elseif (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") then
    	local _,nameend = strfind(arg1 .. " ", ".", -1)
    	local buffName = strsub(arg1,10, nameend -2)
    	if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS '" .. buffName .. "'") end
    	if buffName == "Berserking" then
    		if((UnitHealth("player")/UnitHealthMax("player")) >= 0.40) then
				PunschEntities["Castbar"].HasteFromBerserking = 1.3 - ((UnitHealth("player")/UnitHealthMax("player"))-0.4) * 5/3 * 0.2
			else
				PunschEntities["Castbar"].HasteFromBerserking = 1.30
			end
		elseif buffName == "Quick Shots" then
    		PunschEntities["Castbar"].HasteFromQuickShots = 1.3
    	elseif buffName == "Kiss of the Spider" then
    		PunschEntities["Castbar"].HasteFromKiss = 1.2
    	elseif buffName == "Rapid Fire" then
    		PunschEntities["Castbar"].HasteFromRapid = 1.4
    	end
	elseif (event =="PLAYER_DEAD") then
		if debugCastbar then DEFAULT_CHAT_FRAME:AddMessage("PLAYER_DEAD") end
		PunschEntities["Castbar"].HasteFromBerserking = 1
    	PunschEntities["Castbar"].HasteFromQuickShots = 1
    	PunschEntities["Castbar"].HasteFromKiss = 1
    	PunschEntities["Castbar"].HasteFromRapid = 1
	end
end

function Punsch_Castbar_HookDoTradeSkill(index, repeatTimes)
	local e = PunschEntities["Castbar"]
	e.LastTradeskillName = GetTradeSkillInfo(index) 
	e.LastTradeskillIcon = GetTradeSkillIcon(index)
	e.LastTradeskillRepeatTimes = repeatTimes
	e.LastTradeskillRepeatedTimes = 0
	PunschEntities["Castbar"].OriginalDoTradeSkill(index, repeatTimes)
end

local Punsch_Castbar_Tooltip = CreateFrame("GameTooltip","Punsch_Castbar_Tooltip",UIParent,"GameTooltipTemplate");
Punsch_Castbar_Tooltip:SetOwner(UIParent,"ANCHOR_NONE");

function Punsch_Castbar_HookUseAction(slot, checkCursor, onSelf)
	local e = PunschEntities["Castbar"]
	if not IsCurrentAction(slot) then 
		e.LastSpellDropOnLoseIsCurrentAction = nil
		e.LastSpellSetOnLoseIsTargeting = nil
		e.LastSpellLocalCast = nil
		e.LastSpellIcon = nil
		e.OriginalUseAction(slot,checkCursor,onSelf)
	else
		e.OriginalUseAction(slot,checkCursor,onSelf)
		return
	end

	--detecting Aimed Shot
	if IsCurrentAction(slot) then 
		Punsch_Castbar_Tooltip:ClearLines();
		Punsch_Castbar_Tooltip:SetAction(slot);
		local spellName = Punsch_Castbar_TooltipTextLeft1:GetText();
		if ( spellName == "Aimed Shot" )  then
			Punsch_Castbar_CastAimedShot()
		end
	end

	--lag
	if IsCurrentAction(slot) and not IsAttackAction(slot) then
		if SpellIsTargeting() then -- await next gcd, should happen when player has set a target
			e.LastUseActionSlot = slot
			e.LastSpellIcon = GetActionTexture(slot)
			e.LastSpellSetOnLoseIsTargeting = true
		else --tentatively keep it until next spellcast or slot is no longer "IsCurrentAction"
			e.LastSpellLocalCast = GetTime()
			e.LastSpellIcon = GetActionTexture(slot)
			e.LastSpellDropOnLoseIsCurrentAction = true
			e.LastUseActionSlot = slot
		end
	end
end

function Punsch_Castbar_HookCastSpell(spellID, spellTab)
	local e = PunschEntities["Castbar"]
	e.LastSpellDropOnLoseIsCurrentAction = nil
	e.LastSpellSetOnLoseIsTargeting = nil
	e.LastSpellLocalCast = nil
	e.LastSpellIcon = nil
	--detecting Aimed Shot
	if GetSpellName(spellID, spellTab) == "Aimed Shot" then
		Punsch_Castbar_CastAimedShot()
	end

	e.OriginalCastSpell(spellID, spellTab)
end

function Punsch_Castbar_HookCastSpellByName(spellName)
	local e = PunschEntities["Castbar"]
	--e.LastSpellDropOnLoseIsCurrentAction = nil
	--e.LastSpellSetOnLoseIsTargeting = nil
	--e.LastSpellLocalCast = nil
	--e.LastSpellIcon = nil
	--detecting Aimed Shot
	if spellName == "Aimed Shot" then
		Punsch_Castbar_CastAimedShot()
	end

	e.OriginalCastSpellByName(spellName)
end

function Punsch_Castbar_CastAimedShot()
	local e = PunschEntities["Castbar"]
	if not e.isCasting then
		local AimedCastTime = 3000/e.HasteFromBerserking/e.HasteFromQuickShots/e.HasteFromKiss/e.HasteFromRapid
		Punsch_Castbar_OnCastStart("Aimed Shot",AimedCastTime)
	end
end


function Punsch_Castbar_GetLastSpellInfo() 
	local e = PunschEntities["Castbar"]
	if e.LastSpellLocalCast then
		local lag = GetTime() - e.LastSpellLocalCast
		local icon = e.LastSpellIcon
		e.LastSpellLocalCast = nil
		e.LastSpellIcon = nil
		e.LastSpellDropOnLoseIsCurrentAction = nil
		e.LastSpellSetOnLoseIsTargeting = nil
		return lag, icon
	end
end

function Punsch_Castbar_OnUpdate()
	local e = PunschEntities["Castbar"]
	if e.LastSpellDropOnLoseIsCurrentAction then 
		if not IsCurrentAction(e.LastUseActionSlot) then
			e.LastSpellLocalCast = nil
			e.LastSpellIcon = nil
			e.LastSpellDropOnLoseIsCurrentAction = nil
		end
	elseif e.LastSpellSetOnLoseIsTargeting  then
		if not SpellIsTargeting() then
			e.LastSpellLocalCast = GetTime()
			e.LastSpellSetOnLoseIsTargeting = nil
			e.LastSpellDropOnLoseIsCurrentAction = true -- drop next frame unless spell has been locally cast by then.
		end
	end

	if e.isFading == true then
		if e.holdTime > 0 then
			e.holdTime = e.holdTime-arg1
			if e.holdTime < 0 then
				e.fadeTimeleft = e.fadeTimeleft + e.holdTime
			end
		else
			e.fadeTimeleft = e.fadeTimeleft-arg1
		end
		if e.fadeTimeleft <=0 then
			Punsch_Bar_FadeStop(e)
			if not e.AlwaysShow then e.ContentFrame:Hide(); end
		else
			e.ContentFrame:SetAlpha(1- (e.fadeTime - e.fadeTimeleft) / e.fadeTime)
		end
	end

	if not e.isCasting == true then return end
	local time = GetTime()
	if e.isChannel == true then
		if e.channelDelayToDuration then
			Punsch_Bar_SetPercent(e,0,((e.endTime - time)/e.duration));
		else
			Punsch_Bar_SetPercent(e,-1*(e.delayedBy/e.duration),((e.endTime - time)/e.duration));
		end
		--gradually hide ticks
		for i=1,e.TicksShown do
			if e.TickIndicators[i].texture:GetLeft() > e.selfFill:GetRight() then	--ERROR HERE
				e.TickIndicators[i].texture:Hide()
			elseif e.TickIndicators[i].texture:GetRight() > e.selfFill:GetRight() then
				local w = e.TickIndicators[i].texture:GetWidth() -(e.TickIndicators[i].texture:GetRight() - e.selfFill:GetRight())
				e.TickIndicators[i].texture:SetWidth(w)
				e.TickIndicators[i].texture:SetTexCoord(
					e.TickIndicators[i].ltc,
					((e.endTime - time)/e.duration),
					e.TickTop,
					e.TickBot)
			end
		end

		if e.delayedBy < 0 then
			e.text3:SetText(string.format("%." .. e.decimals .. "f",e.delayedBy))
		end
	else
		Punsch_Bar_SetPercent(e,0,1-((e.endTime - time)/e.duration));
		if e.delayedBy > 0 then
			e.text3:SetText("+" .. string.format("%." .. e.decimals .. "f",e.delayedBy))
		end
	end

	local t = e.endTime - time;
	if t < 0 then t = 0 end

	if (e.isChannel and e.CountUpOnChannel) or (not e.isChannel and e.CountUpOnCast) then
		e.text2:SetText(string.format("%." .. e.decimals .. "f",e.duration-t) .. e.DurationTextSpacing .. "/" .. e.DurationTextSpacing .. string.format("%." .. e.decimals .. "f",e.duration));
	else
		e.text2:SetText(string.format("%." .. e.decimals .. "f",t) .. e.DurationTextSpacing .."/" .. e.DurationTextSpacing .. string.format("%." .. e.decimals .. "f",e.duration));
	end
end

function Punsch_Castbar_OnChannelStart(name,duration)
	local e = PunschEntities["Castbar"]
	Punsch_Bar_FadeStop(e)
	e.isCasting = true;
	e.isChannel = true;
	e.spellName = name;
	e.duration = duration/1000;
	e.startTime = GetTime();
	e.delayedBy = 0;
	e.endTime = e.startTime + e.duration;
	e.selfFill:SetWidth(e.self:GetWidth());
	e.selfFill:SetPoint("TOPLEFT",e.self);
	e.selfFill:SetVertexColor(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.r,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.g,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.b,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.a)
	e.selfFillShown = true;
	e.selfFill:Show();
	if e.ShowSpark then e.spark:Show() end

	e.lag, e.icontexture = Punsch_Castbar_GetLastSpellInfo() 
	if e.lag and e.ShowLag then
		if e.lag < 0.001 then
			e.lagBG:Hide()
		else
			e.lagBG:ClearAllPoints()
			e.lagBG:SetPoint("BOTTOM",e.ContentFrame)
			e.lagBG:SetPoint("TOPLEFT",e.ContentFrame)
			local lagpct = e.lag/e.duration
			if lagpct > 1 then lagpct = 1 end
			
			e.lagBG:SetWidth(lagpct * e.self:GetWidth())
			e.lagBG:SetTexCoord(0,e.lag/e.duration,0,1)
			e.lagBG:Show()
		end

		e.lagtxt:SetText(string.format("%.0f",e.lag*1000) .. "ms")
		e.lagtxt:ClearAllPoints()
		e.lagtxt:SetPoint("BOTTOMLEFT",e.lagBG,"BOTTOMLEFT")
		e.lagtxt:Show()
	else
		e.lagBG:Hide()
		e.lagtxt:Hide()
	end

	--setting icon, getting name from icon
	if e.icontexture then
		if e.ShowIcon then e.icon:SetTexture(e.icontexture) end
		if e.spellName == "Channeling" then
			--try to find a class specific channel
			local _,class = UnitClass("player")
			if Punsch_Tables_KnownChannels.ByIcon[class] then
				local getname = Punsch_Tables_KnownChannels.ByIcon[class][e.icontexture]
				if getname then e.spellName = getname end
			end
			--if its stil channeling, check shared list
			if e.spellName == "Channeling" then				
				local getname = Punsch_Tables_KnownChannels.ByIcon["SHARED"][e.icontexture]
				if getname then e.spellName = getname end
			end
		end
	elseif e.spellName and Punsch_Tables_KnownChannels.ByName[e.spellName] and Punsch_Tables_KnownChannels.ByName[e.spellName]["Icon"] then
		if e.ShowIcon then e.icon:SetTexture(Punsch_Tables_KnownChannels.ByName[e.spellName]["Icon"]) end
	else
		if e.ShowIcon then e.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark") end
	end

	for i=1,e.TicksShown do 
		e.TickIndicators[i].texture:Hide()
	end
	e.TicksShown = 0

	if e.spellName ~= "Channeling" and e.TickEnable then
		local tickinfo = Punsch_Tables_KnownChannels.ByName[e.spellName]
		if tickinfo then
			if tickinfo.Tick == "time" then
				if e.spellName == "Arcane Missiles" and duration == 3000 then
					tickinfo.TickCount = 3
				elseif e.spellName == "Arcane Missiles" and duration == 4000 then
					tickinfo.TickCount = 4
				end
				e.TicksShown = tickinfo.TickCount
				for i=1,tickinfo.TickCount do 
					if i == tickinfo.TickCount then
						e.TickIndicators[i].texture:SetPoint("LEFT",e.self)
						e.TickIndicators[i].texture:SetWidth(e.TickWidth/2)
					else
						e.TickIndicators[i].texture:SetPoint("LEFT",e.self,"RIGHT",(-i*(e.self:GetWidth()/(tickinfo.TickCount)))-(e.TickWidth/2),0)
						e.TickIndicators[i].texture:SetWidth(e.TickWidth)
					end
					e.TickIndicators[i].ltc = ((tickinfo.TickCount-i)/tickinfo.TickCount)-(e.TickWidth/2)/e.self:GetWidth()
					e.TickIndicators[i].texture:SetTexCoord(
						e.TickIndicators[i].ltc,
						((tickinfo.TickCount-i)/tickinfo.TickCount)+(e.TickWidth/2)/e.self:GetWidth(),
						e.TickTop,
						e.TickBot)
					e.TickIndicators[i].texture:Show()
				end
			elseif tickinfo.Tick == "mana" then

			end
		end
	end

	e.icontexture = nil
	e.text1:SetText(e.spellName);
	e.text2:SetText(0.0 .."/" .. e.duration, 1);
	e.text3:SetText("")
	e.ContentFrame:Show();
end

function Punsch_Castbar_OnChannelStop()
	local e = PunschEntities["Castbar"]
	if e.isCasting == true and e.isChannel == true then
		e.isCasting = false;
		if not e.AlwaysShow then e.ContentFrame:Hide(); end
	end
end

function Punsch_Castbar_OnChannelUpdate(duration)
	local e = PunschEntities["Castbar"]
	local newEndTime = GetTime() + duration/1000
	if e.channelDelayToDuration then
		if e.TickEnable then
			for i=1,e.TicksShown do 
				--move the ticks:
				e.TickIndicators[i].texture:SetPoint("LEFT",UIParent,"LEFT",e.TickIndicators[i].texture:GetLeft()-(e.self:GetWidth()*((e.endTime- newEndTime)/e.duration )),0)
				--hide ticks outside of the castbar
				if e.TickIndicators[i].texture:GetRight()<e.self:GetLeft() then
					e.TickIndicators[i].texture:Hide()
				end

			end
		end
		e.delayedBy = e.delayedBy + (newEndTime - e.endTime) 
		e.endTime = newEndTime;
	else
		e.delayedBy = newEndTime - e.endTime
		e.selfFill:SetPoint("TOPLEFT",e.self,"TOPLEFT",-(e.delayedBy/e.duration)*e.self:GetWidth(),0);
		--potentially indicate lost channelticks here

	end
end

function Punsch_Castbar_OnCastDelayed(duration)
	local e = PunschEntities["Castbar"]
	e.delayedBy = e.delayedBy + duration/1000;
	e.endTime = e.endTime + duration/1000;
end

function Punsch_Castbar_OnCastInterrupted()
	if PunschEntities["Castbar"].isCasting then
		PunschEntities["Castbar"].isCasting = false;
		if PunschEntities["Castbar"].PlayerInterruptAsFailure then
			Punsch_Castbar_StartFade(false) 
		else
			Punsch_Castbar_StartFade(true)
		end
	end
end

function Punsch_Castbar_OnCastFailed()
	local e = PunschEntities["Castbar"]
	if e.isChannel ~= true then
		e.isCasting = false;
		if e.spellName == "Aimed Shot" and e.startTime - GetTime() < 0.08 then
			if not e.isFading then
				e.ContentFrame:Hide()
			end
		else
			Punsch_Castbar_StartFade(false)
		end
	end
end

function Punsch_Castbar_OnCastStart(name,duration)
	local e = PunschEntities["Castbar"]
	Punsch_Bar_FadeStop(e)
	e.isCasting = true;
	e.isChannel = false;
	e.spellName = name;
	e.duration = duration/1000;
	e.delayedBy = 0;
	e.startTime = GetTime();
	e.endTime = e.startTime + e.duration;
	e.selfFill:SetPoint("TOPLEFT",e.self);
	e.selfFill:SetVertexColor(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.r,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.g,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.b,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.a)
	e.selfFill:Hide();
	e.selfFillShown = false;
	e.text1:SetText(name);
	e.text2:SetText(0.0 .."/" .. e.duration, 1);
	e.text3:SetText("")

	--tradeskills. add merging tradeskills here, but thats a bunch of work
	if e.spellName == e.LastTradeskillName then
		e.icontexture = e.LastTradeskillIcon
		e.lag = nil
	--[[
		e.LastTradeskillName
		e.LastTradeskillIcon
		e.LastTradeskillRepeatTimes
		e.LastTradeskillRepeatedTimes --starts at 0
	--]]
	elseif e.spellName == "Aimed Shot" then
		e.icontexture = "Interface\\Icons\\INV_Spear_07"
		e.lag = nil
	else
		e.lag, e.icontexture = Punsch_Castbar_GetLastSpellInfo() 
	end

	if e.lag and e.ShowLag then
		--DEFAULT_CHAT_FRAME:AddMessage("lag: " .. e.lag .. "dur:" .. e.duration .. "q" ..);
		e.lagBG:ClearAllPoints()
		e.lagBG:SetPoint("BOTTOMRIGHT",e.ContentFrame)
		e.lagBG:SetPoint("TOP",e.ContentFrame)
		if e.lag >= e.duration then
			e.lagBG:SetWidth(e.self:GetWidth())
			e.lagBG:SetTexCoord(0,1,0,1)
		else
			e.lagBG:SetWidth(e.lag/e.duration*e.self:GetWidth())
			e.lagBG:SetTexCoord(1-e.lag/e.duration,1,0,1)
		end
		if e.lag <= 0.01 then 
			e.lagBG:Hide()
		else
			e.lagBG:Show()
		end

		e.lagtxt:SetText(string.format("%.0f",e.lag*1000) .. "ms")
		e.lagtxt:ClearAllPoints()
		e.lagtxt:SetPoint("BOTTOMRIGHT",e.lagBG,"BOTTOMRIGHT")
		e.lagtxt:Show()
	else
		e.lagBG:Hide()
		e.lagtxt:Hide()
	end

	for i=1,e.TicksShown do 
		e.TickIndicators[i].texture:Hide()
	end
	e.TicksShown = 0

	if e.icontexture then
		if e.ShowIcon then e.icon:SetTexture(e.icontexture) end
		e.icontexture = nil
	else
		if e.ShowIcon then 
			--do table lookup HERE of known world objects.
			e.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark") 
		end
	end

	e.ContentFrame:Show();
end

function Punsch_Castbar_OnCastStop()
	local e = PunschEntities["Castbar"]
	if e.isCasting == true and not e.isChannel == true then
		Punsch_Castbar_StartFade(true) 
		e.isCasting = false;
	end
end

function Punsch_Castbar_StartFade(successful) 
	local e = PunschEntities["Castbar"]

	if not e.fadeEnable then 
		if not e.AlwaysShow then e.ContentFrame:Hide(); end
		return 
	end
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade
	if successful == true and e.endTime - GetTime() < tonumber(e.fadeTolerance) then
		e.selfFill:SetVertexColor(db.Success.r,
		db.Success.g,
		db.Success.b,
		db.Success.a)
		if not e.isFading then
			e.holdTime = e.fadesht
		end
	else
		e.selfFill:SetVertexColor(db.Failure.r,
		db.Failure.g,
		db.Failure.b,
		db.Failure.a)
		if not e.isFading then
			e.holdTime = e.fadefht
		else
			e.holdTime = e.fadefht - (e.fadesht - e.holdTime)
		end
	end

	if not e.isFading then
		e.isFading = true;
		if e.fadeTime == 0 then
			e.fadeTimeLeft = 0.01
		else
			e.fadeTimeleft = e.fadeTime;
		end
		Punsch_Bar_SetPercent(e,0,1)
		if e.ShowSpark then e.spark:Hide() end
	end
end

--[[
	_, tmp = UnitStat("player", 4)
	TheoryCraft_Data.Stats["intellect"] = tmp
	_, tmp = UnitStat("player", 5)
	TheoryCraft_Data.Stats["spirit"] = tmp


	if class == "MAGE" then
		TheoryCraft_Data.Stats["regenfromspirit"] = TheoryCraft_Data.Stats["spirit"]/8+6.25
		

	local manaregen = TheoryCraft_GetStat("manaperfive")/5
	manaregen = manaregen+TheoryCraft_Data.Stats["totalmana"]*TheoryCraft_GetStat("FelEnergy")/4
	TheoryCraft_Data.Stats["regen"] = manaregen+TheoryCraft_Data.Stats["regenfromspirit"]
	TheoryCraft_Data.Stats["icregen"] = manaregen+(TheoryCraft_Data.Stats["regenfromspirit"])*TheoryCraft_GetStat("ICPercent")
 	if (class == "MAGE") then
		TheoryCraft_Data.Stats["maxtotalmana"] = TheoryCraft_Data.Stats["totalmana"]+TheoryCraft_Data.Stats["regenfromspirit"]*15*8+1100+manaregen*8
	end
	if (class == "WARLOCK") then
		getlifetap(TheoryCraft_Data.Stats)
	end

		--]]

