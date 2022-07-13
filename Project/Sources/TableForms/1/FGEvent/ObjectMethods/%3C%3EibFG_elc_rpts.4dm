// ----------------------------------------------------
// Method: [zz_control].FGEvent.bELC
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aELCRptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					$id:=New process:C317("ELC_ExcessInventory"; <>lMinMemPart; "ELC Excess Inventory")
					
				: ($user_choice=2)
					$id:=New process:C317("ELC_MADwarningRpt"; <>lMinMemPart; "ELC MAD Warning")
					
				: ($user_choice=3)
					$id:=New process:C317("ELC_ArtNeededRpt"; <>lMinMemPart; "ELC Tooling Needed")  //
					
				: ($user_choice=4)
					$id:=New process:C317("ELC_OrderPattern"; <>lMinMemPart; "ELC Order Pattern")  // 
					
				: ($user_choice=5)  //• mlb - 1/28/02  15:50
					$id:=New process:C317("ELC_CommodityOverviewRpt"; <>lMinMemPart; "ELC Commodity Overview")
					
				: ($user_choice=6)  //• mlb - 1/28/02  15:50
					$id:=New process:C317("ELC_MissedOpenLookUp"; <>lMinMemPart; "ELC Missed/Open Lookup Table")
					
				: ($user_choice=7)  //• mlb - 1/28/02  15:50
					$id:=New process:C317("ELC_WeeksCoveredRpt"; <>lMinMemPart; "ELC Weeks Covered")
					//
				: ($user_choice=8)  //• mlb - 5/14/09
					$id:=New process:C317("ELC_AgeFGfifoLauder_Liabilities"; <>lMinMemPart; "ELC Liabilities")
					
				: ($user_choice=9)  //• mlb - 5/14/09  15:50
					$id:=New process:C317("ELC_Supply_v_Demand"; <>lMinMemPart; "Supply v Demand")
					
				: ($user_choice=10)  //• mlb - 5/14/09  15:50
					$id:=New process:C317("ELC_EMEA_Extract"; <>lMinMemPart; "ELC_EMEA_Extract")
					
				: ($user_choice=11)  //• mlb - 5/14/09  15:50
					$id:=New process:C317("ELC_Suggest_Moves_To_Remote_Whs"; <>lMinMemPart; "ELC_Move_Candidates")
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 