//%attributes = {"publishedWeb":true}
//Procedure: sAskMeLoadsets(sCPN)  020896  MLB
//load the quadrants with saved sets

C_TEXT:C284($0)
C_TEXT:C284($1; $sCPN)

$0:=""

LOAD SET:C185([Customers_Order_Lines:41]; "displayOrders"; ("1-"+$sCPN))
If (OK=1)
	LOAD SET:C185([Customers_ReleaseSchedules:46]; "displayRels"; ("2-"+$sCPN))
	If (OK=1)
		LOAD SET:C185([Finished_Goods_Locations:35]; "threeLoaded"; ("3-"+$sCPN))
		If (OK=1)
			LOAD SET:C185([Job_Forms_Items:44]; "fourLoaded"; ("4-"+$sCPN))
			If (OK=1)
				USE SET:C118("displayOrders")
				USE SET:C118("displayRels")
				USE SET:C118("threeLoaded")
				USE SET:C118("fourLoaded")
			Else 
				$0:="Error loading 4 cache, un-check this option."
			End if 
			
		Else 
			$0:="Error loading 3 cache, un-check this option."
		End if 
		
	Else 
		$0:="Error loading 2 cache, un-check this option."
	End if 
	
Else 
	$0:="Error loading 1 cache, un-check this option."
End if 