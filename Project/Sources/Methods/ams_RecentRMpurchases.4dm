//%attributes = {"publishedWeb":true}
//PM: ams_RecentRMpurchases() -> 
//@author mlb - 7/3/02  12:19

C_DATE:C307($cutOffDate; $1)
C_TEXT:C284($0)

$0:=""

If (Count parameters:C259=1)
	$cutOffDate:=$1
	READ ONLY:C145([Purchase_Orders_Items:12])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=$cutOffDate)
		CREATE SET:C116([Purchase_Orders_Items:12]; "recentPurchases")
		$0:="recentPurchases"
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentPurchases")
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=$cutOffDate)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentPurchases"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentPurchases")
End if 