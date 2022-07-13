//%attributes = {"publishedWeb":true}
//(p) PiWipinvForms
//prints templates for hand writing inventory for WIP. 
//called from PiFrzInventory

lPage:=Int:C8(Records in table:C83([Cost_Centers:27])/30)+1

t2:="WIP: Inventory Reporting Sheet"
ALL RECORDS:C47([Cost_Centers:27])
FORM SET OUTPUT:C54([Cost_Centers:27]; "CCPiTemplate")
util_PAGE_SETUP(->[Cost_Centers:27]; "CCPiTemplate")
PRINT SELECTION:C60([Cost_Centers:27]; *)
FORM SET OUTPUT:C54([Cost_Centers:27]; "List")