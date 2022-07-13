//%attributes = {"publishedWeb":true}
//(p) rUNplannedRpt
//created cs 2/28/97 upr 1848
//called from report popup on FG pallete
//FUTURE - need to ad ability to examine production as well as OH
//
uDialog("SelectSortOrder"; 250; 150)  //get user to select sort order for report
If (OK=1)
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "UnplannedRpt")
	PRINT SETTINGS:C106
	If (OK=1)  //if print settings OKed
		NewWindow(500; 350; 0; 0; "Unplanned Production")  //window to display print to screen
		
		//sorted by product code, sorted by scheld date
		
		//ask me examine qty oh for the F/G determine if the on oh amount >= require reale
		//get total fg_locations for each prod, as printing each rel subtract that realses
		//also look into procudtion for the prod 
		//JMI qty yeild - cust/prod, actual qty
		//batchTHC - 3 field in relase sched - project qty
		//thc-qty, thc date, thc state
		//thc state - 0-> 8
		//look in batch THC  for description 
		//machine tickets -
		//realse -> curent prod based on machinticket
		//  pland prod based on JMI actual =0 and NO machineticket
		//  0< actual < want qty
		//all stock hasmfg
		//
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)  //locate unplaned
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11#"#SpecialBilling"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"rtn@")
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)  //somethig was found
			
			Case of 
				: (rbBoth=1)  //sorting by both production & date
					ORDER BY:C49([Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
					t2:="- Sorted by Product then Release Date"
					t3:="Product Total"  //title for sub total line
				: (rbProduct=1)  //sort by product code only
					ORDER BY:C49([Customers_ReleaseSchedules:46]ProductCode:11; >)
					t2:="- Sorted by Product"
					t3:="Product Total"  //title for sub total line
				: (rbRelease=1)  //sort by date only
					ORDER BY:C49([Customers_ReleaseSchedules:46]Sched_Date:5; >)
					t2:="- Sorted by Release Date"
					t3:="Rel. Data Total"  //title for sub total line
			End case 
			BREAK LEVEL:C302(1)
			ACCUMULATE:C303(rSubtotal; [Customers_ReleaseSchedules:46]Sched_Qty:6)
			FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "UnPlannedRpt")
			PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
		End if 
		CLOSE WINDOW:C154
		FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "List")
	End if 
End if 
//