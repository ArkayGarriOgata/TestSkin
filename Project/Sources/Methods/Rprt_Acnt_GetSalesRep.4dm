//%attributes = {}
//Method:  Rprt_Acnt_GetSalesRep(patDropDown;patDropDownQuery)
//Description:  This method will search for sales reps

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown; $2; $patDropDownQuery)
	
	$patDropDown:=$1
	
End if   //Done initialize

LIST TO ARRAY:C288("SalesReps"; $patDropDown->)