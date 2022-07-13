//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/15/07, 14:01:06
// ----------------------------------------------------
// Method: OL_GetMostRecent
// Description:
// Find the date of the most recent orderline, given an cpn
// ----------------------------------------------------

C_DATE:C307($0)
C_TEXT:C284($1)
ARRAY DATE:C224($aDate; 0)

$0:=!1995-04-17!  // default to my date of hire

READ ONLY:C145([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$1)
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateOpened:13; $aDate)
	SORT ARRAY:C229($aDate; <)
	$0:=$aDate{1}
End if 