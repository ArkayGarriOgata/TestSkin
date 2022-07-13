//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/24/06, 12:07:38
// ----------------------------------------------------
// Method: util_PopUpDropDownAction(->aBrand;->[table]field)
// Description
// 
//
// Parameters pointer to popup dropdown list array,pointer tofield
// ----------------------------------------------------
C_POINTER:C301($1; $2)
C_BOOLEAN:C305($0; $changed)  //

Case of 
	: (($1->)=0)
		$changed:=False:C215  //nothing selected
		
	: (($1->{$1->})="")
		$changed:=False:C215  //list currently contains spaces for readablility
		
	: (($1->{$1->})=($2->))
		$changed:=False:C215  //no change requested
		
	Else   //make the assignment
		$2->:=$1->{$1->}
		$changed:=True:C214
End case 

$0:=$changed