iQty:=Num:C11(Request:C163("How many "+[Raw_Materials:21]IssueUOM:10+" of "+[Raw_Materials:21]Raw_Matl_Code:1+" do you want?"; "0"; "Continue"; "Cancel"))
If (ok=1) & (iQty>0)
	sJobit:="Roanoke"
	sJobit:=Request:C163("Jobform# to ISSUE or 'Roanoke' to MOVE."; sJobit; "Continue"; "Cancel")
	If (ok=1) & (Length:C16(sJobit)>0)
		dDateBegin:=4D_Current_date+1
		dDateBegin:=Date:C102(Request:C163("When do you need it?"; String:C10(dDateBegin; System date short:K1:1); "Submit"; "Cancel"))
		If (ok=1)
			If (dDateBegin<4D_Current_date)
				dDateBegin:=4D_Current_date
			End if 
			
			CREATE RECORD:C68([WMS_WarehouseOrders:146])
			[WMS_WarehouseOrders:146]id:1:=app_AutoIncrement(->[WMS_WarehouseOrders:146])
			[WMS_WarehouseOrders:146]JobReference:4:=sJobit
			[WMS_WarehouseOrders:146]Needed:5:=dDateBegin
			[WMS_WarehouseOrders:146]Qty:3:=iQty
			[WMS_WarehouseOrders:146]RawMatlCode:2:=[Raw_Materials:21]Raw_Matl_Code:1
			SAVE RECORD:C53([WMS_WarehouseOrders:146])
			UNLOAD RECORD:C212([WMS_WarehouseOrders:146])
			
		Else 
			BEEP:C151
		End if 
		
	Else 
		BEEP:C151
	End if 
	
Else 
	BEEP:C151
End if 
