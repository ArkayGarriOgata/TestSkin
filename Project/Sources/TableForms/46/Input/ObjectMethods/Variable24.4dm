// _______
// Method: [Customers_ReleaseSchedules].Input.Variable24   ( ) ->
// By: Mel Bohince @ 03/05/21, 15:53:33
// Description
// updated to orda
// ----------------------------------------------------
C_TEXT:C284($ordLine)
$ordLine:=Request:C163("Enter the new orderline:"; [Customers_ReleaseSchedules:46]OrderLine:4)
C_OBJECT:C1216($es)
$es:=ds:C1482.Customers_Order_Lines.query("OrderLine = :1 and ProductCode = :2"; $ordLine; [Customers_ReleaseSchedules:46]ProductCode:11)
If ($es.length=1)
	[Customers_ReleaseSchedules:46]OrderLine:4:=$ordLine
	$dot:=Position:C15("."; $ordLine)  //see fMakeOLkey
	[Customers_ReleaseSchedules:46]OrderNumber:2:=Num:C11(Substring:C12($ordLine; 1; ($dot-1)))
	
Else 
	uConfirm($ordLine+" was not found or was a different product code."; "Shucks"; "Try again")
End if 
