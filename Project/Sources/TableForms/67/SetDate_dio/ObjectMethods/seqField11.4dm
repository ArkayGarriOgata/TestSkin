// Method: Object Method: sPO () -> 

// ----------------------------------------------------

// by: mel: 08/23/04, 10:06:43

// ----------------------------------------------------

// Description:

// validate reference to purchasing doc


//see OS_receivedQty


C_BOOLEAN:C305($valid)
$valid:=False:C215
C_TEXT:C284($poNum)
$poNum:=""

READ ONLY:C145([Purchase_Orders:11])
READ ONLY:C145([Purchase_Orders_Items:12])
SET QUERY LIMIT:C395(1)

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=Substring:C12(sPO; 1; 7))
If (Records in selection:C76([Purchase_Orders:11])=1)
	$valid:=True:C214
	
	If (Length:C16(sPO)=9)
		
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sPO)
		If (Records in selection:C76([Purchase_Orders_Items:12])=0)
			$valid:=False:C215
			BEEP:C151
			zwStatusMsg("NOT FOUND"; "PO item "+sPO+" was not found")
			sPO:=""
		End if 
		
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("NOT FOUND"; "Purchase Order "+sPO+" was not found")
	sPO:=""
End if 

SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
