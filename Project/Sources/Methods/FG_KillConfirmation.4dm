//%attributes = {}
// Method: FG_KillConfirmation () -> 
// ----------------------------------------------------
// by: mel: 07/28/05, 15:22:56
// ----------------------------------------------------

C_TEXT:C284($jobit)

SET MENU BAR:C67(<>DefaultMenu)

uConfirm("Kill or Revive?"; "Kill"; "Revive")
If (OK=1)
	app_Log_Usage("log"; "Kill"; "FG_KillConfirmation: KILL")
	$jobit:=Request:C163("Enter Jobit to confirm the Kill:"; ""; "Continue..."; "Cancel")
	If (OK=1)
		READ WRITE:C146([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$jobit)
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			uConfirm($jobit+" in "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" bins."; "Confirm Kill"; "Cancel")
			If (OK=1)
				APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30:=1)
			End if 
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		Else 
			BEEP:C151
			ALERT:C41($jobit+" jobit was not found.")
		End if 
	End if 
	
Else   //revive
	app_Log_Usage("log"; "Kill"; "FG_KillConfirmation: REVIVE")
	$jobit:=Request:C163("Enter Jobit to confirm the Revive:"; ""; "Continue..."; "Cancel")
	If (OK=1)
		READ WRITE:C146([Finished_Goods_Locations:35])
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$jobit; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]KillStatus:30=1)
		If (Records in selection:C76([Finished_Goods_Locations:35])>0)
			uConfirm($jobit+" in "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" bins."; "Revive"; "Cancel")
			If (OK=1)
				APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30:=0)
			End if 
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		Else 
			BEEP:C151
			ALERT:C41($jobit+" jobit was not found in Kill status 1.")
		End if 
	End if 
End if 