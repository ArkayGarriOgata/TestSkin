//app_OpenSelectedIncludeRecords (->[Finished_Goods_Locations]Location;2;"Finished_Goods_Locations")

$selectionSetName:="clickedIncludeRecordFinished_Goods_Locations"
If (Records in set:C195($selectionSetName)>0)
	
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	CUT NAMED SELECTION:C334([Finished_Goods_Locations:35]; "holdNamedSelectionBefore")
	
	
	READ WRITE:C146([Finished_Goods_Locations:35])
	USE SET:C118($selectionSetName)
	If (fLockNLoad(->[Finished_Goods_Locations:35]))
		If ([Finished_Goods_Locations:35]Certified:41=!00-00-00!)
			$date:=4D_Current_date
		Else 
			$date:=[Finished_Goods_Locations:35]Certified:41
		End if 
		
		[Finished_Goods_Locations:35]Certified:41:=Date:C102(Request:C163("Enter the Date of Certification:"; String:C10($date; Internal date short special:K1:4); "OK"; "Clear"))
		If (ok=0)
			[Finished_Goods_Locations:35]Certified:41:=!00-00-00!
		End if 
		
		SAVE RECORD:C53([Finished_Goods_Locations:35])
		
		$id:=FGX_NewFG_Transaction("CERTIFY"; [Finished_Goods_Locations:35]Certified:41; <>zResp)
		[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods_Locations:35]CustID:16
		[Finished_Goods_Transactions:33]ProductCode:1:=[Finished_Goods_Locations:35]ProductCode:1
		[Finished_Goods_Transactions:33]Location:9:=[Finished_Goods_Locations:35]Location:2
		[Finished_Goods_Transactions:33]viaLocation:11:=[Finished_Goods_Locations:35]Location:2
		[Finished_Goods_Transactions:33]Qty:6:=[Finished_Goods_Locations:35]QtyOH:9
		[Finished_Goods_Transactions:33]JobNo:4:=Substring:C12([Finished_Goods_Locations:35]JobForm:19; 1; 5)
		[Finished_Goods_Transactions:33]JobForm:5:=[Finished_Goods_Locations:35]JobForm:19
		[Finished_Goods_Transactions:33]JobFormItem:30:=[Finished_Goods_Locations:35]JobFormItem:32
		[Finished_Goods_Transactions:33]Skid_number:29:=Request:C163("Skid Number?"; ""; "OK"; "Not Available")
		If (ok=0)
			[Finished_Goods_Transactions:33]Skid_number:29:="n/a"
		End if 
		SAVE RECORD:C53([Finished_Goods_Transactions:33])
		UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
	End if 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
		
	Else 
		
		// SEE LINE 52
		
	End if   // END 4D Professional Services : January 2019 
	READ ONLY:C145([Finished_Goods_Locations:35])
	USE NAMED SELECTION:C332("holdNamedSelectionBefore")
	
Else 
	uConfirm("Please select a Location record to Certify."; "OK"; "Help")
End if 