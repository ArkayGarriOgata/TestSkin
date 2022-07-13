//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aELCRptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			
			Case of 
				: ($user_choice=1)
					app_Log_Usage("log"; "ELC"; "ELC Excess Inventory")
					$id:=New process:C317("ELC_ExcessInventory"; <>lMinMemPart; "ELC Excess Inventory")
					
				: ($user_choice=2)
					app_Log_Usage("log"; "ELC"; "ELC MAD Warning")
					$id:=New process:C317("ELC_MADwarningRpt"; <>lMinMemPart; "ELC MAD Warning")
					
				: ($user_choice=3)
					app_Log_Usage("log"; "ELC"; "ELC Tooling Needed")
					$id:=New process:C317("ELC_ArtNeededRpt"; <>lMinMemPart; "ELC Tooling Needed")  //
					
				: ($user_choice=4)
					app_Log_Usage("log"; "ELC"; "ELC Order Pattern")
					$id:=New process:C317("ELC_OrderPattern"; <>lMinMemPart; "ELC Order Pattern")  // 
					
				: ($user_choice=5)  //• mlb - 1/28/02  15:50
					app_Log_Usage("log"; "ELC"; "ELC Commodity Overviewy")
					$id:=New process:C317("ELC_CommodityOverviewRpt"; <>lMinMemPart; "ELC Commodity Overview")
					
				: ($user_choice=6)  //• mlb - 1/28/02  15:50
					app_Log_Usage("log"; "ELC"; "ELC Missed/Open")
					$id:=New process:C317("ELC_MissedOpenLookUp"; <>lMinMemPart; "ELC Missed/Open Lookup Table")
					
				: ($user_choice=7)  //• mlb - 1/28/02  15:50
					app_Log_Usage("log"; "ELC"; "ELC Weeks Covered")
					$id:=New process:C317("ELC_WeeksCoveredRpt"; <>lMinMemPart; "ELC Weeks Covered")
					//
				: ($user_choice=8)  //• mlb - 5/14/09
					app_Log_Usage("log"; "ELC"; "ELC Liabilities")
					$id:=New process:C317("ELC_AgeFGfifoLauder_Liabilities"; <>lMinMemPart; "ELC Liabilities")
					
				: ($user_choice=9)  //• mlb - 5/14/09  15:50
					app_Log_Usage("log"; "ELC"; "ELC Supply v Demand")
					$id:=New process:C317("ELC_Supply_v_Demand"; <>lMinMemPart; "Supply v Demand")
					
				: ($user_choice=10)  //• mlb - 5/14/09  15:50
					app_Log_Usage("log"; "ELC"; "ELC EMEA_Extract")
					$id:=New process:C317("ELC_EMEA_Extract"; <>lMinMemPart; "ELC_EMEA_Extract")
					
				: ($user_choice=11)  //• mlb - 5/14/09  15:50
					app_Log_Usage("log"; "ELC"; "ELC Move_Candidates")
					$id:=New process:C317("ELC_Suggest_Moves_To_Remote_Whs"; <>lMinMemPart; "ELC_Move_Candidates")
					
				: ($user_choice=12)  // Modified by: Mel Bohince (2/23/17) 
					app_Log_Usage("log"; "ELC"; "Waiting RFM")
					$id:=New process:C317("REL_RequestForModeRpt"; <>lMinMemPart; "REL_RequestForModeRpt")
					
				: ($user_choice=13)  // Modified by: Mel Bohince (2/23/17) 
					CONFIRM:C162("Are you insided the Arkay firewall?"; "Yes"; "No")
					If (ok=1)
						app_Log_Usage("log"; "ELC"; "Sending RFM")
						$id:=New process:C317("REL_RequestForModeOnDemand"; <>lMinMemPart; "REL_RequestForModeOnDemand")
					Else 
						ALERT:C41("Your emails to customers wouldn't be sent.")
					End if 
					//
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 

If (False:C215)
	REL_RequestForModeOnDemand
	REL_RequestForModeRpt
	ELC_Suggest_Moves_To_Remote_Whs
	ELC_EMEA_Extract
	ELC_Supply_v_Demand
	ELC_AgeFGfifoLauder_Liabilities
	ELC_WeeksCoveredRpt
	ELC_MissedOpenLookUp
	ELC_CommodityOverviewRpt
	ELC_ExcessInventory
	ELC_MADwarningRpt
	ELC_ArtNeededRpt
	ELC_OrderPattern
End if 