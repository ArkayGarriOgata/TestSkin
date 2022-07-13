If (Records in set:C195("clickedIncludeRecord")>0)
	app_Log_Usage("log"; "PS Sum Field")
	
	CUT NAMED SELECTION:C334([ProductionSchedules:110]; "HoldPS")
	
	USE SET:C118("clickedIncludeRecord")  //use POs user selected to process
	
	$total:=util_SumSelectedRecords(->[ProductionSchedules:110]ThruPutValueOfJob:78)
	
	USE NAMED SELECTION:C332("HoldPS")
	
	ALERT:C41(String:C10($total; "###,###,###,###.##")+" Thru-put for the selected records.")
	
Else 
	uConfirm("Select the sequences to add up."; "Ok"; "Cancel")
End if 