//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 07/10/06, 11:16:19
// ----------------------------------------------------
// Method: OL_incrementItemNumber
// Description
// `return the next avail number for a new order line
// ----------------------------------------------------
//•111398  MLB  UPR get the highest line number

C_LONGINT:C283($0)

SELECTION TO ARRAY:C260([Customers_Order_Lines:41]LineItem:2; $aItem)
If (Size of array:C274($aItem)>0)
	SORT ARRAY:C229($aItem; <)
	i1:=$aItem{1}+1
Else 
	i1:=1
End if 

$0:=i1