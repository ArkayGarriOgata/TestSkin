//%attributes = {"publishedWeb":true}
//(p) rPOItemsByJob
//locate PO items by job (form)
//print a report to show items' recevied status
//• 7/28/98 cs created

uDialog("LocatePoItems"; 250; 180)

If (OK=1)  //user wants to print
	USE SET:C118("found")
	CLEAR SET:C117("Found")
	
	If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
		util_PAGE_SETUP(->[Purchase_Orders_Job_forms:59]; "POItemsByJob")
		PRINT SETTINGS:C106
		
		If (OK=1)
			SET WINDOW TITLE:C213("Printing Locate Po Items for "+String:C10(Records in selection:C76([Purchase_Orders_Job_forms:59]))+" Jobs")
			ORDER BY:C49([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2; >; [Purchase_Orders_Job_forms:59]POItemKey:1; >)
			FORM SET OUTPUT:C54([Purchase_Orders_Job_forms:59]; "POItemsByJob")
			PRINT SELECTION:C60([Purchase_Orders_Job_forms:59]; *)
			FORM SET OUTPUT:C54([Purchase_Orders_Job_forms:59]; "List")
		End if 
	End if 
End if 

uClearSelection(->[Purchase_Orders_Job_forms:59])
uClearSelection(->[Purchase_Orders_Items:12])
uClearSelection(->[Raw_Materials_Transactions:23])
ARRAY TEXT:C222(aText; 0)