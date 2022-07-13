//%attributes = {"publishedWeb":true}
//PM: ORD_distributePrepAvailable(order) -> 
//@author mlb - 8/28/02  13:41

C_LONGINT:C283($1)
C_REAL:C285($0; $Available)

CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "holdOrderLines")
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=$1; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5="Prep@")

SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
$numOL:=Size of array:C274($aQty)
$Available:=0
For ($i; 1; $numOL)
	$Available:=$Available+($aQty{$i}*$aPrice{$i})
End for 

$0:=$Available
USE NAMED SELECTION:C332("holdOrderLines")