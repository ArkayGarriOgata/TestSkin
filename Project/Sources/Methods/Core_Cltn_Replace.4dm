//%attributes = {}
//Method:  Core_Collection_Replace(cValue;vOld;vNew)
//Description:  This method will run thru collection and replace
//  old with new

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cValue)
	
	C_LONGINT:C283($nPosition)
	
	C_VARIANT:C1683($2; $vOld)
	C_VARIANT:C1683($3; $vNew)
	
	C_VARIANT:C1683($vValue)
	$cValue:=$1
	$vOld:=$2
	$vNew:=$3
	
	$nPosition:=0
	
	$nValueTypeOld:=Value type:C1509($vOld)
	
End if   //Done initialize

For each ($vValue; $cValue)  //Value
	
	Case of   //Replace
			
		: (Value type:C1509($vValue)#$nValueTypeOld)
		: ($vValue#$vOld)
			
		Else   //Match
			
			$cValue[$nPosition]:=$vNew
			
	End case   //Done replace
	
	$nPosition:=$nPosition+1
	
End for each   //Done value
