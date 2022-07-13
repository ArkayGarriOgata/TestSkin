//%attributes = {}
// Method: rfc_newOutlineNumber () -> 
// ----------------------------------------------------
// by: mel: 02/26/04, 10:44:28
// ----------------------------------------------------
// Description:
// return a unique outline number (aka file number)
// ----------------------------------------------------
//based on:  FG_newControlNumber  1/16/01  mlb
//return a control number
//•1/19/01  mlb  go with system unique, not cust unique

C_TEXT:C284($1)  //cust id
C_TEXT:C284($0)  //control number
C_TEXT:C284($server)
C_LONGINT:C283($nextID)

$server:="?"
$nextID:=-3

If (app_getNextID(Table:C252(->[Finished_Goods_SizeAndStyles:132]); ->$server; ->$nextID))
	$0:="A"+String:C10($nextID; "000000")  //THIS TABLE WILL DEPEND ON ID SERIES BEING DIFFERENT AT EACH LOCATION
	
Else 
	$0:="ERR LCK"
	CANCEL:C270
End if 