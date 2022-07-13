If (Records in set:C195("UserSet")>0)
	app_Log_Usage("log"; "JML"; "Sum Field")
	
	CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "HoldJML")
	
	USE SET:C118("UserSet")  //use POs user selected to process
	
	$total:=util_SumSelectedRecords(->[Job_Forms_Master_Schedule:67]DurationPrinting:37)
	
	USE NAMED SELECTION:C332("HoldJML")
	
	ALERT:C41(String:C10($total; "###,###,###,###.##")+" Printing hours for the selected records.")
	
Else 
	uConfirm("Select the jobs to add up."; "Ok"; "Cancel")
End if 