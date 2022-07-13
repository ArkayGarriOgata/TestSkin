//%attributes = {"publishedWeb":true}
//PM: PDF_printSimple() -> 
//@author mlb - 4/25/01  07:03

C_TEXT:C284(xTitle; xText; $path; $0)

xTitle:=$1
xText:=$2
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ALL RECORDS:C47([zz_control:1])
	FIRST RECORD:C50([zz_control:1])
	
Else 
	
	ALL RECORDS:C47([zz_control:1])
	//you don't need it after all record
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

util_PAGE_SETUP(->[zz_control:1]; "PrintText")
FORM SET OUTPUT:C54([zz_control:1]; "PrintText")

$path:=PDF_setUp(""; True:C214)
PRINT SELECTION:C60([zz_control:1]; *)
FORM SET OUTPUT:C54([zz_control:1]; "List")

$0:=$path