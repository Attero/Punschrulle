--default DB entry for Entity and Bar

function Punsch_SwingTimer_Create()
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"]
	PunschEntities["SwingTimer"] = {}
	local e = PunschEntities["SwingTimer"]
	e.Type = "SwingTimer"
	Punsch_Bar_Create(e,db)
	e.text1:SetText("MainHand/ranged")
	e.Offhand = {}
	e.Offhand.Type = "SwingTimerOH"
	Punsch_Bar_Create(e.Offhand,db)
	e.Offhand.text1:SetText("Offhand")


	e.self:SetScript("OnEvent",Punsch_SwingTimer_OnEvent)
	e.self:SetScript("OnUpdate",Punsch_SwingTimer_OnUpdate)

	--register relevant events here. example:
	--e.self:RegisterEvent("MIRROR_TIMER_START")

end

--updates the bars to the current state of the db
function Punsch_SwingTimer_Update(e)
	local db = PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"]

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

	e.fadeHoldTime = db.Fade.HoldTime

	Punsch_Bar_Update(e,db)

	Punsch_Entity_Update(e.Offhand,db)
	Punsch_Bar_Update(e.Offhand,db)

	e.Offhand.self:SetPoint("TOP",
				e.self,
				"Bottom",
				0,
				-1)	--padding. potentially add an option for this
end

local debugSwingTimer = nil
function Punsch_SwingTimer_OnEvent()
	--parse events here
    if (event == "MIRROR_TIMER_START") then
    	--examplefunction
    		--onMirrorTimerStart()

    end
end

function Punsch_SwingTimer_StartFade(e) 
	if not e.isFading then
		e.isFading = true
		e.holdTime = PunschEntities["SwingTimer"].fadeHoldTime
		if e.fadeTime == 0 then
			e.fadeTimeLeft = 0.01
		else
			e.fadeTimeleft = e.fadeTime
		end
		Punsch_Bar_SetPercent(e,0,1)
		if e.ShowSpark then e.spark:Hide() end
	end
end

function Punsch_SwingTimer_OnUpdate()
	--arg1 = time elapsed in seconds since last OnUpdate.
	--code that runs every frame. Example:
	local e = PunschEntities["SwingTimer"]
	--Punsch_Bar_SetPercent(e,0,0.5) -- sets bar to show like this: [XXXXX     ] i.e filled between 0% and 50%
	Punsch_Bar_SetPercent(e,0,arg1)	--Very primitive fpsmeter xd
end
