//(S) aMMYY
If (In header:C112)
	If (Before selection:C198)
		//---------------------------------------------------------------
		$MM:=Num:C11(Substring:C12(aMMYY; 1; 2))
		//If ($MM<4)
		//$MM:=$MM+9
		//Else 
		//$MM:=$MM-3
		//End if 
		aMonthYear:=<>ayMonth{$MM}+", 19"+Substring:C12(aMMYY; 3; 2)
	End if 
End if 
//EOS