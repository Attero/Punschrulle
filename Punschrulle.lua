local PunschDBVer = 8

function Punschrulle_Initialize()
	Punschrulle = CreateFrame("Frame", nil, UIParent)

	SLASH_PUNSCHRULLE1 = "/punsch";
	SLASH_PUNSCHRULLE2 = "/punschrulle";
	SlashCmdList["PUNSCHRULLE"] = Punschrulle_Command;

	Punschrulle:SetScript("OnEvent",Punschrulle_OnEvent)
	Punschrulle:RegisterEvent("ADDON_LOADED");

	DEFAULT_CHAT_FRAME:AddMessage("Punschrulle: /punsch");
end

function Punschrulle_OnEvent()
	if (event == "ADDON_LOADED") then
		if (arg1 == "Punschrulle") then
        	Punschrulle:UnregisterEvent("ADDON_LOADED")
			Punschrulle_GlobalsLoaded()
		end
	end
end

function Punschrulle_GlobalsLoaded()
	if PunschrulleDB==nil or (PunschrulleDB.DBVer~=PunschDBVer) then
		DEFAULT_CHAT_FRAME:AddMessage("Punschrulle: DB outdated; settings reset to default");
		Punschrulle_Setdefaults();
	end
	if PunschrulleProfile==nil then
		PunschrulleProfile = "Default"
	elseif not PunschrulleDB.Profiles[PunschrulleProfile] then
		PunschrulleProfile = "Default"
		DEFAULT_CHAT_FRAME:AddMessage("Punschrulle: Profile not found, using profile " .. PunschrulleDB.Profiles[PunschrulleProfile].Name)
	end
	Punsch_Castbar_Create()
	Punsch_Mirror_Create()
	Punsch_Entity_UpdateAll()
end

function Punschrulle_Command(msg)
	local cmd, subCmd = Punschrulle_GetCmd(msg);
	if(cmd=="lock") then
		Punsch_Entity_ToggleLock();
	elseif(cmd=="config") then
		Punsch_Option_MainWindow_Toggle()
	elseif(cmd=="test") then
		KronosManaTest()
	elseif(cmd=="default") then
		DEFAULT_CHAT_FRAME:AddMessage("Punschrulle: Reset to defaults.");
		Punschrulle_Setdefaults();
	else
		DEFAULT_CHAT_FRAME:AddMessage("Punschrulle: /punsch config,default,lock");
	end
end

function KronosManaTest() 
	if not KronosManaStartTest then
		KronosManaStartTest = true
		DEFAULT_CHAT_FRAME:AddMessage("Started tracking of mana regeneration ticks ")
		local m = CreateFrame("Frame","KronosManaTestFrame",UIParent)
		m:RegisterEvent("UNIT_MANA")
		KronosManaCurrentMana = UnitMana("player")
		KronosManaTickError = 0
		KronosManaTickCount = 0
		m:SetScript("OnEvent", function ()
	    	if KronosManaCurrentMana < UnitMana("player") then
	    		if KronosManaLastTickTime then
	    			KronosManaTickError = KronosManaTickError + GetTime()-KronosManaLastTickTime - 2
	    			DEFAULT_CHAT_FRAME:AddMessage(
	    				"mana gain at " .. string.format("%.4f",GetTime()) .. 
	    				" Time since last: " .. string.format("%.4f",GetTime()-KronosManaLastTickTime) .. 
	    				" Total Error: " .. string.format("%.4f",KronosManaTickError) .. 
	    				" Avg Error: " .. string.format("%.4f",KronosManaTickError/KronosManaTickCount))
	    		else
	    			DEFAULT_CHAT_FRAME:AddMessage("mana gain. Initial tick at " .. GetTime())
	    		end
	    		KronosManaLastTickTime = GetTime()
	    		KronosManaTickCount = KronosManaTickCount + 1
	    	end
	    	KronosManaCurrentMana = UnitMana("player")
		end)
	else
		DEFAULT_CHAT_FRAME:AddMessage("Reset tracking of mana regeneration ticks ")
		KronosManaCurrentMana = UnitMana("player")
		KronosManaTickError = 0
		KronosManaLastTickTime = nil
	end
end

function Punschrulle_GetCmd(msg)
	if(msg) then
		local a,b,c = strfind(msg, "(%S+)");
		if(a) then
			return c, strsub(msg, b+2);
		else	
			return "";
		end
	end
end

function Punschrulle_Setdefaults()
	PunschrulleProfile = "Default"
	PunschrulleDB = { 
		DBVer = PunschDBVer,
		Profiles = {}
	}
	PunschrulleDB.Profiles[PunschrulleProfile] = Punschrulle_DeepCopy(Punsch_Tables_ProfilePresets.Default,{})
	PunschrulleDB.Profiles[PunschrulleProfile].Name = "Default"
	Punsch_Options_EditFrame_UpdateAll()
	Punsch_Entity_UpdateAll()
end


function Punschrulle_GetIcon(s)
	if type(s) == "number" then
		return GetMacroIconInfo(s)
	else
		return s
	end
end

PunschrulleFonts = {
	Aldrich = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Aldrich.ttf",
	Bangers = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Bangers.ttf",
	Celestia = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Celestia.ttf",
	DorisPP = "Interface\\AddOns\\Punschrulle\\media\\fonts\\DorisPP.ttf",
	Enigmatic = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Enigmatic.ttf",
	FasterOne = "Interface\\AddOns\\Punschrulle\\media\\fonts\\FasterOne.ttf",
	Fitzgerald = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Fitzgerald.ttf",
	Gentium = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Gentium.ttf",
	Iceland = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Iceland.ttf",
	Inconsolata = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Inconsolata.ttf",
	LiberationSans = "Interface\\AddOns\\Punschrulle\\media\\fonts\\LiberationSans.ttf",
	Luna = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Luna.ttf",
	MetalLord = "Interface\\AddOns\\Punschrulle\\media\\fonts\\MetalLord.ttf",
	Optimus = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Optimus.ttf",
	TradeWinds = "Interface\\AddOns\\Punschrulle\\media\\fonts\\TradeWinds.ttf",
	VeraSerif = "Interface\\AddOns\\Punschrulle\\media\\fonts\\VeraSerif.ttf",
	Yellowjacket = "Interface\\AddOns\\Punschrulle\\media\\fonts\\Yellowjacket.ttf"
}

function Punschrulle_GetFont(s)
	if PunschrulleFonts[s] then return PunschrulleFonts[s] end
	return GameFontNormal:GetFont()
end

PunschrulleTextures = {
	Aluminium = "Interface\\AddOns\\Punschrulle\\media\\textures\\Aluminium",
	Armory = "Interface\\AddOns\\Punschrulle\\media\\textures\\Armory",
	BantoBar = "Interface\\AddOns\\Punschrulle\\media\\textures\\BantoBar",
	Bars = "Interface\\AddOns\\Punschrulle\\media\\textures\\Bars",
	Dabs = "Interface\\AddOns\\Punschrulle\\media\\textures\\Dabs",
	Diagonal = "Interface\\AddOns\\Punschrulle\\media\\textures\\Diagonal",
	Frost = "Interface\\AddOns\\Punschrulle\\media\\textures\\Frost",
	Glamour = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour",
	Glamour2 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour2",
	Glamour3 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour3",
	Glamour4 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour4",
	Glamour5 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour5",
	Glamour6 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour6",
	Glamour7 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glamour7",
	Glaze = "Interface\\AddOns\\Punschrulle\\media\\textures\\Glaze",
	Gloss = "Interface\\AddOns\\Punschrulle\\media\\textures\\Gloss",
	Healbot = "Interface\\AddOns\\Punschrulle\\media\\textures\\Healbot",
	LiteStep = "Interface\\AddOns\\Punschrulle\\media\\textures\\LiteStep",
	Luna = "Interface\\AddOns\\Punschrulle\\media\\textures\\Luna",
	Lyfe = "Interface\\AddOns\\Punschrulle\\media\\textures\\Lyfe",
	Minimalist = "Interface\\AddOns\\Punschrulle\\media\\textures\\Minimalist",
	Otravi = "Interface\\AddOns\\Punschrulle\\media\\textures\\Otravi",
	Perl2 = "Interface\\AddOns\\Punschrulle\\media\\textures\\Perl2",
	Rocks = "Interface\\AddOns\\Punschrulle\\media\\textures\\Rocks",
	Ruben = "Interface\\AddOns\\Punschrulle\\media\\textures\\Ruben",
	Runes = "Interface\\AddOns\\Punschrulle\\media\\textures\\Runes",
	Skewed = "Interface\\AddOns\\Punschrulle\\media\\textures\\Skewed",
	Smooth = "Interface\\AddOns\\Punschrulle\\media\\textures\\Smooth",
	Striped = "Interface\\AddOns\\Punschrulle\\media\\textures\\Striped",
	Wisps = "Interface\\AddOns\\Punschrulle\\media\\textures\\Wisps",
	Xeon = "Interface\\AddOns\\Punschrulle\\media\\textures\\Xeon"
}
function Punschrulle_GetTexture(s)
	if PunschrulleTextures[s] then return PunschrulleTextures[s] end
	return ""
end

function Punschrulle_DeepCopy(a, b)
		if type(a) ~= "table" or type(b) ~= "table" then
				return
		end
		for k,v in pairs(a) do
			if type(v) ~= "table" then
				b[k] = v;
			else
				local x = {}
				Punschrulle_DeepCopy(v, x);
				b[k] = x;
				end       
			end
	return b;
end

Punschrulle_Initialize()