//%attributes = {"publishedWeb":true}
//Procedure: rRptOpenRels()   MLB
//print a supply/demand analysis based on release information
C_REAL:C285(r2; r3; r4; r5; r6; r7)  //qty of fg, nonFg, excess/shortage, value based on price, planned prod, prodFlag
dDateBegin:=4D_Current_date
dDateEnd:=4D_Current_date+7
DIALOG:C40([zz_control:1]; "DateRange2")
If (ok=1)
	
	If (bSearch=0)
		SET WINDOW TITLE:C213("Open F/G Releases from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1))
		ERASE WINDOW:C160
		//•071797  mBohince  give Walter a * if there are other release to be worked
		//SEARCH([ReleaseSchedule]; & [ReleaseSchedule]Sched_Date>dDateEnd;*)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY DATE:C224(aDate; 0)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; aCPN; [Customers_ReleaseSchedules:46]Sched_Date:5; aDate)
		SORT ARRAY:C229(aCPN; aDate; >)
		//•071797  mBohince  end
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		t2b:="Sorted by Schedule Date and 'Ship to'"
		t3:="from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
		
	Else 
		SET WINDOW TITLE:C213("Open F/G Releases (Custom Search)")
		ERASE WINDOW:C160
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46])
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		t2b:="Sorted by Schedule Date and 'Ship to'"
		t3:="(Custom Search)"
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY DATE:C224(aDate; 0)
	End if 
	
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >)
	//BREAK LEVEL(2)
	//ACCUMULATE([OrderLines]Count;real1;real2;real3;real4;real5;real6;real7)
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "OpenRel4MFG")
	PRINT SETTINGS:C106
	FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "OpenRel4MFG")
	t2:="OPEN RELEASES"
	
	PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
	ARRAY TEXT:C222(aCPN; 0)
	ARRAY DATE:C224(aDate; 0)
	FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "List")
End if 
//