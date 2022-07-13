// ----------------------------------------------------
// Object Method: [zz_control].FGEvent.<>ib_delvr_schd
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			If (User in group:C338(Current user:C182; "RolePlanner"))
				$menu_items:="(Proter and Gamble;Import 'csv';(Import 'txt';Compare;(-;(Eliz Arden;Import 'csv';(Compare;(-;(Loreal;Import 'txt';Compare"  // Modified by: Mark Zinke (7/31/13) Added csv
			Else   //Everything is disabled
				$menu_items:="(Proter and Gamble;(Import 'csv';(Import 'txt';(Compare;(-;(Eliz Arden;(Import 'csv';(Compare"  // Modified by: Mark Zinke (7/31/13) Added csv
			End if 
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=2)
					$pid:=New process:C317("PnG_DeliverySchedule_v2"; <>lMinMemPart; "Importing P&G Delivery Schedule")
					app_Log_Usage("log"; "PnG_DeliverySchedule"; "Importing P&G Delivery Schedule")
					
				: ($user_choice=3)  // Added by: Mark Zinke (7/31/13)
					BEEP:C151  //$pid:=New process("PnG_DeliverySchedule_v3";<>lMinMemPart;"Importing P&G Delivery Schedule")
					app_Log_Usage("log"; "PnG_DeliverySchedule3"; "Importing P&G Delivery Schedule3")
					
				: ($user_choice=4)
					$pid:=New process:C317("PnG_DeliveryScheduleCompare"; <>lMinMemPart; "Comparing P&G Delivery Schedule")
					app_Log_Usage("log"; "PnG_DeliveryScheduleCompare"; "Comparing P&G Delivery Schedule")
					
				: ($user_choice=7)
					$pid:=New process:C317("Arden_DeliverySchedule2"; <>lMinMemPart; "Importing Arden Delivery Schedule")
					app_Log_Usage("log"; "Arden_DeliverySchedule2"; "Importing Arden Delivery Schedule")
					
				: ($user_choice=8)
					$pid:=New process:C317("Arden_DeliveryScheduleCompare"; <>lMinMemPart; "Comparing Arden Delivery Schedule")
					app_Log_Usage("log"; "Arden_DeliverySchedule"; "Comparing Arden Delivery Schedule")
					
				: ($user_choice=11)
					$pid:=New process:C317("Loreal_DeliverySchedule"; <>lMinMemPart; "Comparing Loreal Delivery Schedule")
					app_Log_Usage("log"; "Loreal_DeliverySchedule"; "Importing Loreal Delivery Schedule")
					
				: ($user_choice=12)
					$pid:=New process:C317("Loreal_DeliveryScheduleCompare"; <>lMinMemPart; "Comparing Loreal Delivery Schedule")
					app_Log_Usage("log"; "Loreal_DeliverySchedule"; "Comparing Loreal Delivery Schedule")
					
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 