//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/24/15, 15:11:58
// ----------------------------------------------------
// Method: CostCenterObsoleteSubstitutions
// Description
// get rid of old cc's
//
// ----------------------------------------------------
// Modified by: Mel Bohince (2/10/17) add 414 and 428

C_TEXT:C284($1; $0)

If (Count parameters:C259=1)
	
	Case of 
		: ($1="412") | ($1="416") | ($1="414") | ($1="415")
			$0:="417"
			
		: ($1="468")
			$0:="469"
			
		: ($1="428")
			$0:="429"
			
		Else   //no change
			$0:=$1
			
	End case 
	
End if 