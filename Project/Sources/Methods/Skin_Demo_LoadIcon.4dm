//%attributes = {}
/* Method:  Skin_Demo_LoadIcon(tFamily
  Description:  This method runs when the family changes
*/

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFamily)
	
	$tFamily:=$1
	
End if   //Done initialize

If (Skin_Demo_atFamily>0)  //Family
	
	$tFamily:=Skin_Demo_atFamily{Skin_Demo_atFamily}
	
	Skin_Demo_LoadIcon($tFamily)
	
End if   //Done family


//franks changes
