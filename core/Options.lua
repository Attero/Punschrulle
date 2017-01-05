PunschOptionWindow = nil
PunschEditFrames = {}

local headerFont = PunschrulleFonts["Vixar"]
local normalFont = PunschrulleFonts["SansNarrow"]
local normalSize = 12

function Punsch_Option_MainWindow_Toggle()
	if not PunschOptionWindow then
		Punsch_Option_CreateWindows()
	else
		if PunschOptionWindow.Handle:IsShown() then
			PunschOptionWindow.Handle:Hide()
		else
			if not PunschOptionWindow.Open == nil then
				PunschOptionWindow.Open.texture:SetTexture(0.70,0.70,1,1)
				PunschOptionWindow.Open = nil
			end
			PunschOptionWindow.Handle:Show()
		end
	end
end

function Punsch_Option_CreateWindows() 
	Punsch_Options_MainWindow_Create()
	Punsch_Options_EditProfile_Create() 
	Punsch_Options_EditCastbar_Create()
	Punsch_Options_EditCastbarText_Create()
	Punsch_Options_EditFading_Create()
	Punsch_Options_EditMirror_Create()
	Punsch_Options_EditMirrorText_Create() 
	Punsch_Options_EditMirrorEvents_Create()
	Punsch_Options_EditSwingTimer_Create()
	Punsch_Options_EditSwingTimerText_Create() 
	Punsch_Options_About_Create()

	--Create lock button
	local btn = CreateFrame("Button",nil,PunschOptionWindow.Handle)
	btn:SetPoint("TOPLEFT", PunschOptionWindow.selectionBG, "TOPLEFT",-101,-15*PunschOptionWindow.btnMade)
	btn:SetWidth(100)
	btn:SetHeight(15)
	
	local texture = btn:CreateTexture(nil,"BACKGROUND")
	texture:SetTexture(0.50,0.50,0.80,0.9)
	texture:SetAlpha(0.6)
	texture:SetAllPoints(btn)
	
	local txt = btn:CreateFontString(nil,"OVERLAY")
	txt:SetFont(PunschrulleFonts["Vixar"], 12)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText("Unlock")
	txt:SetPoint("LEFT",btn,"LEFT",1,0)
	
	btn:SetScript("OnClick",function ()
		if Punsch_Entity_Locked then
			txt:SetText("Lock")
		else
			txt:SetText("Unlock")
		end
		Punsch_Entity_ToggleLock()
	end)
	btn:SetScript("OnEnter",function ()
		texture:SetAlpha(0.9)
	end)
	btn:SetScript("OnLeave",function ()
		texture:SetAlpha(0.6)
	end)

	PunschOptionWindow.buttonbg = PunschOptionWindow.Handle:CreateTexture(nil,"ARTWORK")
	PunschOptionWindow.buttonbg:SetTexture(0.2,0.2,0.2,0.8)
	PunschOptionWindow.buttonbg:SetPoint("TOPLEFT", PunschOptionWindow.Handle, "TOPLEFT",-100.5,-14)
	PunschOptionWindow.buttonbg:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT",1,-1)

	PunschOptionWindow.btnMade = PunschOptionWindow.btnMade + 1

	PunschEditFrames["Profile"].Handle:Show()
	PunschOptionWindow.Open = PunschEditFrames["Profile"].Handle
	PunschOptionWindow.Open.texture:SetTexture(0.70,0.70,1,0.9)
end

function Punsch_Options_MainWindow_Create()
	PunschOptionWindow = {}
	
	PunschOptionWindow.Handle = CreateFrame("Frame",nil,UIParent)
	PunschOptionWindow.Handle:SetFrameStrata("BACKGROUND")
	PunschOptionWindow.Handle:SetWidth(482)
	PunschOptionWindow.Handle:SetHeight(400)

	PunschOptionWindow.BG = PunschOptionWindow.Handle:CreateTexture(nil,"BACKGROUND")
	PunschOptionWindow.BG:SetTexture(0.1,0.1,0.1,0.8)
	PunschOptionWindow.BG:SetAllPoints(PunschOptionWindow.Handle)
	
	PunschOptionWindow.Title = PunschOptionWindow.Handle:CreateFontString(nil,"OVERLAY")
	PunschOptionWindow.Title:SetFont(PunschrulleFonts["Vixar"], 14)
	PunschOptionWindow.Title:SetShadowColor(0,0,0,1)
	PunschOptionWindow.Title:SetShadowOffset(0.8,-0.8)
	PunschOptionWindow.Title:SetText("Punschrulle v" .. PunschrulleVersion)
	PunschOptionWindow.Title:SetPoint("TOP", PunschOptionWindow.Handle,"TOP",0,-1)

	PunschOptionWindow.TitleBar = CreateFrame("Frame",nil,PunschOptionWindow.Handle)
	PunschOptionWindow.TitleBar:SetPoint("TOPLEFT",PunschOptionWindow.Handle)
	PunschOptionWindow.TitleBar:SetPoint("BOTTOM",PunschOptionWindow.Handle, "TOP",0,-14)
	PunschOptionWindow.TitleBar:SetPoint("RIGHT",PunschOptionWindow.Handle, "RIGHT",-14,0)

	PunschOptionWindow.BtnClose = CreateFrame("Button",nil,PunschOptionWindow.Handle,"UIPanelCloseButton")
	PunschOptionWindow.BtnClose:SetWidth(12)
	PunschOptionWindow.BtnClose:SetHeight(12)
	PunschOptionWindow.BtnClose:SetPoint("TOPRIGHT", PunschOptionWindow.Handle, "TOPRIGHT",-1,-1)
	PunschOptionWindow.BtnClose:GetNormalTexture():SetTexCoord(0.2,0.75,0.25,0.75)
	PunschOptionWindow.BtnClose:GetHighlightTexture():SetTexCoord(0.2,0.75,0.25,0.75)
	PunschOptionWindow.BtnClose:GetPushedTexture():SetTexCoord(0.2,0.75,0.25,0.75)

	PunschOptionWindow.selectionBG = PunschOptionWindow.Handle:CreateTexture(nil,"BORDER")
	PunschOptionWindow.selectionBG:SetVertexColor(0.73,0.64,0.8,0.8)
	PunschOptionWindow.selectionBG:SetTexture("DUNGEONS\\TEXTURES\\ROCK\\JLO_UDERCITY_ICE")
	PunschOptionWindow.selectionBG:SetPoint("BOTTOMRIGHT", PunschOptionWindow.Handle, "BOTTOMRIGHT",-1,1)
	PunschOptionWindow.selectionBG:SetPoint("TOPLEFT", PunschOptionWindow.Handle, "TOPLEFT",1,-15)

	PunschOptionWindow.btnMade = 0
	PunschOptionWindow.Open = nil
	
	PunschOptionWindow.Handle:SetPoint("CENTER",UIParent,"CENTER",0,0)	

	PunschOptionWindow.Handle:SetMovable(true)
	PunschOptionWindow.TitleBar:EnableMouse(true)
	PunschOptionWindow.TitleBar:SetScript("OnMouseDown", Punsch_Options_MainWindow_StartMove)
	PunschOptionWindow.TitleBar:SetScript("OnMouseUp", Punsch_Options_MainWindow_StopMove)
	PunschOptionWindow.TitleBar:SetScript("OnHide", Punsch_Options_MainWindow_StopMove)
end

function Punsch_Options_MainWindow_StartMove(self)
	PunschOptionWindow.Handle.IsMovingOrSizing = 1
	PunschOptionWindow.Handle:StartMoving()
end

function Punsch_Options_MainWindow_StopMove(self)
	if PunschOptionWindow.Handle.IsMovingOrSizing then
		PunschOptionWindow.Handle:StopMovingOrSizing()
		PunschOptionWindow.Handle.IsMovingOrSizing = nil
	end
end

function Punsch_Options_EditFrame_Create(name) 
	local handle = CreateFrame("Frame",nil,PunschOptionWindow.Handle)
	handle:SetPoint("BOTTOMRIGHT", PunschOptionWindow.Handle, "BOTTOMRIGHT",0,0)
	handle:SetPoint("TOPLEFT", PunschOptionWindow.selectionBG, "TOPLEFT",0,-0.5)

	local scrollhandle = CreateFrame("ScrollFrame", nil, handle)

	scrollhandle:SetPoint("TOPLEFT", handle)
	scrollhandle:SetPoint("BOTTOMRIGHT", handle)
	scrollhandle:EnableMouseWheel(true)

	scrollhandle:SetScript("OnMouseWheel", function()
		local maxScroll = this:GetVerticalScrollRange()
		local Scroll = this:GetVerticalScroll()
		local toScroll = (Scroll - (20*arg1))
		if toScroll < 0 then
			this:SetVerticalScroll(0)
		elseif toScroll > maxScroll then
			this:SetVerticalScroll(maxScroll)
		else
			this:SetVerticalScroll(toScroll)
		end
	end)

	local childhandle = CreateFrame("Frame",nil,scrollhandle)
	childhandle:SetWidth(480)
	childhandle:SetHeight(384)
	childhandle.num = 0
	childhandle.o = {}

	scrollhandle:SetScrollChild(childhandle)

	--Create button in the sidebar
	local btn = CreateFrame("Button",nil,PunschOptionWindow.Handle)
	btn:SetPoint("TOPLEFT", PunschOptionWindow.selectionBG, "TOPLEFT",-101,-15*PunschOptionWindow.btnMade)
	
	btn:SetWidth(100)
	btn:SetHeight(15)
	
	handle.texture = btn:CreateTexture(nil,"BACKGROUND")
	handle.texture:SetTexture(0.50,0.50,0.80,0.9)
	handle.texture:SetAlpha(0.6)
	handle.texture:SetAllPoints(btn)
	
	local txt = btn:CreateFontString(nil,"OVERLAY")
	txt:SetFont(PunschrulleFonts["Vixar"], 12)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(name)
	txt:SetPoint("LEFT",btn,"LEFT",1,0)
	
	btn:SetScript("OnClick",function ()
		if Punschrulle_Options_TextureFrame then Punschrulle_Options_TextureFrame.h:Hide() end
		if Punschrulle_Options_FontFrame then Punschrulle_Options_FontFrame.h:Hide() end
		if PunschOptionWindow.Open ~= nil then
			PunschOptionWindow.Open.texture:SetTexture(0.50,0.50,0.80,0.9)
			PunschOptionWindow.Open:Hide()
		end
		handle.texture:SetTexture(0.70,0.70,1,0.9)
		PunschOptionWindow.Open = handle
		handle:Show()
	end)
	btn:SetScript("OnEnter",function ()
		handle.texture:SetAlpha(0.9)
	end)
	btn:SetScript("OnLeave",function ()
		handle.texture:SetAlpha(0.6)
	end)

	PunschOptionWindow.btnMade = PunschOptionWindow.btnMade + 1

	return handle,childhandle
end

function Punsch_Options_EditFrame_UpdateAll() 
	for _,f in pairs(PunschEditFrames) do
		f.update()
	end
end

function Punsch_Options_EditFrame_CreateHeaderOption(parent,Text)
	parent.num = parent.num + 1
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize+2)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText("            " .. Text)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14 -2)
	txt:SetPoint("RIGHT", parent)

	parent.num = parent.num + 1
end

function Punsch_Options_EditFrame_CreateEditTextOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local editbox = CreateFrame("EditBox",nil,parent)
	editbox:SetHeight(13)
	editbox:SetFont(normalFont, normalSize)

	editbox:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	editbox:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)
	editbox:SetAutoFocus(false)

 	local onEnter = function () 
		setter(editbox:GetText())
		Punsch_Entity_UpdateAll()
	end

	local updateOption = function ()
		editbox:SetText(getter())
	end

	editbox:SetScript("OnEnterPressed",onEnter)
	editbox:SetScript("OnEditFocusLost",onEnter)
	editbox:SetScript("OnEscapePressed",updateOption)

	local editboxbg = parent:CreateTexture(nil,"BACKGROUND")
	editboxbg:SetTexture(0.1,0.1,0.1,0.6)
	editboxbg:SetAllPoints(editbox)
	parent.num = parent.num + 1
	return updateOption,editbox,txt
end

function Punsch_Options_EditFrame_CreateEditNumberOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local editbox = CreateFrame("EditBox",nil,parent)
	editbox:SetHeight(13)
	editbox:SetFont(normalFont, normalSize)
	editbox:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	editbox:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)
	editbox:SetAutoFocus(false)

	local updateOption = function ()
		editbox:SetText(string.format("%.2f",getter()))
	end

 	local onEnter = function () 
 		local s = tonumber(editbox:GetText())
 		if s then
			setter(s)
		else
			updateOption()
		end
		Punsch_Entity_UpdateAll()
	end

	editbox:SetScript("OnEnterPressed",onEnter)
	editbox:SetScript("OnEditFocusLost",onEnter)
	editbox:SetScript("OnEscapePressed",updateOption)

	local editboxbg = parent:CreateTexture(nil,"BACKGROUND")
	editboxbg:SetTexture(0.1,0.1,0.1,0.6)
	editboxbg:SetAllPoints(editbox)
	parent.num = parent.num + 1
	return updateOption,editbox,txt
end

function Punschrulle_Options_Mediapicker_Create()
	local h = CreateFrame("Frame",nil,PunschOptionWindow.Handle)
	h:SetPoint("TOPLEFT", PunschOptionWindow.Handle, "TOPRIGHT",0,-15)
	h:SetPoint("BOTTOM", PunschOptionWindow.Handle)
	h:SetWidth(200)

	local bg = h:CreateTexture(nil,"BORDER")
	bg:SetTexture(0.2,0.2,0.2,0.8)
	bg:SetAllPoints(h)

	local scroll = CreateFrame("ScrollFrame", nil, h)
	scroll:SetAllPoints(h)
	scroll:EnableMouseWheel(true)

	scroll:SetScript("OnMouseWheel", function()
		local maxScroll = this:GetVerticalScrollRange()
		local Scroll = this:GetVerticalScroll()
		local toScroll = (Scroll - (20*arg1))
		if toScroll < 0 then
			this:SetVerticalScroll(0)
		elseif toScroll > maxScroll then
			this:SetVerticalScroll(maxScroll)
		else
			this:SetVerticalScroll(toScroll)
		end
	end)

	local content = CreateFrame("Frame",nil,scroll)
	content:SetWidth(200)
	content:SetHeight(350)

	scroll:SetScrollChild(content)
	return h,content
end

function Punschrulle_Options_FontFrame_Show(getter,setter)
	if not Punschrulle_Options_FontFrame then
		local h,content = Punschrulle_Options_Mediapicker_Create()
		local num = 0
		local Buttons = {}

		local btn = {}
		btn.f = CreateFrame("Button",nil,content)
		btn.f:SetHeight(13)
		btn.f:SetPoint("TOPLEFT", content, "TOPLEFT",0,-num * 14)
		btn.f:SetPoint("RIGHT", content, "RIGHT",-1.5,0)

		btn.bg = btn.f:CreateTexture(nil,"BACKGROUND")
		btn.bg:SetTexture(0.1,0.1,0.1,0.6)
		btn.bg:SetAllPoints(btn.f)


		btn.txt = btn.f:CreateFontString(nil,"OVERLAY")
		btn.txt:SetFont(Punschrulle_GetFont(""), 12)
		btn.txt:SetText("Gamefont")
		btn.txt:SetPoint("LEFT",btn.f)

		btn.Font = ""

		num = num + 1
		Buttons["Gamefont"] = btn

    	local sortedFonts = {}
   	 	for n in pairs(PunschrulleFonts) do table.insert(sortedFonts, n) end
    	table.sort(sortedFonts)
    	for _,i in ipairs(sortedFonts) do
			local btn = {}
			btn.f = CreateFrame("Button",nil,content)
			btn.f:SetHeight(13)
			btn.f:SetPoint("TOPLEFT", content, "TOPLEFT",0,-num * 14)
			btn.f:SetPoint("RIGHT", content, "RIGHT",0,0)

			btn.bg = btn.f:CreateTexture(nil,"BACKGROUND")
			btn.bg:SetTexture(0.1,0.1,0.1,0.6)
			btn.bg:SetAllPoints(btn.f)

			btn.txt = btn.f:CreateFontString(nil,"OVERLAY")
			btn.txt:SetFont(Punschrulle_GetFont(i), 12)
			btn.txt:SetText(i)
			btn.txt:SetPoint("LEFT",btn.f)

			btn.Font = i

			num = num + 1
			Buttons[i] = btn
		end
		Punschrulle_Options_FontFrame = {}
		Punschrulle_Options_FontFrame.h = h
		Punschrulle_Options_FontFrame.Buttons = Buttons
		Punschrulle_Options_FontFrame.h:Hide()
	end
	if Punschrulle_Options_FontFrame.h:IsShown() then
		Punschrulle_Options_FontFrame.h:Hide()
	else
		for _,b in pairs(Punschrulle_Options_FontFrame.Buttons) do
			local btn = b
			if btn.Font == getter() then
				btn.txt:SetTextColor(0.7,1,0.7,1)
			else
				btn.txt:SetTextColor(1,1,1,1)
			end
			btn.f:SetScript("OnClick",function ()
				setter(btn.Font)
				Punschrulle_Options_FontFrame.h:Hide()
				end)
		end
		if Punschrulle_Options_TextureFrame then Punschrulle_Options_TextureFrame.h:Hide() end
		Punschrulle_Options_FontFrame.h:Show()
	end
end

function Punsch_Options_EditFrame_CreateFontPickerOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local btn = CreateFrame("Button",nil,parent)
	btn:SetHeight(13)
	btn:SetFont(normalFont, normalSize)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	btn:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)

	local btnbg = parent:CreateTexture(nil,"BACKGROUND")
	btnbg:SetTexture(0.1,0.1,0.1,0.6)
	btnbg:SetAllPoints(btn)

	local updateOption = function ()
		btn:SetText(getter())
		btn:SetFont(Punschrulle_GetFont(getter()), 10)
	end

 	local onClick = function () 
 		Punschrulle_Options_FontFrame_Show(getter,setter)
	end

	btn:SetScript("OnClick",onClick)

	parent.num = parent.num + 1
	return updateOption
end

function Punschrulle_Options_TextureFrame_Show(getter,setter)
	if not Punschrulle_Options_TextureFrame then
		local h,content = Punschrulle_Options_Mediapicker_Create()
		local num = 0
		local Buttons = {}

		local sortedTextures = {}
   	 	for n in pairs(PunschrulleTextures) do table.insert(sortedTextures, n) end
    	table.sort(sortedTextures)
    	for _,i in ipairs(sortedTextures) do
			local btn = {}
			btn.f = CreateFrame("Button",nil,content)
			btn.f:SetHeight(13)
			btn.f:SetPoint("TOPLEFT", content, "TOPLEFT",0,-num * 14)
			btn.f:SetPoint("RIGHT", content, "RIGHT",0,0)

			btn.bg = btn.f:CreateTexture(nil,"BACKGROUND")
			btn.bg:SetTexture(Punschrulle_GetTexture(i))
			btn.bg:SetAllPoints(btn.f)

			btn.txt = btn.f:CreateFontString(nil,"OVERLAY")
			btn.txt:SetFont(normalFont, 12)
			btn.txt:SetShadowColor(0,0,0,1)
			btn.txt:SetShadowOffset(0.8,-0.8)
			btn.txt:SetText(i)
			btn.txt:SetPoint("CENTER",btn.f)

			btn.Texture = i

			num = num + 1
			Buttons[i] = btn
		end
		Punschrulle_Options_TextureFrame = {}
		Punschrulle_Options_TextureFrame.h = h
		Punschrulle_Options_TextureFrame.Buttons = Buttons
		Punschrulle_Options_TextureFrame.h:Hide()
	end
	if Punschrulle_Options_TextureFrame.h:IsShown() then
		Punschrulle_Options_TextureFrame.h:Hide()
	else
		for _,b in pairs(Punschrulle_Options_TextureFrame.Buttons) do
			local btn = b
			if btn.Texture == getter() then
				btn.bg:SetVertexColor(0.7,1,0.7,1)
			else
				btn.bg:SetVertexColor(1,1,1,1)
			end
			btn.f:SetScript("OnClick",function ()
				setter(btn.Texture)
				Punschrulle_Options_TextureFrame.h:Hide()
				end)
		end
		if Punschrulle_Options_FontFrame then Punschrulle_Options_FontFrame.h:Hide() end
		Punschrulle_Options_TextureFrame.h:Show()
	end
end

function Punsch_Options_EditFrame_CreateTexturePickerOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local btn = CreateFrame("Button",nil,parent)
	btn:SetHeight(13)
	btn:SetFont(normalFont, normalSize)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	btn:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)

	local btnoutline = btn:CreateTexture(nil,"BACKGROUND")
	btnoutline:SetTexture(0,0,0,1)
	btnoutline:SetAllPoints(btn)

	local btnbg = btn:CreateTexture(nil,"OVERLAY")
	btnbg:SetPoint("TOPLEFT", btn, "TOPLEFT",1,-1)
	btnbg:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT",-1,1)

	local updateOption = function ()
		btnbg:SetTexture(Punschrulle_GetTexture(getter()))
	end

 	local onClick = function () 
 		Punschrulle_Options_TextureFrame_Show(getter,setter)
	end

	btn:SetScript("OnClick",onClick)

	parent.num = parent.num + 1
	return updateOption
end

function Punsch_Options_EditFrame_CreateCheckBoxOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local checkbox = CreateFrame("CheckButton",nil,parent,"UICheckButtonTemplate")
	checkbox:SetHeight(13)
	checkbox:SetWidth(14)
	checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	checkbox:GetNormalTexture():SetTexCoord(0.3,0.6,0.3,0.6)
	checkbox:GetHighlightTexture():SetTexCoord(0.3,0.6,0.3,0.6)
	checkbox:GetPushedTexture():SetTexCoord(0.3,0.6,0.3,0.6)

	checkbox:SetScript("OnClick",function ()
		setter(checkbox:GetChecked())
		Punsch_Entity_UpdateAll()
	end)

	local updateOption = function ()
		local v = getter()
		if v then 
			checkbox:SetChecked(v)
		else
			checkbox:SetChecked(false)
		end
	end

	parent.num = parent.num + 1
	return updateOption
end

function Punsch_Options_EditFrame_ColorPickerOption(parent,optionText,getter,setter)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)
	
	local btn = CreateFrame("Button",nil,parent)
	btn:SetHeight(13)
	--btn:SetFont(normalFont, normalSize)
	btn:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	btn:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)

	local btnbg1 = btn:CreateTexture(nil,"BACKGROUND")
	btnbg1:SetTexture(0,0,0,1)
	btnbg1:SetAllPoints(btn)

	local btnbg2 = btn:CreateTexture(nil,"ARTWORK")
	btnbg2:SetTexture(1,1,1,1)
	btnbg2:SetPoint("TOPLEFT", btnbg1, "TOPLEFT",1,-1)
	btnbg2:SetPoint("BOTTOMRIGHT", btnbg1, "BOTTOMRIGHT",-1,1)

	local btnbg3 = btn:CreateTexture(nil,"OVERLAY")
	btnbg3:SetPoint("TOPLEFT", btnbg1, "TOPLEFT",1,-1)
	btnbg3:SetPoint("BOTTOMRIGHT", btnbg1, "BOTTOMRIGHT",-1,1)

	local txtR = parent:CreateFontString(nil,"OVERLAY")
	txtR:SetFont(normalFont, normalSize)
	txtR:SetShadowColor(0,0,0,1)
	txtR:SetShadowOffset(0.8,-0.8)
	txtR:SetText("R")
	txtR:SetHeight(13)
	txtR:SetJustifyH("LEFT")
	txtR:SetPoint("TOPLEFT", parent, "TOPLEFT",257,-(parent.num+1) * 14-2)
	txtR:SetPoint("RIGHT", parent, "LEFT",265,0)
	
	local editboxR = CreateFrame("EditBox",nil,parent)
	editboxR:SetHeight(13)
	editboxR:SetFont(normalFont, normalSize)
	editboxR:SetPoint("TOPLEFT", txtR, "TOPRIGHT",3,0)
	editboxR:SetPoint("RIGHT", txtR, "RIGHT",45,0)
	editboxR:SetAutoFocus(false)

	local editboxbgR = parent:CreateTexture(nil,"BACKGROUND")
	editboxbgR:SetTexture(0.1,0.1,0.1,0.6)
	editboxbgR:SetAllPoints(editboxR)

	local txtG = parent:CreateFontString(nil,"OVERLAY")
	txtG:SetFont(normalFont, normalSize)
	txtG:SetShadowColor(0,0,0,1)
	txtG:SetShadowOffset(0.8,-0.8)
	txtG:SetText("G")
	txtG:SetHeight(13)
	txtG:SetJustifyH("LEFT")
	txtG:SetPoint("TOPLEFT", txtR, "TOPLEFT",56,0)
	txtG:SetPoint("RIGHT", txtR, "RIGHT",56,0)
	
	local editboxG = CreateFrame("EditBox",nil,parent)
	editboxG:SetHeight(13)
	editboxG:SetFont(normalFont, normalSize)
	editboxG:SetPoint("TOPLEFT", txtG, "TOPRIGHT",3,0)
	editboxG:SetPoint("RIGHT", txtG, "RIGHT",45,0)
	editboxG:SetAutoFocus(false)

	local editboxbgG = parent:CreateTexture(nil,"BACKGROUND")
	editboxbgG:SetTexture(0.1,0.1,0.1,0.6)
	editboxbgG:SetAllPoints(editboxG)

	local txtB = parent:CreateFontString(nil,"OVERLAY")
	txtB:SetFont(normalFont, normalSize)
	txtB:SetShadowColor(0,0,0,1)
	txtB:SetShadowOffset(0.8,-0.8)
	txtB:SetText("B")
	txtB:SetHeight(13)
	txtB:SetJustifyH("LEFT")
	txtB:SetPoint("TOPLEFT", txtG, "TOPLEFT",56,0)
	txtB:SetPoint("RIGHT", txtG, "RIGHT",56,0)
	
	local editboxB = CreateFrame("EditBox",nil,parent)
	editboxB:SetHeight(13)
	editboxB:SetFont(normalFont, normalSize)
	editboxB:SetPoint("TOPLEFT", txtB, "TOPRIGHT",3,0)
	editboxB:SetPoint("RIGHT", txtB, "RIGHT",45,0)
	editboxB:SetAutoFocus(false)

	local editboxbgB = parent:CreateTexture(nil,"BACKGROUND")
	editboxbgB:SetTexture(0.1,0.1,0.1,0.6)
	editboxbgB:SetAllPoints(editboxB)

	local txtA = parent:CreateFontString(nil,"OVERLAY")
	txtA:SetFont(normalFont, normalSize)
	txtA:SetShadowColor(0,0,0,1)
	txtA:SetShadowOffset(0.8,-0.8)
	txtA:SetText("A")
	txtA:SetHeight(13)
	txtA:SetJustifyH("LEFT")
	txtA:SetPoint("TOPLEFT", txtB, "TOPLEFT",56,0)
	txtA:SetPoint("RIGHT", txtB, "RIGHT",56,0)
	
	local editboxA = CreateFrame("EditBox",nil,parent)
	editboxA:SetHeight(13)
	editboxA:SetFont(normalFont, normalSize)
	editboxA:SetPoint("TOPLEFT", txtA, "TOPRIGHT",3,0)
	editboxA:SetPoint("RIGHT", parent, "RIGHT",-1.5,0)
	editboxA:SetAutoFocus(false)

	local editboxbgA = parent:CreateTexture(nil,"BACKGROUND")
	editboxbgA:SetTexture(0.1,0.1,0.1,0.6)
	editboxbgA:SetAllPoints(editboxA)

	local updateOption = function()
		local r,g,b,a = getter()
		btnbg3:SetTexture(r,g,b,a)
		editboxR:SetText(string.format("%.2f",r))
		editboxG:SetText(string.format("%.2f",g))
		editboxB:SetText(string.format("%.2f",b))
		editboxA:SetText(string.format("%.2f",a))
		Punsch_Entity_UpdateAll()
	end

 	local onEnter = function () 
		local r,g,b,a = getter()
 		local newr = tonumber(editboxR:GetText())
 		if not newr then newr = r end
 		local newg = tonumber(editboxG:GetText())
 		if not newg then newg = g end
 		local newb = tonumber(editboxB:GetText())
 		if not newb then newb = b end
 		local newa = tonumber(editboxA:GetText())
 		if not newa then newa = a end
		setter(newr,newg,newb,newa)
		updateOption()
		Punsch_Entity_UpdateAll()
	end
	
	editboxR:SetScript("OnEnterPressed",onEnter)
	editboxR:SetScript("OnEditFocusLost",onEnter)
	editboxR:SetScript("OnEscapePressed",updateOption)
	editboxG:SetScript("OnEnterPressed",onEnter)
	editboxG:SetScript("OnEditFocusLost",onEnter)
	editboxG:SetScript("OnEscapePressed",updateOption)
	editboxB:SetScript("OnEnterPressed",onEnter)
	editboxB:SetScript("OnEditFocusLost",onEnter)
	editboxB:SetScript("OnEscapePressed",updateOption)
	editboxA:SetScript("OnEnterPressed",onEnter)
	editboxA:SetScript("OnEditFocusLost",onEnter)
	editboxA:SetScript("OnEscapePressed",updateOption)
	
	btn:SetScript("OnClick", function () 
		if not ColorPickerFrame:IsVisible() then
			ColorPickerFrame.hasOpacity = nil
			ColorPickerFrame.func = function ()
				local r,g,b = ColorPickerFrame:GetColorRGB()
				local _,_,_,a = getter()
				setter(r,g,b,a)
				updateOption()
			end
			ColorPickerFrame.cancelFunc = function ()
				setter(btnbg3.oldr,btnbg3.oldg,btnbg3.oldb,btnbg3.olda)
				updateOption()
			end
			ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
			ColorPickerFrame:Hide()
			ColorPickerFrame:Show()
			btnbg3.oldr, btnbg3.oldg, btnbg3.oldb, btnbg3.olda = getter()
			ColorPickerFrame:SetColorRGB(btnbg3.oldr,btnbg3.oldg,btnbg3.oldb)
		end
	end)

	parent.num = parent.num + 2
	return updateOption
end

Punschrulle_Options_EditFrame_DropDownMenuCount = 0
function Punsch_Options_EditFrame_CreateDropDownOption(parent,optionText)
	local txt = parent:CreateFontString(nil,"OVERLAY")
	txt:SetFont(normalFont, normalSize)
	txt:SetShadowColor(0,0,0,1)
	txt:SetShadowOffset(0.8,-0.8)
	txt:SetText(optionText)
	txt:SetHeight(13)
	txt:SetJustifyH("LEFT")
	txt:SetPoint("TOPLEFT", parent, "TOPLEFT",1,-parent.num * 14-2)
	txt:SetPoint("RIGHT", parent, "LEFT",255,0)

	local fn = "PunschrulleEbin" .. Punschrulle_Options_EditFrame_DropDownMenuCount
	Punschrulle_Options_EditFrame_DropDownMenuCount = Punschrulle_Options_EditFrame_DropDownMenuCount + 1

	local dropmenu = CreateFrame("Frame", fn, parent, "UIDropDownMenuTemplate")
	dropmenu:SetPoint("TOPLEFT", parent, "TOPLEFT",242,-parent.num * 14 +17)

	--this makes the dropdownwidget fit in. Although its HIDEOUS code
	getglobal(fn.."Left"):Hide()
	getglobal(fn.."Right"):Hide()
	getglobal(fn.."Middle"):SetTexture(0.1,0.1,0.1,0.6)
	getglobal(fn.."Middle"):SetHeight(13)
	getglobal(fn.."Middle"):SetPoint("TOPLEFT", parent, "TOPLEFT",257,-parent.num * 14-2)
	getglobal(fn.."Middle"):SetPoint("RIGHT", parent, "RIGHT",-1.5,0)
	getglobal(fn.."Button"):ClearAllPoints()
	getglobal(fn.."Button"):SetPoint("TOPLEFT", getglobal(fn.."Middle"), "TOPLEFT", 1, 0)
	getglobal(fn.."Button"):SetPoint("BOTTOMRIGHT", getglobal(fn.."Middle"), "TOPLEFT", 19, -13)
	getglobal(fn.."Text"):SetPoint("LEFT",getglobal(fn.."Button"),"RIGHT",2,0)
	getglobal(fn.."Text"):SetJustifyH("LEFT")
	getglobal(fn.."Text"):SetFont(normalFont, normalSize)
	getglobal(fn.."ButtonNormalTexture"):SetAllPoints(getglobal(fn.."Button"))
	getglobal(fn.."ButtonPushedTexture"):SetAllPoints(getglobal(fn.."Button"))
	getglobal(fn.."ButtonHighlightTexture"):SetAllPoints(getglobal(fn.."Button"))
	getglobal(fn.."ButtonNormalTexture"):SetTexCoord(0.2,0.75,0.2,0.85)
	getglobal(fn.."ButtonPushedTexture"):SetTexCoord(0.2,0.75,0.2,0.85)
	getglobal(fn.."ButtonHighlightTexture"):SetTexCoord(0.2,0.75,0.2,0.85)

	--I'm not gonna come up with a way of streamlining the coding of these. Additional code is required when the function is used, but it may vary greatly.

	parent.num = parent.num + 1
	return dropmenu
end

function Punsch_Options_EditFrame_CreateAnchorDropDownOption(parent,optionText,getter,setter)
	local dropmenu = Punsch_Options_EditFrame_CreateDropDownOption(parent,optionText)

	UIDropDownMenu_Initialize(dropmenu, function()
		for _,i in pairs({"TOP","RIGHT","BOTTOM","LEFT","TOPLEFT","TOPRIGHT","BOTTOMRIGHT","BOTTOMLEFT","CENTER"}) do
			local info = {}
			info.text = i
			info.arg1 = i
			info.checked = (i == getter())
			info.func = function (v)
				setter(v)
				Punsch_Entity_UpdateAll()
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetText(getter(),dropmenu)
	return dropmenu
end

function Punsch_Options_EditProfile_Create() 
	PunschEditFrames["Profile"] = {}
	PunschEditFrames["Profile"].Handle,PunschEditFrames["Profile"].ChildHandle = Punsch_Options_EditFrame_Create("Profile") 
	local e = PunschEditFrames["Profile"].ChildHandle

	--Profile selection
	local currentp = Punsch_Options_EditFrame_CreateDropDownOption(e,"Current Profile")
	UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile].Name,currentp)
	UIDropDownMenu_Initialize(currentp, function()
		local info = {}
		for i,_ in pairs(PunschrulleDB.Profiles) do 
			info.arg1 = i
			info.text = PunschrulleDB.Profiles[i].Name
			info.checked = (i == PunschrulleProfile)
			info.func = function (v)
				PunschrulleProfile = v
				Punsch_Entity_UpdateAll()
				PunschEditFrames["Profile"].update()
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile].Name,currentp)
	end

	--Voodoo magic to disable renaming Default profile
	local _, namep = Punsch_Options_EditFrame_CreateEditTextOption(e,"Profile Name",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile].Name
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile].Name = s
		PunschEditFrames["Profile"].update()
	end)

	local namedp = e:CreateFontString(nil,"OVERLAY")
	namedp:SetFont(GameFontNormal:GetFont(), 10)
	namedp:SetText("Default")
	namedp:SetHeight(13)
	namedp:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	namedp:SetJustifyH("LEFT")
	namedp:SetAllPoints(namep)

	e.o[e.num - 1] = function ()
		if PunschrulleProfile == "Default" then
			namep:SetText("Default")
			namep:Hide()
			namedp:Show()
		else
			namep:SetText(PunschrulleDB.Profiles[PunschrulleProfile].Name)
			namep:Show()
			namedp:Hide()
		end
	end

	--Profile creation from presets. Figs this when adding presets.
	local createp = Punsch_Options_EditFrame_CreateDropDownOption(e,"Create new profile")
	UIDropDownMenu_SetText("Select Preset",createp)
	UIDropDownMenu_Initialize(createp, function()
		for i,t in pairs(Punsch_Tables_ProfilePresets) do
			local info = {}
			info.text = i
			info.arg1 = i
			info.notCheckable = true
			info.func = function (v)
				local num = 0
				while PunschrulleDB.Profiles["Custom" .. num] do
					num = num + 1
				end
				PunschrulleDB.Profiles["Custom" .. num] = Punschrulle_DeepCopy(Punsch_Tables_ProfilePresets[v],{})

				PunschrulleProfile = "Custom" .. num
				Punsch_Entity_UpdateAll()
				PunschEditFrames["Profile"].update()
			end
			UIDropDownMenu_AddButton(info)
		end
	end)

	--Profile deletion
	local deletep = Punsch_Options_EditFrame_CreateDropDownOption(e,"Delete Profile")
	UIDropDownMenu_SetText("Select Profile",deletep)
	UIDropDownMenu_Initialize(deletep, function()
		for i,_ in pairs(PunschrulleDB.Profiles) do 
			local info = {}
			info.arg1 = i
			info.text = PunschrulleDB.Profiles[i].Name
			if i == "Default" then
				info.disabled = true
			end
			info.notCheckable = true
			info.func = function (v)
				if PunschrulleProfile == v then
					PunschrulleProfile = "Default"
				end
				PunschrulleDB.Profiles[v] = nil
				Punsch_Entity_UpdateAll()
				PunschEditFrames["Profile"].update()
			end
			UIDropDownMenu_AddButton(info)	
		end
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Mute welcome message", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile].MuteWelcomeMessage
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile].MuteWelcomeMessage = s
	end)

	PunschEditFrames["Profile"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["Profile"].update)
	PunschEditFrames["Profile"].Handle:Hide()
end

function Punsch_Options_EditCastbar_Create() 
	PunschEditFrames["Castbar"] = {}
	PunschEditFrames["Castbar"].Handle,PunschEditFrames["Castbar"].ChildHandle = Punsch_Options_EditFrame_Create("Castbar") 
	local e = PunschEditFrames["Castbar"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Always Show Castbar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].AlwaysShow
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].AlwaysShow = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Hide Blizzard Castbar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].HideBlizzardBar
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].HideBlizzardBar = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show lag on Castbar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowLag
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowLag = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Position")

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Height = s
	end)

	local anchorp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.Point = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["Castbar"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"])
		PunschEditFrames["Castbar"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.Point,anchorp)
	end

	local anchorrp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Relative Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.rPoint = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["Castbar"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"])
		PunschEditFrames["Castbar"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.rPoint,anchorrp)
	end

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Anchor.Y = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Appearance")

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Background Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Bg.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateTexturePickerOption(e,"Bar Texture",function()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Texture
	end,function(s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Texture = s
		PunschEditFrames["Castbar"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Texture on full bar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowTextureOnFullBar
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowTextureOnFullBar = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Stretch Texture", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].StretchTexture
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].StretchTexture = s
	end)


	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Cast Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fill.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Channel Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].FillChannel.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Lag Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Lag.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spark")


	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Spark", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Height = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Spark.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Frame")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Frame", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Thickness", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Thickness
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Thickness = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Inner Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.InnerBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.InnerBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Outer Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.OuterBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.OuterBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Border Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Bordera
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Borderb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Frame.Bordera = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Border")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Border", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Show
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Show = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Border on Top", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.OnTop
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.OnTop = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Encompass icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].BorderEncompassIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].BorderEncompassIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Size
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Size = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Padding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.Padding = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Border.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spell Icon")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Spell Icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Icon Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].IconPadding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].IconPadding = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Channel Ticks")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Channel Ticks", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.Enable = s
	end)

	--[[ Unimplemented feature
	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Lag on each tick", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.ShowLag
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.ShowLag = s
	end)
	--]]

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show as Solid", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.AsSolidColor
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.AsSolidColor = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Tick Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Tick Top Anchor (0-1)", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.TopAnchor
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.TopAnchor = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Tick Bot Anchor (0-1)", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.BotAnchor
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.BotAnchor = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Tick Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Tick.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Advanced Behavior")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Delay to Channel Duration", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ChannelDelayToDuration
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ChannelDelayToDuration = s
	end)


	PunschEditFrames["Castbar"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["Castbar"].update)

	PunschEditFrames["Castbar"].Handle:Hide()
end

function Punsch_Options_EditCastbarText_Create() 
	PunschEditFrames["CastbarText"] = {}
	PunschEditFrames["CastbarText"].Handle,PunschEditFrames["CastbarText"].ChildHandle = Punsch_Options_EditFrame_Create("Castbar Text") 
	local e = PunschEditFrames["CastbarText"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Decimals Displayed", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Decimals
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Decimals = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spellname text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Font = s
		PunschEditFrames["CastbarText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Uppercase spellname", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].UpperCaseSpellName
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].UpperCaseSpellName = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.FontShadowY = s
	end)

	local anchorsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Castbar"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Point,
		PunschEntities["Castbar"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.rPoint)
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Point,anchorsn)
	end	

	local anchorrsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Castbar"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Point,
		PunschEntities["Castbar"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.rPoint)
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.rPoint,anchorrsn)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLeft.sa = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Spell Rank", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowRank
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].ShowRank = s
	end)

		e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Rank as Roman", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].RankAsRoman
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].RankAsRoman = s
	end)

			e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Shorten Rank", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].RankAsShort
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].RankAsShort = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Duration text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Font = s
		PunschEditFrames["CastbarText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.FontShadowY = s
	end)

	local anchord = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Castbar"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Point,
		PunschEntities["Castbar"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.rPoint)
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Point,anchord)
	end	

	local anchorrd = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Castbar"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Point,
		PunschEntities["Castbar"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.rPoint)
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.rPoint,anchorrd)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.sa = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Count up on cast", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].CountUpOnCast
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].CountUpOnCast = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Count up on channel", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].CountUpOnChannel
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].CountUpOnChannel = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Spacing", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Spacing
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextRight.Spacing = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Delay text")


	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Font = s
		PunschEditFrames["CastbarText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.FontShadowY = s
	end)

	local anchordelay = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point = s
		if PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.AnchorToDuration then
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].text2,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
		else
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].self,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
		end
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,anchordelay)
	end	

	local anchorrdelay = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint
	end,function(s) 
		
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint = s
		if PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.AnchorToDuration then
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].text2,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
		else
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].self,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
		end
		PunschEditFrames["CastbarText"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint,anchorrdelay)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.sa = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Anchor to Duration", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.AnchorToDuration
	end, function (s)
		if s then
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].text2,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
			PunschEditFrames["CastbarText"].update()
		else
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.X,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Y = Punsch_Entity_GetRelativePoint(
				PunschEntities["Castbar"].text3,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.Point,
				PunschEntities["Castbar"].self,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextDelay.rPoint)
			PunschEditFrames["CastbarText"].update()
		end
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Lag text")


	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.Font = s
		PunschEditFrames["CastbarText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.FontShadowY = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].TextLag.sa = a
	end)


	PunschEditFrames["CastbarText"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["CastbarText"].update)

	PunschEditFrames["CastbarText"].Handle:Hide()
end

function Punsch_Options_EditFading_Create() 
	PunschEditFrames["Fading"] = {}
	PunschEditFrames["Fading"].Handle,PunschEditFrames["Fading"].ChildHandle = Punsch_Options_EditFrame_Create("Castbar Fading") 
	local e = PunschEditFrames["Fading"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Enable Fading", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Fade Time", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Time
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Time = s
	end)

	--unimplemented as of right now
	--e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Fade on Channels", function () 
	--	return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.OnChannel
	--end, function (s)
	--	PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.OnChannel = s
	--end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Lag While Fading", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.ShowLagWhileFading
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.ShowLagWhileFading = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Interrupted by self = Failure", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.PlayerInterruptAsFailure
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.PlayerInterruptAsFailure = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Success Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Success.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Success Hold Time", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.SuccessHoldTime
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.SuccessHoldTime = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Failure Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Failure.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Failure Hold Time", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.FailureHoldTime
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.FailureHoldTime = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Assumption Tolerance", function () 
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Tolerance
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Castbar"].Fade.Tolerance = s
	end)


	PunschEditFrames["Fading"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["Fading"].update)
	PunschEditFrames["Fading"].Handle:Hide()
end

function Punsch_Options_EditMirror_Create() 
	PunschEditFrames["Mirror"] = {}
	PunschEditFrames["Mirror"].Handle,PunschEditFrames["Mirror"].ChildHandle = Punsch_Options_EditFrame_Create("Mirror") 
	local e = PunschEditFrames["Mirror"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Always Show Mirror", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].AlwaysShow
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].AlwaysShow = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Hide Blizzard Mirrorbar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].HideBlizzardBar
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].HideBlizzardBar = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Position")

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Height = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Padding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Padding = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Grow Up", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].GrowUp
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].GrowUp = s
	end)

	local anchorp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.Point = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["Mirror"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"])
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.Point,anchorp)
	end

	local anchorrp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Relative Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rPoint = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["Mirror"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"])
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rPoint,anchorrp)
	end

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Anchor to Castbar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rTo == "Castbar"
	end, function (s)
		if s then
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rTo = "Castbar"
		else
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.rTo = ""
		end
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["Mirror"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"])
		PunschEditFrames["Mirror"].update()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Anchor.Y = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Appearance")

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Background Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Bg.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateTexturePickerOption(e,"Bar Texture",function()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Texture
	end,function(s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Texture = s
		PunschEditFrames["Mirror"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Stretch Texture", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].StretchTexture
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].StretchTexture = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Texture on full bar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].ShowTextureOnFullBar
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].ShowTextureOnFullBar = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].ShowIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].ShowIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Icon Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].IconPadding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].IconPadding = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spark")


	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Spark", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Height = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Spark.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Frame")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Frame", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Thickness", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Thickness
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Thickness = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Inner Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.InnerBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.InnerBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Outer Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.OuterBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.OuterBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Border Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Bordera
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Borderb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Frame.Bordera = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Border")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Border", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Show
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Show = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Border on Top", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.OnTop
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.OnTop = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Encompass icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].BorderEncompassIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].BorderEncompassIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Size
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Size = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Padding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.Padding = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Border.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Fading")


	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Enable Fading", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Fadetime", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.Time
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.Time = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Holdtime", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.HoldTime
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Fade.HoldTime = s
	end)

	PunschEditFrames["Mirror"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["Mirror"].update)
	PunschEditFrames["Mirror"].Handle:Hide()
end

function Punsch_Options_EditMirrorText_Create() 
	PunschEditFrames["MirrorText"] = {}
	PunschEditFrames["MirrorText"].Handle,PunschEditFrames["MirrorText"].ChildHandle = Punsch_Options_EditFrame_Create("Mirror Text") 
	local e = PunschEditFrames["MirrorText"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Decimals Displayed", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Decimals
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].Decimals = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Mirrorname text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Font = s
		PunschEditFrames["MirrorText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.FontShadowY = s
	end)

	local anchorsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Mirror"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Point,
		PunschEntities["Mirror"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.rPoint)
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Point,anchorsn)
	end	

	local anchorrsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Mirror"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Point,
		PunschEntities["Mirror"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.rPoint)
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.rPoint,anchorrsn)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextLeft.sa = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Duration text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Font = s
		PunschEditFrames["MirrorText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.FontShadowY = s
	end)

	local anchord = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Mirror"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Point,
		PunschEntities["Mirror"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.rPoint)
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Point,anchord)
	end	

	local anchorrd = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["Mirror"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Point,
		PunschEntities["Mirror"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.rPoint)
		PunschEditFrames["Mirror"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.rPoint,anchorrd)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"].TextRight.sa = a
	end)

	PunschEditFrames["MirrorText"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["MirrorText"].update)

	PunschEditFrames["MirrorText"].Handle:Hide()
end

function Punsch_Options_EditMirrorEvents_Create() 
	PunschEditFrames["MirrorEvents"] = {}
	PunschEditFrames["MirrorEvents"].Handle,PunschEditFrames["MirrorEvents"].ChildHandle = Punsch_Options_EditFrame_Create("Mirror Events") 
	local e = PunschEditFrames["MirrorEvents"].ChildHandle
	for name,_ in pairs(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"]) do
		local n = name

		e.o[e.num]= Punsch_Options_EditFrame_CreateEditTextOption(e,"Event name", function () 
			return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].label
		end, function (s)
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].label = s
		end)

		e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Enable event", function ()
			return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].enable
		end, function (s)
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].enable = s
		end)

		e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
			return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].r,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].g,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].b,
				PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].a
		end, function (r,g,b,a)
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].r = r
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].g = g
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].b = b
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].a = a
		end)

		local Iconbox = e:CreateTexture(nil,"BACKGROUND")
		Iconbox:SetTexCoord(0.07,0.93,0.08,0.93)

		e.o[e.num], PunschEditFrames["MirrorEvents"][name] = Punsch_Options_EditFrame_CreateEditTextOption(e,"Icon", function () 
			if not Iconbox:SetTexture(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].icon) then
				Iconbox:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
			end
			return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].icon
		end, function (s)
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["Mirror"]["Events"][n].icon = s
			if not Iconbox:SetTexture(s) then
				Iconbox:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
			end
		end)
		PunschEditFrames["MirrorEvents"][name]:SetPoint("TOPLEFT", e, "TOPLEFT",1,-e.num * 14 -2)
		PunschEditFrames["MirrorEvents"][name]:SetPoint("RIGHT", e, "RIGHT",-31,0)

		Iconbox:SetPoint("BOTTOMLEFT", PunschEditFrames["MirrorEvents"][name], "BOTTOMRIGHT",0.5,0)
		Iconbox:SetPoint("TOPRIGHT", PunschEditFrames["MirrorEvents"][name], "TOPRIGHT",29.5,14)

		e.num = e.num + 2
	end

	PunschEditFrames["MirrorEvents"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["MirrorEvents"].update)
	PunschEditFrames["MirrorEvents"].Handle:Hide()
end

function Punsch_Options_EditSwingTimer_Create() 
	PunschEditFrames["SwingTimer"] = {}
	PunschEditFrames["SwingTimer"].Handle,PunschEditFrames["SwingTimer"].ChildHandle = Punsch_Options_EditFrame_Create("SwingTimer") 
	local e = PunschEditFrames["SwingTimer"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Always Show SwingTimer", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].AlwaysShow
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].AlwaysShow = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Position")

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Height = s
	end)

	local anchorp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.Point = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["SwingTimer"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"])
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.Point,anchorp)
	end

	local anchorrp = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Relative Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.rPoint = s
		Punsch_Entity_UpdateToNewAnchor(PunschEntities["SwingTimer"],PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"])
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.rPoint,anchorrp)
	end

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Anchor.Y = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Appearance")

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Background Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Bg.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateTexturePickerOption(e,"Bar Texture",function()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Texture
	end,function(s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Texture = s
		PunschEditFrames["SwingTimer"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Stretch Texture", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].StretchTexture
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].StretchTexture = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Texture on full bar", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].ShowTextureOnFullBar
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].ShowTextureOnFullBar = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].ShowIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].ShowIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Icon Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].IconPadding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].IconPadding = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spark")


	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Spark", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Height", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Height
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Height = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Width", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Width
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.Width = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Spark.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Frame")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Frame", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Thickness", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Thickness
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Thickness = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Inner Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.InnerBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.InnerBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Outer Border Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.OuterBorderSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.OuterBorderSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Border Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Bordera
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Borderb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Frame.Bordera = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Border")

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Show Border", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Show
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Show = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Border on Top", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.OnTop
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.OnTop = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Encompass icon", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].BorderEncompassIcon
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].BorderEncompassIcon = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Size
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Size = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Padding", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Padding
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.Padding = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Border.a = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Fading")


	e.o[e.num] = Punsch_Options_EditFrame_CreateCheckBoxOption(e,"Enable Fading", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Fade.Enable
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Fade.Enable = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Fadetime", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Fade.Time
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Fade.Time = s
	end)

	PunschEditFrames["SwingTimer"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["SwingTimer"].update)
	PunschEditFrames["SwingTimer"].Handle:Hide()
end

function Punsch_Options_EditSwingTimerText_Create() 
	PunschEditFrames["SwingTimerText"] = {}
	PunschEditFrames["SwingTimerText"].Handle,PunschEditFrames["SwingTimerText"].ChildHandle = Punsch_Options_EditFrame_Create("SwingTimer Text") 
	local e = PunschEditFrames["SwingTimerText"].ChildHandle

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Decimals Displayed", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Decimals
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].Decimals = s
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Spellname Text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Font = s
		PunschEditFrames["SwingTimerText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.FontShadowY = s
	end)

	local anchorsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["SwingTimer"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Point,
		PunschEntities["SwingTimer"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.rPoint)
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Point,anchorsn)
	end	

	local anchorrsn = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["SwingTimer"].text1,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Point,
		PunschEntities["SwingTimer"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.rPoint)
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.rPoint,anchorrsn)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextLeft.sa = a
	end)

	Punsch_Options_EditFrame_CreateHeaderOption(e,"Duration text")

	e.o[e.num] = Punsch_Options_EditFrame_CreateFontPickerOption(e,"Font",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Font
	end,function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Font = s
		PunschEditFrames["SwingTimerText"].update()
		Punsch_Entity_UpdateAll()
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Size", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontSize
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontSize = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow X Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontShadowX
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontShadowX = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Font Shadow Y Offset", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontShadowY
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.FontShadowY = s
	end)

	local anchord = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Point
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Point = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["SwingTimer"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Point,
		PunschEntities["SwingTimer"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.rPoint)
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Point,anchord)
	end	

	local anchorrd = Punsch_Options_EditFrame_CreateAnchorDropDownOption(e,"Anchor Relative Point",function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.rPoint
	end,function(s) 
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.rPoint = s
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.X,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Y = Punsch_Entity_GetRelativePoint(
		PunschEntities["SwingTimer"].text2,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Point,
		PunschEntities["SwingTimer"].self,
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.rPoint)
		PunschEditFrames["SwingTimer"].update()
	end)
	e.o[e.num-1] = function ()
		UIDropDownMenu_SetText(PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.rPoint,anchorrd)
	end	

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"X", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.X
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.X = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_CreateEditNumberOption(e,"Y", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Y
	end, function (s)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.Y = s
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.r,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.g,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.b,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.a
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.r = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.g = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.b = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.a = a
	end)

	e.o[e.num] = Punsch_Options_EditFrame_ColorPickerOption(e,"Shadow Color", function ()
		return PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sr,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sg,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sb,
			PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sa
	end, function (r,g,b,a)
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sr = r
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sg = g
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sb = b
		PunschrulleDB.Profiles[PunschrulleProfile]["Entities"]["SwingTimer"].TextRight.sa = a
	end)

	PunschEditFrames["SwingTimerText"].update = function ()
		for _,update in pairs(e.o) do
			update()
		end
	end

	e:SetScript("OnShow",PunschEditFrames["SwingTimerText"].update)

	PunschEditFrames["SwingTimerText"].Handle:Hide()
end

function Punsch_Options_About_Create() 
	PunschEditFrames["About"] = {}
	PunschEditFrames["About"].Handle,PunschEditFrames["About"].ChildHandle = Punsch_Options_EditFrame_Create("About") 
	local e = PunschEditFrames["About"].ChildHandle

	local Iconbox = e:CreateTexture(nil,"BACKGROUND")
	Iconbox:SetTexture("World\\Dungeon\\Cave\\PassiveDoodads\\Icicles\\Bp_mcaveIcicle_rock2")
	Iconbox:SetAllPoints()

	cfs = function(text,fontsize)
		local txt = e:CreateFontString(nil,"OVERLAY")
		txt:SetFont(headerFont, fontsize)
		txt:SetShadowColor(0,0,0,1)
		txt:SetShadowOffset(0.8,-0.8)
		txt:SetText(text)
		txt:SetHeight(25)
		txt:SetJustifyH("CENTER")
		return txt
	end
	local t = -45

	local txt = cfs("Punschrulle Castbar v" .. PunschrulleVersion,30)
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e)

	t = t -23
	local txt = cfs("By Attero",20)
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e)

	t = t -53
	local editbox = CreateFrame("EditBox",nil,e)
	editbox:SetHeight(25)
	editbox:SetFont(headerFont, 20)
	editbox:SetJustifyH("CENTER")
	editbox:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	editbox:SetPoint("RIGHT", e)
	editbox:SetText("Github.com/Attero/Punschrulle")
	editbox:SetAutoFocus(false)

	t = t -83
	local txt = cfs("Thanks to",20)
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e)

	t = t -23
	local txt = cfs("Pizzalol",20)
	txt:SetJustifyH("CENTER")
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e, "LEFT",160,0)

	local txt = cfs("Broler",20)
	txt:SetJustifyH("CENTER")
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",160,t)
	txt:SetPoint("RIGHT", e, "LEFT",320,0)

	local txt = cfs("Chrys",20)
	txt:SetJustifyH("CENTER")
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",320,t)
	txt:SetPoint("RIGHT", e)

	t = t -23
	local txt = cfs("<Praise>",20)
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e)

	t = t -23
	local txt = cfs("Raisnilt for his aimed shot workaround",20)
	txt:SetPoint("TOPLEFT", e, "TOPLEFT",0,t)
	txt:SetPoint("RIGHT", e)

	PunschEditFrames["About"].update = function () end
	PunschEditFrames["About"].Handle:Hide()
end
