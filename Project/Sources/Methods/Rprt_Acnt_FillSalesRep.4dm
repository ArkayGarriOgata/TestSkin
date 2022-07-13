//%attributes = {}
//Method:  Rprt_Acnt_FillSalesRep(patDropDown;patDropDownQuery)
//Description:  This method will search for sales reps

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown; $2; $patDropDownQuery)
	
	$patDropDown:=$1
	$patDropDownQuery:=$2
	
End if   //Done initialize

SlRp_FillIdName($patDropDown; $patDropDownQuery)
