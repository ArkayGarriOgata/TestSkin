//%attributes = {}
// Method: Rel_ReleasesOnCloseOrders () -> 
// ----------------------------------------------------
// by: mel: 05/13/04, 12:37:22
// ----------------------------------------------------
// Description:
// remove release if order isn't open
// Modified by: Mel Bohince (5/6/16) ignore safety stock

C_LONGINT:C283($hit; $i; $numRecs)
C_BOOLEAN:C305($break)

READ WRITE:C146([Customers_ReleaseSchedules:46])

//find open orders
$hit:=qryOpenOrdLines
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOrderline)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)

//tidy up things that shipped
//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OpenQty>0;*)
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]Actual_Qty>0)
//APPLY TO SELECTION([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]OpenQty:=0)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8=0)  //instead of the obove
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "defunct")
	
Else 
	
	ARRAY LONGINT:C221($_defunct; 0)
	
	
End if   // END 4D Professional Services : January 2019 

$break:=False:C215
$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])

uThermoInit($numRecs; "Updating Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	Case of 
		: (Position:C15("Imported"; [Customers_ReleaseSchedules:46]Expedite:35)>0)  //see png_deliveryschedule_v2 
			//do nothing
		: ([Customers_ReleaseSchedules:46]CustomerRefer:3="<FND@")
			$hit:=Find in array:C230($aOrderline; [Customers_ReleaseSchedules:46]OrderLine:4)
			If ($hit=-1)  //order is no longer open
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					ADD TO SET:C119([Customers_ReleaseSchedules:46]; "defunct")
					
				Else 
					
					APPEND TO ARRAY:C911($_defunct; Record number:C243([Customers_ReleaseSchedules:46]))
					
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
		: ([Customers_ReleaseSchedules:46]CustomerRefer:3="<F@")
			//do nothing
		: (Position:C15("safe"; [Customers_ReleaseSchedules:46]CustomerRefer:3)>0)  // Modified by: Mel Bohince (5/6/16) ignore safety stock
			[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6
			$fence:=Add to date:C393(4D_Current_date; 0; 0; 14)
			If ([Customers_ReleaseSchedules:46]Sched_Date:5<$fence)  //push it out
				[Customers_ReleaseSchedules:46]Sched_Date:5:=$fence
			End if 
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			
		Else 
			$hit:=Find in array:C230($aOrderline; [Customers_ReleaseSchedules:46]OrderLine:4)
			If ($hit=-1)  //order is no longer open
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					ADD TO SET:C119([Customers_ReleaseSchedules:46]; "defunct")
					
				Else 
					
					APPEND TO ARRAY:C911($_defunct; Record number:C243([Customers_ReleaseSchedules:46]))
					
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
	End case 
	
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
End for 
uThermoClose

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
Else 
	
	CREATE SET FROM ARRAY:C641([Customers_ReleaseSchedules:46]; $_defunct; "defunct")
	
End if   // END 4D Professional Services : January 2019 

USE SET:C118("defunct")  //give warning
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35:="ORDER CLOSED?")

USE SET:C118("defunct")  //too old
// ******* Verified  - 4D PS - January  2019 ********
QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<(4D_Current_date-14))

// ******* Verified  - 4D PS - January 2019 (end) *********
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16:=0)

USE SET:C118("defunct")
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<FND@")


// ******* Verified  - 4D PS - January 2019 (end) *********
util_DeleteSelection(->[Customers_ReleaseSchedules:46])
CLEAR SET:C117("defunct")