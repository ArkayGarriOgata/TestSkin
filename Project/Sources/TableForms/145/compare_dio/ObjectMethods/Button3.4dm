// -------
// Method: [Finished_Goods_DeliveryForcasts].compare_dio.Button3   ( ) ->
// By: Mel Bohince @ 08/31/16, 14:03:14
// Description
// skip to the next cpn in the array
// ----------------------------------------------------
C_LONGINT:C283($column; $row)
//LISTBOX GET CELL POSITION(*;"CPN_list";$column;$row)
//If ($row=0)
//$row:=1
//End if 
$row:=nextItem
nextItem:=nextItem+1
If (nextItem<=Size of array:C274(aCPN))
	LISTBOX SELECT ROW:C912(*; "CPN_list"; nextItem)
	sCPN:=aCPN{nextItem}
	PnP_DeliveryScheduleQry(sCPN)
	
Else 
	BEEP:C151
	nextItem:=$row
End if 