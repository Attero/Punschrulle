Punsch_Tables_KnownChannels = {
	--This table is just used to find the spellname from the icon. Should only contain unnamed channeled spells cast by the user
	ByIcon = {
		MAGE = {
			["Interface\\Icons\\Spell_Frost_IceStorm"] = "Blizzard",
			["Interface\\Icons\\Spell_Nature_Purge"] = "Evocation" ,
			["Interface\\Icons\\Spell_Nature_StarFall"] = "Arcane Missiles",
		},
		PRIEST = {
			["Interface\\Icons\\Spell_Holy_MindVision"] = "Mind Vision",
			["Interface\\Icons\\Spell_Shadow_SiphonMana"] = "Mind Flay",
		},
		WARLOCK = {
			["Interface\\Icons\\Spell_Shadow_RainOfFire"] = "Rain of Fire",
			["Interface\\Icons\\Spell_Shadow_Haunting"] = "Drain Soul",
			["Interface\\Icons\\Spell_Shadow_LifeDrain02"] = "Drain Life",
			["Interface\\Icons\\Spell_Shadow_SiphonMana"] = "Drain Mana",
			["Interface\\Icons\\Spell_Fire_Incinerate"] = "Hellfire",
			["Interface\\Icons\\Spell_Shadow_LifeDrain"] = "Health Funnel"
		},
		HUNTER = {
			["Interface\\Icons\\Ability_Hunter_EagleEye"] = "Eagle Eye",
			["Interface\\Icons\\Ability_Hunter_MendPet"] = "Mend Pet",
			["Interface\\Icons\\Ability_Hunter_BeastTaming"] = "Tame Beast",
		},
		DRUID = {
			["Interface\\Icons\\Spell_Nature_Cyclone"] = "Hurricane",
			["Interface\\Icons\\Spell_Nature_Tranquility"] = "Tranquility",
		},
		SHARED = {
			["Interface\\Icons\\INV_Misc_Bandage_12"] = "Heavy Runecloth Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_11"] = "Runecloth Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_20"] = "Heavy Mageweave Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_19"] = "Mageweave Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_02"] = "Heavy Silk Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_01"] = "Silk Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_17"] = "Heavy Wool Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_14"] = "Wool Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_18"] = "Heavy Linen Bandage",
			["Interface\\Icons\\INV_Misc_Bandage_15"] = "Linen Bandage",

		}
	},
	--This table contains all information needed to show ticks on channels properly
	ByName = {
		["Blizzard"] = {
			Tick = "time",
			TickCount = 8
		},
		["Arcane Missiles"] = {
			Tick = "time",
			TickCount = 5
		},
		["Evocation"] = {
			Tick = "mana",
		},
		["Mind Flay"] = {
			Tick = "time",
			TickCount = 3
		},
		["Rain of Fire"] = {
			Tick = "time",
			TickCount = 4
		},
		["Drain Soul"] = {
			Tick = "time",
			TickCount = 5
		},
		["Drain Life"] = {
			Tick = "time",
			TickCount = 5
		},
		["Drain Mana"] = {
			Tick = "time",
			TickCount = 5
		},
		["Hellfire"] = {
			Tick = "time",
			TickCount = 15
		},
		["Health Funnel"] = {
			Tick = "time",
			TickCount = 10
		},
		["Mend Pet"] = {
			Tick = "time",
			TickCount = 5
		},
		["Hurricane"] = {
			Tick = "time",
			TickCount = 10
		},
		["Tranquility"] = {
			Tick = "time",
			TickCount = 5
		},

		--item based channels
		["Heavy Runecloth Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Runecloth Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Heavy Mageweave Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Mageweave Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Heavy Silk Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Silk Bandage"] = {
			Tick = "time",
			TickCount = 8
		},
		["Heavy Wool Bandage"] = {
			Tick = "time",
			TickCount = 7
		},
		["Wool Bandage"] = {
			Tick = "time",
			TickCount = 7
		},
		["Heavy Linen Bandage"] = {
			Tick = "time",
			TickCount = 6
		},
		["Linen Bandage"] = {
			Tick = "time",
			TickCount = 6
		},

		--racial channel
		["Cannibalize"] = {
			Tick = "time",
			TickCount = 5,
			Icon = "Interface\\Icons\\Ability_Racial_Cannibalize"
		},
	}
}

--[[Implement these to an exceptiontable for world object interactions. eventually. maybe. someday.
	["First Aid"] = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
	["Herb Gathering"] = "Interface\\Icons\\INV_Misc_Flower_02",
--]]
	--/script message(ActionButton1Icon:GetTexture())

Punsch_Tables_ProfilePresets = {
	Default = {
		Name = "New Profile (Default)",
		MuteWelcomeMessage = false,
		["Entities"] = {
			["Castbar"] = {
				--Entity
				Width = 355,
				Height = 30,
				Anchor = {
					X = -177,
					Y = -215.5,
					rPoint = "CENTER",
					rTo = "",
					Point = "TOPLEFT"
				},
				Bg = {
					r = 0,
					g = 0,
					b = 0,
					a = 1
				},
				Fill = {
					r = 0.54,
					g = 0.54,
					b = 0.54,
					a = 1
				},

				Texture = "Minimalist",
				Border = {
					Show = false,
					Padding = 4,
					Size = 16,
					r = 0,
					g = 0,
					b = 0,
					a = 1,
					OnTop = true
				},

				--Bar
				AlwaysShow = false,

				ShowTextureOnFullBar = true,
				StretchTexture = false,
				Decimals = 1,

				BorderEncompassIcon = false,

				ShowIcon = true,
				IconPadding = 1,

				Spark = {
					Enable = true,
					Height = 60,
					Width = 15,
					r = 0.13,
					g = 0.23,
					b = 0.34,
					a = 1,
				},

				TextLeft = {
					X = 3,
					Y = 0,
					rPoint = "LEFT",
					Point = "LEFT",
					r = 1,
					g = 1,
					b = 1,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 1,
					Font = "Vixar",
					FontSize = 14,
					FontShadowX = 0.8,
					FontShadowY = -0.8,
				},

				TextRight = {
					X = -3,
					Y = 0,
					rPoint = "RIGHT",
					Point = "RIGHT",
					r = 1,
					g = 1,
					b = 1,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 1,
					Font = "Vixar",
					FontSize = 14,
					FontShadowX = 0.8,
					FontShadowY = -0.8,
					Spacing = 1,
				},

				Frame = {
					Enable = true,
					Thickness = 0.8,
					InnerBorderSize = 0,
					OuterBorderSize = 0,
					Borderr = 1,
					Borderg = 1,
					Borderb = 1,
					Bordera = 0,
					r = 0,
					g = 0,
					b = 0,
					a = 1,
				},

				--Castbar

				ShowMultiShot = false,
				ShowAimedShot = true,

				ShowRank = false,
				RankAsRoman = true,
				RankAsShort = true,
				UpperCaseSpellName = false,

				CountUpOnCast = true,
				CountUpOnChannel = false,

				ShowLag = true,


				Tick = {
					Enable = true,
					ShowLag = false,
					AsSolidColor = false,
					TopAnchor = 0,
					BotAnchor = 0.15,
					Width = 3.2,
					r = 0,
					g = 0,
					b = 0,
					a = 1
				},

				HideBlizzardBar = true,

				FillChannel = {
					r = 0.54,
					g = 0.54,
					b = 0.54,
					a = 1
				},

				Lag = {
					r = 0.95,
					g = 1,
					b = 1,
					a = 1
				},

				TextDelay = {
					X = -3,
					Y = 0,
					rPoint = "LEFT",
					Point = "RIGHT",
					r = 0.85,
					g = 0,
					b = 0,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 0,
					Font = "Vixar",
					FontSize = 14,
					FontShadowX = 0.8,
					FontShadowY = -0.8,
					AnchorToDuration = true,
				},

				TextLag = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 1,
					Font = "",
					FontSize = 9,
					FontShadowX = 1,
					FontShadowY = -1,
				},

				Fade = {
					Enable = true,
					OnChannel = false,
					Time = 0.9,
					PlayerInterruptAsFailure = true,
					FailureHoldTime = 0,
					SuccessHoldTime = 0,
					ShowLagWhileFading = true,
					Success = {
						r = 0.2,
						g = 0.6,
						b = 0.2,
						a = 1
					},
					Failure = {
						r = 0.6,
						g = 0.2,
						b = 0.2,
						a = 1
					},
					Tolerance = 0.3,
				},

				ChannelDelayToDuration = false
			},
			["Mirror"] = {
				--Entity
				Width = 170,
				Height = 11,
				Anchor = {
					X = 0,
					Y = 1,
					rPoint = "TOPRIGHT",
					rTo = "Castbar",
					Point = "BOTTOMRIGHT"
				},
				Bg = {
					r = 0,
					g = 0,
					b = 0,
					a = 1
				},

				Texture = "Minimalist",

				Border = {
					Show = false,
					Padding = 4,
					Size = 16,
					r = 0,
					g = 0,
					b = 0,
					a = 1,
					OnTop = true
				},

				--Bar
				AlwaysShow = false,
				ShowTextureOnFullBar = false;
				StretchTexture = false,
				Decimals = 1,

				BorderEncompassIcon = false,

				ShowIcon = true,
				IconPadding = 1,

				Spark = {
					Enable = true,
					Height = 22,
					Width = 15,
					r = 0.13,
					g = 0.23,
					b = 0.34,
					a = 1,
				},

				TextLeft = {
					X = 2,
					Y = 0,
					rPoint = "LEFT",
					Point = "LEFT",
					r = 1,
					g = 1,
					b = 1,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 1,
					Font = "Vixar",
					FontSize = 10,
					FontShadowX = 0.8,
					FontShadowY = -0.8,
				},

				TextRight = {
					X = -2,
					Y = 0,
					rPoint = "RIGHT",
					Point = "RIGHT",
					r = 1,
					g = 1,
					b = 1,
					a = 1,
					sr = 0,
					sg = 0,
					sb = 0,
					sa = 1,
					Font = "Vixar",
					FontSize = 10,
					FontShadowX = 0.8,
					FontShadowY = -0.8,
				},

				Frame = {
					Enable = true,
					Thickness = 0.8,
					InnerBorderSize = 0,
					OuterBorderSize = 0,
					Borderr = 1,
					Borderg = 1,
					Borderb = 1,
					Bordera = 0,
					r = 0,
					g = 0,
					b = 0,
					a = 1,
				},

				--Mirror
				GrowUp = true, 
				Padding = 1,
				HideBlizzardBar = true,

				Fade = {
					Enable = true,
					Time = 0.9,
					HoldTime = 0,
				},
				Events = {
					BREATH = {
						label = "Breath",
						enable = true,
						r = 0,
						g = 0.5,
						b = 1,
						a = 1,
						icon = "Interface\\Icons\\Spell_Shadow_DemonBreath"
					},
					EXHAUSTION = {
						label = "Exhaustion",
						enable = true,
						r = 1,
						g = 0.9,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Ability_Suffocate"
					},
					FEIGNDEATH = {
						label = "Feign Death",
						enable = true,
						r = 1,
						g = 0.7,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Ability_Rogue_FeignDeath"
					},
					CAMP = {
						label = "Logout",
						enable = true,
						r = 1,
						g = 0.7,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Spell_Magic_PolymorphChicken"
					},
					QUIT = {
						label = "Quit Game",
						enable = true,
						r = 1,
						g = 0.7,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Spell_Magic_PolymorphChicken"
					},
					BOOT = {
						label = "Instance Boot",
						enable = true,
						r = 1,
						g = 0,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\INV_Misc_Rune_01"
					},
					SUMMON = {
						label = "Summon",
						enable = true,
						r = 1,
						g = 0.3,
						b = 1,
						a = 1,
						icon = "Interface\\Icons\\Spell_Shadow_Twilight"
					},
					GAMESTART = {
						label = "Game Start",
						enable = true,
						r = 0,
						g = 1,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Ability_DualWield"
					},
					WSG_FLAGRESPAWN = {
						label = "Flag respawn",
						enable = true,
						r = 0,
						g = 1,
						b = 0,
						a = 1,
						icon = "Interface\\Icons\\Ability_DualWield"
					},
				}
			},
		}
	},
}
