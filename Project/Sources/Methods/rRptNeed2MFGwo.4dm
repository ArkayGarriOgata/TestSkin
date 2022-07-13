//%attributes = {"publishedWeb":true}
//rRptNeed2MFGwo
//upr 1330
//•071797  mBohince  old colateral damage to chg of qryOpenOrdLines
dDateBegin:=4D_Current_date
dDateEnd:=4D_Current_date+7
DIALOG:C40([zz_control:1]; "DateRange2")
If (ok=1)
	
	If (bSearch=0)
		SET WINDOW TITLE:C213("Need to Manufacture Report w/o Rels from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1))
		ERASE WINDOW:C160
		
		qryOpenOrdLines("*")
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]NeedDate:14<=dDateEnd; *)  //•071797  mBohince  old colateral damage
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]NeedDate:14>=dDateBegin; *)  //•071797  mBohince  old colateral damage
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]QtyWithRel:20=0)  //•071797  mBohince  old colateral damage
		
		
		
		t2b:="Sorted by Product Code and Date Needed"
		t3:="from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
		
	Else 
		SET WINDOW TITLE:C213("Open F/G Orders (Custom Search)")
		ERASE WINDOW:C160
		qryOpenOrdLines
		QUERY SELECTION:C341([Customers_Order_Lines:41])
		
		
		t2b:="Sorted by Product Code and Date Needed"
		t3:="(Custom Search)"
	End if 
	
	// SORT SELECTION([ReleaseSchedule];[ReleaseSchedule]Sched_Date;>;[ReleaseSchedule
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]NeedDate:14; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Customers_Order_Lines:41]Qty_Open:11; r2; r3)
	util_PAGE_SETUP(->[Customers_Order_Lines:41]; "Need2MFGwo")
	PRINT SETTINGS:C106
	FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "Need2MFGwo")  //([ReleaseSchedule];"Need2MFG")
	t2:="NEED TO MANUFACTURE FOR ORDERS W/O RELEASES"
	
	PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
	FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")
End if 
//