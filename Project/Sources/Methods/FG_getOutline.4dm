//%attributes = {}
// Method: FG_getOutline () -> 
// ----------------------------------------------------
// by: mel: 06/22/04, 17:01:19
// ----------------------------------------------------
// Description:
// return customer Line when given the cpn
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	C_TEXT:C284($1; $2)
	C_TEXT:C284($0)
	
	$0:=""
	MESSAGES OFF:C175
	//READ ONLY([Finished_Goods])
	//SET QUERY LIMIT(1)`messes up when 2 custs share item code
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1)
	If (Count parameters:C259=2)
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$2)
	End if 
	If (Records in selection:C76([Finished_Goods:26])=1)
		$0:=[Finished_Goods:26]OutLine_Num:4
	End if 
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
Else 
	
	C_TEXT:C284($1; $2)
	C_TEXT:C284($0)
	
	$0:=""
	MESSAGES OFF:C175
	//READ ONLY([Finished_Goods])
	//SET QUERY LIMIT(1)`messes up when 2 custs share item code
	If (Count parameters:C259=2)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2=$2; *)
	End if 
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1)
	
	If (Records in selection:C76([Finished_Goods:26])=1)
		$0:=[Finished_Goods:26]OutLine_Num:4
	End if 
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
End if   // END 4D Professional Services : January 2019 query selection
