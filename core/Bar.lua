function Punsch_Bar_Create(e,db)
	Punsch_Entity_Create(e,db)
	e.TextFrame = CreateFrame("Frame",nil,e.ContentFrame)
	e.TextFrame:SetFrameStrata("DIALOG")
	e.TextFrame:SetAllPoints(e.ContentFrame)

	e.text1 = e.TextFrame:CreateFontString(nil,"OVERLAY")
	e.text1:SetFont(GameFontNormal:GetFont(), 10)
	e.text1:SetText("Frostbolt")

	e.text2 = e.TextFrame:CreateFontString(nil,"OVERLAY")
	e.text2:SetFont(GameFontHighlight:GetFont(), 10)
	e.text2:SetText("1.7/2.5")

	e.icon = e.TextFrame:CreateTexture()
	e.icon:SetTexture("Interface\\Icons\\Spell_Frost_FrostBolt02")
	e.icon:SetTexCoord(0.07,0.93,0.08,0.93)
	e.icon:SetPoint("TOPLEFT", e.self,"TOPLEFT",-e.self:GetHeight(),0);
	e.icon:SetWidth(e.self:GetHeight())
	e.icon:SetHeight(e.self:GetHeight())

	e.spark = e.ContentFrame:CreateTexture(nil,"OVERLAY")
	e.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	e.spark:SetBlendMode("ADD")
	e.spark:SetPoint("CENTER",e.selfFill,"RIGHT")

	e.selfBG:SetAllPoints(e.self);

	e.isBar = true
	e.selfFillShown = true;
	e.isFading = false;
end

function Punsch_Bar_Update(e,db)
	e.AlwaysShow = db.AlwaysShow
	if e.AlwaysShow then
		e.ContentFrame:Show()
	else
		e.ContentFrame:Hide()
	end

	e.decimals = db.Decimals

	e.StretchTexture = db.StretchTexture
	if e.StretchTexture then
		e.selfFill:SetTexCoord(0,1,0,1)
		e.selfBG:SetTexCoord(0,1,0,1)
	end

	e.ShowTextureOnFullBar = db.ShowTextureOnFullBar
	if e.ShowTextureOnFullBar then
		e.selfBG:SetTexture(Punschrulle_GetTexture(db.Texture))
		e.selfBG:SetVertexColor(db.Bg.r,db.Bg.g,db.Bg.b,db.Bg.a)
	end

	e.selfBG:SetTexCoord(0,1,0,1)

	e.ShowSpark = db.Spark.Enable
	if e.ShowSpark then
		e.spark:SetWidth(db.Spark.Width)
		e.spark:SetHeight(db.Spark.Height)
		e.spark:SetVertexColor(db.Spark.r,db.Spark.g,db.Spark.b,db.Spark.a)
		e.spark:Show()
	else
		e.spark:Hide()
	end

	e.ShowIcon = db.ShowIcon
	if e.ShowIcon then
		e.icon:SetAlpha(1)
		e.icon:SetPoint("TOPLEFT", e.self,"TOPLEFT",-e.self:GetHeight() -db.IconPadding,0);
		e.icon:SetWidth(e.self:GetHeight())
		e.icon:SetHeight(e.self:GetHeight())
		e.self:SetWidth(db.Width-db.Height)
	else
		e.icon:SetAlpha(0)
		e.self:SetWidth(db.Width)
	end

	e.text1:SetFont(Punschrulle_GetFont(db.TextLeft.Font), db.TextLeft.FontSize)
	e.text1:SetShadowOffset(db.TextLeft.FontShadowX,db.TextLeft.FontShadowY)
	e.text1:ClearAllPoints()
	e.text1:SetPoint(db.TextLeft.Point, e.self,db.TextLeft.rPoint,db.TextLeft.X,db.TextLeft.Y)
	e.text1:SetTextColor(db.TextLeft.r,db.TextLeft.g,db.TextLeft.b,db.TextLeft.a)
	e.text1:SetShadowColor(db.TextLeft.sr,db.TextLeft.sg,db.TextLeft.sb,db.TextLeft.sa)
	
	--needed for shadowoffset to properly update.
	local t = e.text1:GetText()
	e.text1:SetText("")
	e.text1:SetText(t)

	e.text2:SetFont(Punschrulle_GetFont(db.TextRight.Font), db.TextRight.FontSize)
	e.text2:SetShadowOffset(db.TextRight.FontShadowX,db.TextRight.FontShadowY)
	e.text2:ClearAllPoints()
	e.text2:SetPoint(db.TextRight.Point, e.self,db.TextRight.rPoint,db.TextRight.X,db.TextRight.Y)
	e.text2:SetTextColor(db.TextRight.r,db.TextRight.g,db.TextRight.b,db.TextRight.a)
	e.text2:SetShadowColor(db.TextRight.sr,db.TextRight.sg,db.TextRight.sb,db.TextRight.sa)

	--needed for shadowoffset to properly update.
	local t = e.text2:GetText()
	e.text2:SetText("")	
	e.text2:SetText(t)

	e.fadeTime = db.Fade.Time;
	e.fadeEnable = db.Fade.Enable;

	Punsch_Bar_SetPercent(e,0,0.7)
end

function Punsch_Bar_FadeStop(e) 
	if e.isFading == true then
		e.ContentFrame:SetAlpha(1)
		e.isFading = false;
	end
end

function Punsch_Bar_SetPercent(e,left,right)
	if right >= 0.01 then
		if right >=1 then right = 1 end
		if not e.selfFillShown == true then
			e.selfFill:Show();
			if e.ShowSpark then e.spark:Show() end
			e.selfFillShown = true;
		end
		e.selfFill:SetWidth(e.self:GetWidth()*(right-left));

		if not e.StretchTexture then
			e.selfFill:SetTexCoord(left,right,0,1)
		end
	else
		e.selfFill:Hide();
		if e.ShowSpark then e.spark:Hide() end
		e.selfFillShown = false;
	end
end