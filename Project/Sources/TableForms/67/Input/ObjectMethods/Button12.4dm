//OM: bChgStock() -> 
//@author mlb - 9/12/02  14:30

$newStock:=Request:C163("Change stock to R/M code:"; [Job_Forms_Master_Schedule:67]S_Number:7; "Change"; "Cancel")
If (ok=1)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numRM)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$newStock; *)
	QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]CommodityCode:26=1)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numRM=1)
		[Job_Forms_Master_Schedule:67]S_Number:7:=$newStock
		
		READ WRITE:C146([Raw_Materials_Allocations:58])
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Master_Schedule:67]JobForm:4)
		If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
			[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=$newStock
			SAVE RECORD:C53([Raw_Materials_Allocations:58])
		End if 
		REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
		
		If (RM_AllocationTest([Job_Forms_Master_Schedule:67]S_Number:7; [Job_Forms_Master_Schedule:67]JobForm:4))
			If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
				[Job_Forms_Master_Schedule:67]DateStockRecd:17:=4D_Current_date
			End if 
			
		Else 
			[Job_Forms_Master_Schedule:67]DateStockRecd:17:=!00-00-00!
		End if 
		
		If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
			Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateStockRecd:17; -(14+(256*12)))  //grey
		Else 
			Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateStockRecd:17; -(Black:K11:16+(256*12)))  //  
		End if 
		
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		
	Else 
		BEEP:C151
		ALERT:C41($newStock+" was not found.")
	End if 
	
	
End if 