//zSetUsageStat ("AskMe";"Mod Rel";sCustID+":"+sCPN)
//• mlb - 2/12/03  16:19 use named selection
If (ListBox2#0)
	iMode:=2
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	GOTO RECORD:C242([Customers_ReleaseSchedules:46]; aRecNum{ListBox2})  //• mlb - 2/12/03  16:23
	uConfirm("Delete release "+[Customers_ReleaseSchedules:46]CustomerRefer:3+"?"; "Delete"; "Cancel")
	If (ok=1)
		DELETE RECORD:C58([Customers_ReleaseSchedules:46])
		PnP_DeliveryScheduleQry(sCPN)
	End if 
End if 
//