//%attributes = {}
// _______
// Method: app_form_Open   (tableNumber;baseFormName) ->
// By: Mel Bohince @ 04/23/20, 09:45:46
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($form_o; $1)
$form_o:=$1


zSetUsageLog($table_ptr; "1"; $form_o.baseForm; 0)  //keep track if this is being used

C_LONGINT:C283($winRef)
C_OBJECT:C1216($xy)
$xy:=OpenFormWindowCoordinates("get")

C_POINTER:C301($table_ptr)
$table_ptr:=Table:C252($form_o.masterTable)
$winRef:=Open form window:C675($table_ptr->; $form_o.baseForm; Plain form window:K39:10; $xy.x; $xy.y)
DIALOG:C40($table_ptr->; $form_o.baseForm; $form_o)

CLOSE WINDOW:C154($winRef)
