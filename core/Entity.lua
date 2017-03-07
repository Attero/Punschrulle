PunschEntities = {}

function Punsch_Entity_Create(e,db)
	e.self = CreateFrame("Frame","Punschrulle" .. e.Type,UIParent)
	e.self:SetFrameStrata("HIGH")

	e.ContentFrame = CreateFrame("Frame",nil,e.self)
	e.ContentFrame:SetAllPoints(e.self)

	e.BorderFrame = CreateFrame("Frame",nil,e.ContentFrame)

	e.selfBG = e.ContentFrame:CreateTexture(nil,"BACKGROUND")
	e.selfBG:SetAllPoints(e.self)

	e.selfFill = e.ContentFrame:CreateTexture(nil,"BORDER")
	e.selfFill:SetPoint("TOPLEFT", e.self)
	e.selfFill:SetHeight(db.Height)

	e.self:SetPoint(db.Anchor.Point,UIParent,db.Anchor.rPoint,db.Anchor.X,db.Anchor.Y)
end

function Punsch_Entity_UpdateAll() 
	for _,e in pairs(PunschEntities) do
		Punsch_Entity_Update(e,PunschrulleDB.Profiles[PunschrulleProfile]["Entities"][e.Type])
	end
end

function Punsch_Entity_Update(e,db) 
	e.self:ClearAllPoints()

	e.self:SetWidth(db.Width)
	e.self:SetHeight(db.Height)
	e.selfFill:SetHeight(db.Height)
	e.selfBG:SetTexture(db.Bg.r,
		db.Bg.g,
		db.Bg.b,
		db.Bg.a)
	e.selfFill:SetTexture(Punschrulle_GetTexture(db.Texture))
	if db.Fill then
		e.selfFill:SetVertexColor(db.Fill.r,
			db.Fill.g,
			db.Fill.b,
			db.Fill.a)
	end

	if db.Border.Show then
		e.BorderFrame:SetPoint("TOPLEFT",e.ContentFrame,"TOPLEFT",-db.Border.Padding,db.Border.Padding)
		e.BorderFrame:SetPoint("BOTTOMRIGHT",e.ContentFrame,"BOTTOMRIGHT",db.Border.Padding,-db.Border.Padding)
		e.BorderFrame:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = db.Border.Size})
		e.BorderFrame:SetBackdropBorderColor(db.Border.r, db.Border.g, db.Border.b, db.Border.a)
		if db.Border.OnTop then
			e.BorderFrame:SetFrameStrata("DIALOG")
		else
			e.BorderFrame:SetFrameStrata("MEDIUM")
		end
	else
		e.BorderFrame:SetBackdrop(nil)
	end

	if e.Type == "Castbar" then
		Punsch_Castbar_Update(e)
	elseif e.Type == "Mirror" then
		Punsch_Mirror_UpdateMirrors(e)
	elseif e.Type == "ECB" then
		Punsch_ECB_UpdateECBs(e)
	end
end


function Punsch_Entity_CreateUnlock(e)
	e.UnlockFrame = CreateFrame("Frame",nil,e.self)
	e.UnlockFrame:SetFrameStrata("DIALOG")
	e.UnlockFrame:SetAllPoints(e.self)
	--e.UnlockFrame.parent = e

	e.unlockBG = e.UnlockFrame:CreateTexture(nil,"ARTWORK")
	e.unlockBG:SetAllPoints(e.UnlockFrame)
	e.unlockBG:SetTexture(0.1,1,0.3,0.4)

	e.unlockText = e.UnlockFrame:CreateFontString(nil,"OVERLAY")
	e.unlockText:SetFont(GameFontHighlight:GetFont(), 10)
	e.unlockText:SetText(e.Type)
	e.unlockText:SetPoint("CENTER", e.UnlockFrame)

	e.UnlockFrame:SetScript("OnMouseDown", Punsch_Entity_Startmove)
	e.UnlockFrame:SetScript("OnMouseUp", Punsch_Entity_Stopmove)
	e.UnlockFrame:SetScript("OnHide", Punsch_Entity_Stopmove)
end

function Punsch_Entity_Startmove()
	this:GetParent().IsMovingOrSizing = 1
	this:GetParent():StartMoving()
end

function Punsch_Entity_GetRelativePoint(e,point,relativeTo,relativePoint)
	local x1,y1 = Punsch_Entity_GetPoint(e,point)
	local x2,y2 = Punsch_Entity_GetPoint(relativeTo,relativePoint)
	return x1-x2,y1-y2
end

function Punsch_Entity_GetPoint(e,point)
	if point == "TOP" then
		local x = e:GetCenter()
		return x, e:GetTop()
	elseif point == "RIGHT" then
		local _,y = e:GetCenter()
		return e:GetRight(), y
	elseif point == "BOTTOM" then
		local x = e:GetCenter()
		return x, e:GetBottom()
	elseif point == "LEFT" then
		local _,y = e:GetCenter()
		return e:GetLeft(), y
	elseif point == "TOPLEFT" then
		return e:GetLeft(), e:GetTop()
	elseif point == "TOPRIGHT" then
		return e:GetRight(),e:GetTop()
	elseif point == "BOTTOMRIGHT" then
		return e:GetRight(),e:GetBottom()
	elseif point == "BOTTOMLEFT" then
		return e:GetLeft(),e:GetBottom()
	elseif point == "CENTER" then
		return e:GetCenter()
	end
end

function Punsch_Entity_UpdateToNewAnchor(e,db)
	local rTo
	if db.Anchor.rTo == "Castbar" then
		rTo = PunschEntities["Castbar"].self
	else
		rTo = UIParent
	end
	db.Anchor.X,db.Anchor.Y = Punsch_Entity_GetRelativePoint(
		e.self,
		db.Anchor.Point,
		rTo,
		db.Anchor.rPoint)

	if rTo == UIParent and e.isBar and e.ShowIcon then
		db.Anchor.X = db.Anchor.X - db.Height
	end
end

function Punsch_Entity_Stopmove()
	--save position here
	if this:GetParent().IsMovingOrSizing then
		this:GetParent():StopMovingOrSizing()
		local entityname = strsub(this:GetParent():GetName(), 12)
		Punsch_Entity_UpdateToNewAnchor(PunschEntities[entityname],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"][entityname])
		this:GetParent().IsMovingOrSizing = nil
		Punsch_Options_EditFrame_UpdateAll()
	end
end

Punsch_Entity_Locked = true
function Punsch_Entity_ToggleLock()
	if Punsch_Entity_Locked then
		Punsch_Entity_Locked = false
		Punsch_Entity_UnlockAll()
	else
		Punsch_Entity_Locked = true
		Punsch_Entity_LockAll()
	end
end

function Punsch_Entity_UnlockAll()
	for _,e in pairs(PunschEntities) do
		if not e.UnlockFrame then Punsch_Entity_CreateUnlock(e) end
		e.UnlockFrame:Show()
		e.self:SetMovable(true)
		e.UnlockFrame:EnableMouse(true)
	end
end

function Punsch_Entity_LockAll()
	for _,e in pairs(PunschEntities) do
		if not e.UnlockFrame then Punsch_Entity_CreateUnlock(e) end
		e.UnlockFrame:Hide()
		e.self:SetMovable(false)
		e.UnlockFrame:EnableMouse(false)
	end
end
