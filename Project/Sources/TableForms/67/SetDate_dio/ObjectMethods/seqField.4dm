// Method: Object Method: sReq () -> 

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

$poNum:=Req_getPOnumber(Substring:C12(sReq; 1; 7))
sPO:=$poNum
If (Length:C16($poNum)=7)
	$valid:=True:C214
	
	If (Length:C16(sReq)=9)
		sPO:=($poNum+Substring:C12(sReq; 8; 2))
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=($poNum+Substring:C12(sReq; 8; 2)))
		If (Records in selection:C76([Purchase_Orders_Items:12])=0)
			$valid:=False:C215
			BEEP:C151
			zwStatusMsg("NOT FOUND"; "Requistion item "+sReq+" was not found")
			sReq:=""
			sPO:=""
		End if 
		
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("NOT FOUND"; "Requistion "+sReq+" was not found")
	sReq:=""
	sPO:=""
End if 

SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
