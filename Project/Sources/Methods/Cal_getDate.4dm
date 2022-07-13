//%attributes = {"publishedWeb":true}
//METHOD: Cal_getDate(PTR: Pointer to Date variable;LI:month;LI:year)
//The parameters $2 and $3 are optional
//Written by: Georgios /ODENSOFT
//Date written: 07/10/99
//Last Modified: 07/13/99
//Description: 
//Returns the selected date after displaying a Pop Up Calendar

C_POINTER:C301($1; vp_recieverDateVar)  //mandatory parameter
C_LONGINT:C283($2)
C_LONGINT:C283($3)

//The parameters $2 and $3 are optional
//if passed the Calendar will display the $1 month for $2 year
//if one of them or none is passed
//the Calendar will display month and year of the receiver variable's date
//if $1=$2=0 the Calendar will display the current month

//It would be a good idea to validate the parameters
//before proceeding hut this is on the DIYS list

vp_recieverDateVar:=$1

If (Count parameters:C259=3)
	If (($2=0) & ($3=0))
		vl_currentMonth:=Month of:C24(Current date:C33)
		vl_currentYear:=Year of:C25(Current date:C33)
	Else 
		vl_currentMonth:=$2
		vl_currentYear:=$3
	End if 
Else 
	vl_currentMonth:=Month of:C24(Current date:C33)
	vl_currentYear:=Year of:C25(Current date:C33)
End if 

wPopUp_window(204; 164; -2)
DIALOG:C40([zz_control:1]; "Calendar")
CLOSE WINDOW:C154