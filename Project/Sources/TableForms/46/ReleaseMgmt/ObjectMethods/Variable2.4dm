

If (cbFcst=1)
	CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "calc")  //•022597  MLB  
	USE NAMED SELECTION:C332("calc")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39=0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A")
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "LookReady")
		
		ELC_RFM("required")
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "NeedMode")
		DIFFERENCE:C122("LookReady"; "NeedMode"; "LookReady")
		
		ELC_RFM("waiting")
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "NeedMode")
		DIFFERENCE:C122("LookReady"; "NeedMode"; "LookReady")
		USE SET:C118("LookReady")
		CLEAR SET:C117("LookReady")
		CLEAR SET:C117("NeedMode")
		
	Else 
		
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "LookReady")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39=0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A")
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "NeedMode")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Addresses:30]RequestForModeEmailTo:17#""; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		DIFFERENCE:C122("LookReady"; "NeedMode"; "LookReady")
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "NeedMode")
		QUERY:C277([Customers_ReleaseSchedules:46]; [Addresses:30]RequestForModeEmailTo:17#""; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48#!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_2:49=!00-00-00!; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		DIFFERENCE:C122("LookReady"; "NeedMode"; "LookReady")
		USE SET:C118("LookReady")
		CLEAR SET:C117("LookReady")
		CLEAR SET:C117("NeedMode")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
	windowTitle:=String:C10($numRels)+" Open F/G Releases that are READY TO SHIP"
Else 
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
	windowTitle:=String:C10($numRels)+" Open F/G Releases from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
End if 

ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >)

SET WINDOW TITLE:C213(windowTitle)