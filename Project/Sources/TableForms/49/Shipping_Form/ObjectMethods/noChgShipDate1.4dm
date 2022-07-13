// ------
// Method: [Customers_Bills_of_Lading].Shipping_Form.ShipDate   ( ) ->
//• 8/13/97 cs created keep user from modifying previous month data
//•120998  MLB Y2K Remediation 
// Modified by: Mel Bohince (5/11/16) change restrictions, bol_executeshipment will also make sure not backdated

C_LONGINT:C283($err; $curMth; $enteredMth)
$err:=sDateLimitor(Self:C308; 7; 0)  // Modified by: Mel Bohince (5/11/16) change from 3 to 7 days in advance, no backdating
If ($err#0)
	Self:C308->:=4D_Current_date
	GOTO OBJECT:C206(Self:C308->)
	
Else 
	$curMth:=Month of:C24(4D_Current_date)  // Modified by: Mel Bohince (5/11/16) can't change last month
	$enteredMth:=Month of:C24(Self:C308->)
	
	Case of 
		: ($enteredMth<$curMth)
			uConfirm("You may not change last months shipping records."; "Ok"; "Help")
			Self:C308->:=4D_Current_date
			GOTO OBJECT:C206(Self:C308->)
	End case   //
End if 
