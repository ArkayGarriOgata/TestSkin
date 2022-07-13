//%attributes = {}
//Method:   CuOr_GetDateOpenedD(tOrderLine)=>dDateOpened
//Description:  This method returns the DateOpened

If (True:C214)  //Initialize 
	
	C_DATE:C307($0; $dDateOpened)
	C_TEXT:C284($1; $tOrderLine)
	
	$tOrderLine:=$1
	$dDateOpened:=!00-00-00!
	
End if   //Done Initialize

If (Core_Query_UniqueRecordB(->[Customers_Order_Lines:41]OrderLine:3; ->$tOrderLine))
	
	$dDateOpened:=[Customers_Order_Lines:41]DateOpened:13
	
End if 

$0:=$dDateOpened
