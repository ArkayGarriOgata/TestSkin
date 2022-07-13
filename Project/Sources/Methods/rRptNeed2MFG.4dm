//%attributes = {"publishedWeb":true}
//rRptNeed2MFG
//upr 1286 11/11/94
dDateBegin:=4D_Current_date
dDateEnd:=4D_Current_date+7
DIALOG:C40([zz_control:1]; "DateRange2")
If (ok=1)
	
	If (bSearch=0)
		SET WINDOW TITLE:C213("Need to Manufacture Report from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1))
		ERASE WINDOW:C160
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A")
		t2b:="Sorted by Product Code and Schedule Date"
		t3:="from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
		
	Else 
		SET WINDOW TITLE:C213("Need to Manufacture Report (Custom Search)")
		ERASE WINDOW:C160
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46])
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		t2b:="Sorted by Product Code and Schedule Date"
		t3:="(Custom Search)"
	End if 
	
	// SORT SELECTION([ReleaseSchedule];[ReleaseSchedule]Sched_Date;>;[ReleaseSchedule
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Customers_ReleaseSchedules:46]Sched_Qty:6; r2; r3)
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "Need2MFG")
	PRINT SETTINGS:C106
	FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "Need2MFG")
	t2:="NEED TO MANUFACTURE FOR OPEN RELEASES"
	
	PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
	FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "List")
End if 
//