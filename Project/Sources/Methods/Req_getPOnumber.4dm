//%attributes = {}
// Method: Req_getPOnumber () -> 
// ----------------------------------------------------
// by: mel: 08/23/04, 10:11:00
// ----------------------------------------------------
// Description:
// return po number given a requisisiton number

C_TEXT:C284($1; $0)

$0:=""

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5=$1)
If (Records in selection:C76([Purchase_Orders:11])=1)
	$0:=[Purchase_Orders:11]PONo:1
End if 