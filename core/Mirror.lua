PunschMirrors = {}
PunschMirrorCount = 3
PunschMirrorEvents = {}
function Punsch_Mirror_Create()
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]
	PunschEntities["Mirror"] = {}
	local e = PunschEntities["Mirror"]
	PunschMirrors[0] = e
	e.Type = "Mirror";
	Punsch_Bar_Create(e,db)

	for i=1,PunschMirrorCount do 
		PunschMirrors[i] = {}
		PunschMirrors[i].Type = "Mirror" .. i;
		Punsch_Bar_Create(PunschMirrors[i],db)
	end

	e.self:SetScript("OnEvent",Punsch_Mirror_OnEvent)
	e.self:SetScript("OnUpdate",Punsch_Mirror_OnUpdate)

	e.self:RegisterEvent("MIRROR_TIMER_START")
	e.self:RegisterEvent("MIRROR_TIMER_PAUSE")
	e.self:RegisterEvent("MIRROR_TIMER_STOP")

	e.self:RegisterEvent("PLAYER_CAMPING");
	e.self:RegisterEvent("PLAYER_QUITING");

	--e.self:RegisterEvent("LOGOUT_CANCEL");
	--doesnt seem to fire, workaround below
	local oldOnHide = StaticPopupDialogs["CAMP"].OnHide
	StaticPopupDialogs["CAMP"].OnHide = function ()
		Punsch_Mirror_OnEventStop(PunschMirrorEvents["CAMP"])
		oldOnHide()
	end
	local oldOnHide = StaticPopupDialogs["QUIT"].OnHide
	StaticPopupDialogs["QUIT"].OnHide = function ()
		Punsch_Mirror_OnEventStop(PunschMirrorEvents["QUIT"])
		oldOnHide()
	end

	e.self:RegisterEvent("INSTANCE_BOOT_START");
	e.self:RegisterEvent("INSTANCE_BOOT_STOP");

	e.self:RegisterEvent("CONFIRM_SUMMON");
	e.self:RegisterEvent("CANCEL_SUMMON");

	--hooks confirming summons
	local oldOnAccept = StaticPopupDialogs["CONFIRM_SUMMON"].OnAccept
	StaticPopupDialogs["CONFIRM_SUMMON"].OnAccept = function ()
		Punsch_Mirror_OnEventStop(PunschMirrorEvents["SUMMON"])
		oldOnAccept()
	end


	--[[ FURTHER things to implement.

	 restimer
	this:RegisterEvent("PLAYER_DEAD");
	this:RegisterEvent("PLAYER_ALIVE");
	this:RegisterEvent("PLAYER_UNGHOST");
	this:RegisterEvent("RESURRECT_REQUEST");

		if ( event == "RESURRECT_REQUEST" ) then
		if ( ResurrectHasSickness() ) then
			StaticPopup_Show("RESURRECT", arg1);
		else
			StaticPopup_Show("RESURRECT_NO_SICKNESS", arg1);
	

	dueloutofbounds
	this:RegisterEvent("DUEL_REQUESTED");
	this:RegisterEvent("DUEL_OUTOFBOUNDS");
	this:RegisterEvent("DUEL_INBOUNDS");
	this:RegisterEvent("DUEL_FINISHED");
	--DUEL_OUTOFBOUNDS timer is static 10

	flightpaths
	this:RegisterEvent("PLAYER_CONTROL_LOST");
	this:RegisterEvent("PLAYER_CONTROL_GAINED");
	if ( UnitOnTaxi("player") ) then
		return;
	end
	--]]
end

--updates the bars to the current state of the db
function Punsch_Mirror_UpdateMirrors(e)
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]
	Punsch_Bar_Update(e,db)

	if db.HideBlizzardBar then
		UIParent:UnregisterEvent("MIRROR_TIMER_START")
	else
		UIParent:RegisterEvent("MIRROR_TIMER_START")
	end

	if db.Anchor.rTo == "Castbar" then
		e.self:SetPoint(db.Anchor.Point,
			PunschEntities["Castbar"].self,
			db.Anchor.rPoint,
			db.Anchor.X,
			db.Anchor.Y)
	elseif e.ShowIcon then
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

	e.fadeHoldTime = db.Fade.HoldTime;

	e.GrowUp = db.GrowUp

	for i=1,PunschMirrorCount do 
		Punsch_Entity_Update(PunschMirrors[i],db)
		Punsch_Bar_Update(PunschMirrors[i],db)

		if e.GrowUp then
			PunschMirrors[i].self:SetPoint("TOPLEFT",
				e.self,
				"TOPLEFT",
				0,
				(i)*(db.Height+db.Padding))
		else
			PunschMirrors[i].self:SetPoint("TOPLEFT",
				e.self,
				"TOPLEFT",
				0,
				-((i)*(db.Height+db.Padding)))
		end
	end
end

local debugMirror = nil
function Punsch_Mirror_OnEvent()
    if (event == "MIRROR_TIMER_START") then
    	--arg1 name, "BREATH", "EXHAUSTION" or "FEIGNDEATH"
    	--arg2 Current value of timer
    	--arg3 Maximum value of timer
    	--arg4 step. (how much it moves per second)
    	--arg5 pause 1/0
    	--arg6 label
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage("MIRROR_TIMER_START " .. arg1 .. "," .. arg2 .. "," .. arg3 .. "," .. arg4 .. "," .. arg5 .. "," .. arg6) end
    	if not PunschMirrorEvents[arg1] then
    		PunschMirrorEvents[arg1] = {}
    		PunschMirrorEvents[arg1].name = arg1
    		PunschMirrorEvents[arg1].label = arg6
    	end
    	PunschMirrorEvents[arg1].value = arg2
    	PunschMirrorEvents[arg1].max = arg3
    	PunschMirrorEvents[arg1].step = arg4
    	PunschMirrorEvents[arg1].pause = arg5
    	Punsch_Mirror_AssignFirstUnassignedEvent(PunschMirrorEvents[arg1])
    elseif (event == "MIRROR_TIMER_PAUSE") then
    	--arg1 duration to pause for
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage("MIRROR_TIMER_PAUSE " .. arg1) end
    	DEFAULT_CHAT_FRAME:AddMessage(" MIRROR_TIMER_PAUSE fired, arg1: " .. arg1) 
    elseif (event == "MIRROR_TIMER_STOP") then
    	--arg1 name of mirror to stop
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage("MIRROR_TIMER_STOP " .. arg1) end
    	Punsch_Mirror_OnEventStop(PunschMirrorEvents[arg1])
    elseif (event == "PLAYER_CAMPING") then
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
    	if not PunschMirrorEvents["CAMP"] then
    		PunschMirrorEvents["CAMP"] = {}
    		PunschMirrorEvents["CAMP"].name = "CAMP"
    		PunschMirrorEvents["CAMP"].label = "Logout"
    	end
    	PunschMirrorEvents["CAMP"].value = 20 * 1000
    	PunschMirrorEvents["CAMP"].max = 20 * 1000
    	PunschMirrorEvents["CAMP"].step = -1
    	Punsch_Mirror_AssignFirstUnassignedEvent(PunschMirrorEvents["CAMP"])
    elseif (event == "PLAYER_QUITING") then
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
    	if not PunschMirrorEvents["QUIT"] then
    		PunschMirrorEvents["QUIT"] = {}
    		PunschMirrorEvents["QUIT"].name = "QUIT"
    		PunschMirrorEvents["QUIT"].label = "Quit Game"
    	end
    	PunschMirrorEvents["QUIT"].value = 20 * 1000
    	PunschMirrorEvents["QUIT"].max = 20 * 1000
    	PunschMirrorEvents["QUIT"].step = -1
    	Punsch_Mirror_AssignFirstUnassignedEvent(PunschMirrorEvents["QUIT"])
    elseif (event == "INSTANCE_BOOT_START") then
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
    	if not PunschMirrorEvents["BOOT"] then
    		PunschMirrorEvents["BOOT"] = {}
    		PunschMirrorEvents["BOOT"].name = "INSTANCE_BOOT"
    		PunschMirrorEvents["BOOT"].label = "Instance Boot"
    	end
    	PunschMirrorEvents["BOOT"].value = GetInstanceBootTimeRemaining() * 1000
    	PunschMirrorEvents["BOOT"].max = GetInstanceBootTimeRemaining() * 1000
    	PunschMirrorEvents["BOOT"].step = -1
    	Punsch_Mirror_AssignFirstUnassignedEvent(PunschMirrorEvents["BOOT"])
   	elseif (event == "INSTANCE_BOOT_STOP") then
   		if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
   		Punsch_Mirror_OnEventStop(PunschMirrorEvents["BOOT"])
    elseif (event == "CONFIRM_SUMMON") then
    	if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
    	if not PunschMirrorEvents["SUMMON"] then
    		PunschMirrorEvents["SUMMON"] = {}
    		PunschMirrorEvents["SUMMON"].name = "SUMMON"
    		PunschMirrorEvents["SUMMON"].label = "Summon"
    	end
    	PunschMirrorEvents["SUMMON"].value = 0
    	PunschMirrorEvents["SUMMON"].max = GetSummonConfirmTimeLeft() * 1000
    	PunschMirrorEvents["SUMMON"].step = 1
    	Punsch_Mirror_AssignFirstUnassignedEvent(PunschMirrorEvents["SUMMON"])
   	elseif (event == "CANCEL_SUMMON") then
   		if debugMirror then DEFAULT_CHAT_FRAME:AddMessage(event) end
   		Punsch_Mirror_OnEventStop(PunschMirrorEvents["SUMMON"])
   	else
   		DEFAULT_CHAT_FRAME:AddMessage("UNHANDLED EVENT: " ..event)
    end
end

--[[
Punsch_Mirror_HooksStaticPaneClosing = {}
function Punsch_Mirror_HookStaticPaneClosing(pane,event)
	local p = StaticPopup_FindVisible(pane)
	local oldOnHide = p:GetScript("OnHide")
	p:SetScript("OnHide",function ()
		Punsch_Mirror_OnEventStop(PunschMirrorEvents["QUIT"])
		oldOnHide()
	end)

end--]]

function Punsch_Mirror_AssignFirstUnassignedEvent(event)
	for i=0,PunschMirrorCount do 
		if not PunschMirrors[i].event or PunschMirrors[i].event == event then
			Punsch_Mirror_AssignEvent(PunschMirrors[i], event)
			break
		end
	end
end

function Punsch_Mirror_AssignEvent(e,event)
	e.event = event
	if event then
		Punsch_Bar_FadeStop(e)
		e.selfFill:SetVertexColor(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][event.name].r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][event.name].g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][event.name].b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][event.name].a)
		e.icon:SetTexture(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][event.name].icon)
		e.text1:SetText(event.label)
		if PunschEntities["Mirror"].ShowSpark then e.spark:Show() end
		e.ContentFrame:Show();
	else
		if not PunschEntities["Mirror"].AlwaysShow then e.ContentFrame:Hide() end
	end
end

function Punsch_Mirror_UnAssignEvent(event)
	if not event then return end
	local eventFound = false
	for i=0,PunschMirrorCount do 
		if PunschMirrors[i].event == event and not eventFound then
			eventFound = true
		end
		if eventFound then
			if i<PunschMirrorCount then
				Punsch_Mirror_AssignEvent(PunschMirrors[i], PunschMirrors[i+1].event)
			else
				PunschMirrors[i].event = nil
			end
		end
	end
end

function Punsch_Mirror_OnEventStop(event)
	if PunschEntities["Mirror"].fadeEnable then
		for i=0,PunschMirrorCount do 
			if PunschMirrors[i].event == event then
				Punsch_Mirror_StartFade(PunschMirrors[i])
				break
			end
		end
	else
		Punsch_Mirror_UnAssignEvent(event)
	end
end

function Punsch_Mirror_StartFade(e) 
	if not e.isFading then
		e.isFading = true;
		e.holdTime = PunschEntities["Mirror"].fadeHoldTime;
		if e.fadeTime == 0 then
			e.fadeTimeLeft = 0.01
		else
			e.fadeTimeleft = e.fadeTime;
		end
		Punsch_Bar_SetPercent(e,0,1)
		if e.ShowSpark then e.spark:Hide() end
	end
end

function Punsch_Mirror_OnUpdate()
	for _,e in pairs(PunschMirrors) do
		Punsch_Mirror_Update(e,arg1)
	end
end

function Punsch_Mirror_Update(e,elapsed)
	if not e.event then return end
	if e.isFading then
		if e.holdTime > 0 then
			e.holdTime = e.holdTime-elapsed
			if e.holdTime < 0 then
				e.fadeTimeleft = e.fadeTimeleft + e.holdTime
			end
		else
			e.fadeTimeleft = e.fadeTimeleft-elapsed
		end
		if e.fadeTimeleft <=0 then
			Punsch_Bar_FadeStop(e)
			if not e.AlwaysShow then e.ContentFrame:Hide(); end
			Punsch_Mirror_UnAssignEvent(e.event)
		else
			e.ContentFrame:SetAlpha(1- (e.fadeTime - e.fadeTimeleft) / e.fadeTime)
		end
	else
		e.event.value = e.event.value + elapsed*1000*e.event.step
		if e.event.value > e.event.max then e.event.value = e.event.max end
		if e.event.value < 0 then e.event.value = 0 end
		e.text2:SetText(string.format("%." .. e.decimals .. "f",e.event.value/1000)) --.."/" .. string.format("%." .. PunschEntities["Mirror"].decimals .. "f",e.event.max/1000))
		Punsch_Bar_SetPercent(e,0,e.event.value/e.event.max)
	end
end
