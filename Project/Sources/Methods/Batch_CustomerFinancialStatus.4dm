//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/21/06, 11:05:59
// ----------------------------------------------------
// Method: Batch_CustomerFinancialStatus
// Description
// populate customers' ar and open order fields
// see also Batch_SetCustOpenOrders
// ----------------------------------------------------
// Modified by: Mel Bohince (9/8/16) chg open order calc
READ WRITE:C146([Customers:16])
ALL RECORDS:C47([Customers:16])
//PM: pattern_LoopRecords() -> 
//@author mlb - 8/27/02  16:30

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([Customers:16])

uThermoInit($numRecs; "Updating Customer Financial Records")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		[Customers:16]Open_A_R:33:=Inv_calcOpenAR([Customers:16]ID:1)
		[Customers:16]Open_Orders:34:=Cust_getOpenOrderTotal([Customers:16]ID:1)  //Ord_calcOpenOrders ([Customers]ID)
		
		SAVE RECORD:C53([Customers:16])
		NEXT RECORD:C51([Customers:16])
		uThermoUpdate($i)
	End for 
	
Else 
	
	APPLY TO SELECTION:C70([Customers:16]; [Customers:16]Open_A_R:33:=Inv_calcOpenAR([Customers:16]ID:1))
	APPLY TO SELECTION:C70([Customers:16]; [Customers:16]Open_Orders:34:=Cust_getOpenOrderTotal([Customers:16]ID:1))
	
End if   // END 4D Professional Services : January 2019 First record

uThermoClose