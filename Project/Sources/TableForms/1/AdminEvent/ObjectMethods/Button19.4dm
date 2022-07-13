
If (Core_Component_ExistsB("4D_Info_Report@"))
	//EXECUTE METHOD("aa4D_NP_Report_Compare_Display")  // compare of local reports.
	EXECUTE METHOD:C1007("aa4D_NP_Get_Last_Server_Report")
	
Else 
	uConfirm("server.log"; "4D_Info_Report was not found.")
End if 
