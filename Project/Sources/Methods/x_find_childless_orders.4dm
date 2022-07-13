//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/28/10, 10:06:02
// ----------------------------------------------------
// Method: x_find_childless_orders
// Description
// edi created order headers without orderlines because of a po prefix problem
//
// Parameters
// ----------------------------------------------------
READ WRITE:C146([Customers_Orders:40])
ALL RECORDS:C47([Customers_Orders:40])
CREATE SET:C116([Customers_Orders:40]; "all_orders")

ALL RECORDS:C47([Customers_Order_Lines:41])
RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Customers_Orders:40])

CREATE SET:C116([Customers_Orders:40]; "have_lines")

DIFFERENCE:C122("all_orders"; "have_lines"; "no_lines")
USE SET:C118("no_lines")
$num:=Records in selection:C76([Customers_Orders:40])
zwStatusMsg("Found"; String:C10($num))
CREATE SET:C116([Customers_Orders:40]; "◊LastSelection"+String:C10(Table:C252(->[Customers_Orders:40])))
CONFIRM:C162("Delete?"; "Yes"; "No")
If (ok=1)
	$locked:=util_DeleteSelection(->[Customers_Orders:40])
	zwStatusMsg("Fini"; String:C10($num)+" deleted "+String:C10($locked)+" locked")
End if 