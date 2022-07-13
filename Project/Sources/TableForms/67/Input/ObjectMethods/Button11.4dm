
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