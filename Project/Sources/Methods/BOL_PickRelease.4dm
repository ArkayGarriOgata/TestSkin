//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/10/07, 16:54:46
// ----------------------------------------------------
// Method: BOL_PickRelease()  --> 
// Description
// add a release to a Bill of Lading
//
// ----------------------------------------------------
//wrap the ListBox2 object around the arrays created by the 
//FGL_InventoryPick method which is also used on the Pick list report
// this way the two should match
// ----------------------------------------------------

C_LONGINT:C283($0; $numLocations)
ARRAY BOOLEAN:C223(ListBox2; 0)
ARRAY LONGINT:C221(aNumCases; 0)
ARRAY LONGINT:C221(aPackQty; 0)
ARRAY LONGINT:C221(aTotalPicked; 0)
ARRAY LONGINT:C221(aWgt; 0)

release_number:=$1
iTotal:=0

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)

$numLocations:=FGL_InventoryPick(release_number)
ARRAY BOOLEAN:C223(ListBox2; $numLocations)
ARRAY LONGINT:C221(aNumCases; $numLocations)
ARRAY LONGINT:C221(aPackQty; $numLocations)
ARRAY LONGINT:C221(aTotalPicked; $numLocations)
ARRAY LONGINT:C221(aWgt; $numLocations)

$0:=$numLocations

//test if bin was already picked in this session
BOL_ListBox1("straddle-inventory")

OBJECT SET ENABLED:C1123(*; "noChgAddToBOL"; False:C215)  //wont enable until listbox is clicked again