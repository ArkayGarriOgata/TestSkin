//%attributes = {"publishedWeb":true}
//PM: ORD_distributePrepConsumed(order) -> 
//@author mlb - 8/28/02  13:44

C_LONGINT:C283($1)
C_REAL:C285($0; $consumed)

CUT NAMED SELECTION:C334([Prep_Charges:103]; "holdPrepCharges")
$consumed:=0

QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]OrderNumber:8=$1)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; Records in selection:C76([Prep_Charges:103]))
		$consumed:=$consumed+[Prep_Charges:103]PriceActual:5
		NEXT RECORD:C51([Prep_Charges:103])
	End for 
	
Else 
	
	SELECTION TO ARRAY:C260([Prep_Charges:103]PriceActual:5; $_PriceActual)
	
	For ($i; 1; Size of array:C274($_PriceActual); 1)
		
		$consumed:=$consumed+$_PriceActual{$i}
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

$0:=$consumed
USE NAMED SELECTION:C332("holdPrepCharges")