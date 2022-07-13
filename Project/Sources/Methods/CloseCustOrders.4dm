//%attributes = {"publishedWeb":true}
//Procedure: CloseCustOrders()  053195  MLB
//•053195  MLB  UPR 187
//•071295  MLB  add date closed
//•041996  MLB  slight optimizations
//set Order status to "Closed" if all order lines are in the "Closed" status 
//print a report of what happened during this batch
//set up the Order closeout analysis file  (FUTURE)
//archive the closed orders (FUTURE)
// Modified by: Mel Bohince (1/29/15) broaden the search to everything not closed or cancelled
// Modified by: Mel Bohince (1/13/17) make sure that close date is populated if closed so purge doesn't delete it
C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText)
C_LONGINT:C283($i; $countOrders; $openLines; $closed; $open; $linesFound)
C_DATE:C307($date)

$CR:=Char:C90(13)
$date:=4D_Current_date  //•041996  MLB  
$linesFound:=0  //•041996  MLB 

//*Find all the candidate Orders, for now those are statii = Accepted & Budgeted
//*.                                                 but not Canceled,Delete, 
//*.                                                      Hold@,Kill,New,Opened
xTitle:="Customer Order Close-out Summary for "+String:C10($date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"
READ ONLY:C145([Customers_Orders:40])
ALL RECORDS:C47([Customers_Orders:40])
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Customer Orders in aMs."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="New")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" New Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Opened")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Opened Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Cancel")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Cancel Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Delete")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Delete Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Kill")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Kill Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Hold@")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Hold@ Orders."
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Closed")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Closed Orders before this batch."
xText:=xText+$CR+"____________________________________________"

READ WRITE:C146([Customers_Orders:40])
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Accepted")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Accepted Orders."
//CREATE SET([Customers_Orders];"inAccepted")
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Budgeted")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Budgeted Orders."
//CREATE SET([Customers_Orders];"inBudget")
//UNION("inAccepted";"inBudget";"targets")

READ WRITE:C146([Customers_Orders:40])
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Contract")
xText:=xText+$CR+String:C10(Records in selection:C76([Customers_Orders:40]); "^^^,^^^,^^0")+" Contract Orders."
//CREATE SET([Customers_Orders];"inContract")
//UNION("targets";"inContract";"targets")

//USE SET("targets")
//CLEAR SET("inAccepted")
//CLEAR SET("inBudget")
//CLEAR SET("inContract")
//CLEAR SET("targets")
// Modified by: Mel Bohince (1/29/15) broaden the search to everything not closed or cancelled
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10#"Closed"; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10#"Cancel")

xText:=xText+$CR+"____________________________________________"+$CR+"Closed:"+$CR
//*.   For each candidate, test the status of the orderlines
$countOrders:=Records in selection:C76([Customers_Orders:40])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
	FIRST RECORD:C50([Customers_Orders:40])
	$closed:=0  // number of orders closed this time
	$cancelled:=0
	$openLines:=0  //number of non-closed orderlines at this time.
	$open:=0  //number of non-closed orders
	
Else 
	ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1; >)
	$closed:=0  // number of orders closed this time
	$cancelled:=0
	$openLines:=0  //number of non-closed orderlines at this time.
	$open:=0  //number of non-closed orders
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

MESSAGES OFF:C175
uThermoInit($countOrders; "Customer Order Close-out Analysis")

For ($i; 1; $countOrders)
	$linesFound:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $linesFound)  // Modified by: Mel Bohince (1/29/15) 
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed")
	//*.        If all order lines are closed, close the order and do the analysis
	//$linesFound:=Records in selection([Customers_Order_Lines])  //•041996  MLB 
	If ($linesFound=0)  //then lets close or cancel the header
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
		$ttl_num_lines:=$linesFound
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="Cancel")
		$numCanceled:=$linesFound
		If ($numCanceled=$ttl_num_lines)  // Modified by: Mel Bohince (1/29/15) 
			$newStatus:="Cancel"
			$cancelled:=$cancelled+1
			$dateClosed:=[Customers_Orders:40]ModDate:9
			
		Else 
			$newStatus:="Closed"
			$closed:=$closed+1
			ARRAY DATE:C224($aDate; 0)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="Closed")
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateCompleted:12; $aDate)
				SORT ARRAY:C229($aDate; <)
				$dateClosed:=$aDate{1}
			Else 
				$dateClosed:=[Customers_Orders:40]ModDate:9
			End if 
			
		End if 
		
		[Customers_Orders:40]Status:10:=$newStatus
		[Customers_Orders:40]DateClosed:49:=$dateClosed
		SAVE RECORD:C53([Customers_Orders:40])
		xText:=xText+String:C10([Customers_Orders:40]OrderNumber:1; "00000")+" "
		
		
	Else 
		$open:=$open+1
		$openLines:=$openLines+$linesFound  //•041996  MLB 
	End if 
	
	NEXT RECORD:C51([Customers_Orders:40])
	uThermoUpdate($i)
End for 
SET QUERY DESTINATION:C396(Into current selection:K19:1)
uThermoClose

// Modified by: Mel Bohince (1/13/17) 
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Closed"; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateClosed:49=!00-00-00!)
APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]DateClosed:49:=[Customers_Orders:40]ModDate:9)
REDUCE SELECTION:C351([Customers_Orders:40]; 0)

xText:=xText+$CR+"____________________________________________"
xText:=xText+$CR+String:C10($closed; "^^^,^^^,^^0")+" Orders closed in this batch."
xText:=xText+$CR+String:C10($cancelled; "^^^,^^^,^^0")+" Orders cancelled in this batch."  // Modified by: Mel Bohince (1/29/15) 
xText:=xText+$CR+String:C10($open; "^^^,^^^,^^0")+" Candidate Orders are not closed."
xText:=xText+$CR+String:C10($openLines; "^^^,^^^,^^0")+" Orderlines are not closed."
xText:=xText+$CR+"_______________ END OF REPORT ______________"

//*Print a list of what happened on this run
//QM_Sender (xTitle;"";xText;distributionList)
//rPrintText ("ORDER_CLOSEOUT_"+fYYMMDD (4D_Current_date))
//«string(String(4d_Current_time;◊HHMM);":";""))


//utl_LogIt ("init")
//utl_LogIt (xText)
//utl_LogIt ("show")
xTitle:=""
xText:=""