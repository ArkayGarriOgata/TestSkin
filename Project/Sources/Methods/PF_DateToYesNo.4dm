//%attributes = {}
// -------
// Method: PF_DateToYesNo   ( date ) -> yes | no
// By: Mel Bohince @ 11/10/17, 10:43:15
// Description
// convert a resource's date to yes or no
// see also Not(util_isDateNull (->$resourceDate))
// ----------------------------------------------------

C_DATE:C307($1)
C_TEXT:C284($0)
If ($1=!00-00-00!)
	$0:="No"
Else 
	$0:="Yes"
End if 
//