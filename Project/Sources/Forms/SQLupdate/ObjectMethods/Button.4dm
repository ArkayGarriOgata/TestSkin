
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/21/10, 19:32:31
// ----------------------------------------------------
// Method: Object Method: SQLquery.b1
// Description
// 
//
// Parameters
// ----------------------------------------------------

If (Substring:C12(tText; 1; 6)="UPDATE") | (Substring:C12(tText; 1; 6)="INSERT") | (Substring:C12(tText; 1; 6)="DELETE")
	t1:=tText
	SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")  //current user
	ok:=0
	Begin SQL
		EXECUTE IMMEDIATE :tText;
	End SQL
	$success:=(ok=1)
	SQL LOGOUT:C872
	
	If ($success)
		tText:="Finished"
	Else 
		tText:="Failed"
	End if 
	
Else 
	ALERT:C41("You may only use an sql UPDATE or INSERT command here.")
End if 
