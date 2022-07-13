//%attributes = {"publishedWeb":true}
//PM:  POIpriceToCost  070199  mlb
//convert a unit price to a unit cost

C_TEXT:C284($1)
C_REAL:C285($0)

$0:=0

If (Count parameters:C259=1)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$1)
End if 

If (Records in selection:C76([Purchase_Orders_Items:12])>0) | (Is new record:C668([Purchase_Orders_Items:12]))
	$0:=uNANCheck(([Purchase_Orders_Items:12]UnitPrice:10*([Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38))*([Purchase_Orders_Items:12]FactNship2cost:29/[Purchase_Orders_Items:12]FactDship2cost:37))
End if 