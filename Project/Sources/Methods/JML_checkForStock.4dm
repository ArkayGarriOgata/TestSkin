//%attributes = {"publishedWeb":true}
//PM: JML_checkForStock() -> 
//@author mlb - 4/9/02  11:11

zwStatusMsg("Stock"; [Job_Forms_Master_Schedule:67]JobForm:4)

If (RM_AllocationTest([Job_Forms_Master_Schedule:67]S_Number:7; [Job_Forms_Master_Schedule:67]JobForm:4))
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17=!00-00-00!)
		[Job_Forms_Master_Schedule:67]DateStockRecd:17:=4D_Current_date
		//added:=added+[JobMasterLog]JobForm+Char(13)
	End if 
	
Else 
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
		//lost:=lost+[JobMasterLog]JobForm+Char(13)
		[Job_Forms_Master_Schedule:67]DateStockRecd:17:=!00-00-00!
	End if 
End if 