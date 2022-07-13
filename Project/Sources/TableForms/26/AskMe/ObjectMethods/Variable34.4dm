//app_OpenSelectedIncludeRecords (->[Finished_Goods_Locations]Location;2;"Finished_Goods_Locations")

$selectionSetName:="clickedIncludeRecordFinished_Goods_Locations"
If (Records in set:C195($selectionSetName)>0)
	
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdNamedSelectionBefore")
	
	
	READ WRITE:C146([Finished_Goods_Locations:35])
	USE SET:C118($selectionSetName)
	If (fLockNLoad(->[Finished_Goods_Locations:35]))
		If ([Finished_Goods_Locations:35]KillStatus:30=1)
			[Finished_Goods_Locations:35]KillStatus:30:=0
		Else 
			[Finished_Goods_Locations:35]KillStatus:30:=1
		End if 
		SAVE RECORD:C53([Finished_Goods_Locations:35])
	End if 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		
	Else 
		
		// see line 30
		
	End if   // END 4D Professional Services : January 2019 
	READ ONLY:C145([Finished_Goods_Locations:35])
	USE NAMED SELECTION:C332("holdNamedSelectionBefore")
	
Else 
	uConfirm("Please select a Location record to (un)Kill."; "OK"; "Help")
End if 