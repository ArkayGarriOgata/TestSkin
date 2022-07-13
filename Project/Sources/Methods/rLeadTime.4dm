//%attributes = {"publishedWeb":true}
//(p) rLeadTime
//print a report showing who and how many POs
//are created by  specific individuals which have short notice order ranges
//• 6/30/98 cs created

C_LONGINT:C283(w2)

W2:=0

Repeat 
	W2:=Num:C11(Request:C163("Enter Number of Days of Lead Time."; "5"))
Until (OK=0) | (W2>0)

If (OK=1)
	MESSAGES OFF:C175
	NewWindow(200; 50; 0; -720)
	MESSAGE:C88("  Searching Purchase orders -      this may take a few minutes...")
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5>""; *)  //do this to help speed search
	QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]Required:27>!00-00-00!)
	QUERY SELECTION BY FORMULA:C207([Purchase_Orders:11]; ([Purchase_Orders:11]PODate:4>([Purchase_Orders:11]Required:27-W2)))
	
	If (Records in selection:C76([Purchase_Orders:11])>0)
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]ReqBy:6; >; [Purchase_Orders:11]PONo:1; >)
		CLOSE WINDOW:C154
		BREAK LEVEL:C302(1)
		util_PAGE_SETUP(->[Purchase_Orders:11]; "rLeadTime")
		PRINT SETTINGS:C106
		
		If (OK=1)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "rLeadTime")
			PRINT SELECTION:C60([Purchase_Orders:11]; *)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")
		End if 
		uClearSelection(->[Purchase_Orders:11])
		uClearSelection(->[Purchase_Orders_Items:12])
		uClearSelection(->[Purchase_Orders_Job_forms:59])
		uClearSelection(->[Vendors:7])
		uClearSelection(->[Users:5])
	Else 
		ALERT:C41("Sorry NO Purchase orders found with lead time less than "+String:C10(W2)+" days.")
		CLOSE WINDOW:C154
	End if 
End if 