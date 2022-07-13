//%attributes = {}

// Method: ams_DeleteSuggestedVendors ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/15, 13:09:04
// ----------------------------------------------------
// Description
// remove suggested vendor records if the vendor is not active
//
// ----------------------------------------------------

READ WRITE:C146([Raw_Materials_Suggest_Vendors:173])

$sql:="DELETE FROM Raw_Materials_Suggest_Vendors WHERE VendorID NOT IN (SELECT ID FROM vendors WHERE active = TRUE)"
SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")  //current user
ok:=0
Begin SQL
	EXECUTE IMMEDIATE :$sql;
End SQL
$success:=(ok=1)
SQL LOGOUT:C872

