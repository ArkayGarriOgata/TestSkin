//%attributes = {}
// _______
// Method: INV_RightClickToExcel   ( ) ->
// By: MelvinBohince @ 03/14/22, 10:11:23
// Description
// Lynn would like this to work like OpenAccounts
//  you right click to exports CSV and opens in Excel
// ----------------------------------------------------
// Modified by: MelvinBohince (3/21/22) move the build a csv file to the server
// Modified by: MelvinBohince (3/24/22) can't pass entity selection of server method, use an obj instead

C_BOOLEAN:C305($listingWYSIWYG)
$listingWYSIWYG:=True:C214
C_TEXT:C284($csvText)

//use the currently displayed invoices
//C_OBJECT($invoices_es)
//$invoices_es:=Create entity selection([Customers_Invoices])
//build a csv file on server
//$csvText:=INV_RightClickToExcel_eos ($invoices_es;$listingWYSIWYG)

ARRAY LONGINT:C221($_recordNumbers; 0)
LONGINT ARRAY FROM SELECTION:C647([Customers_Invoices:88]; $_recordNumbers)
C_OBJECT:C1216($entityObject)
OB SET ARRAY:C1227($entityObject; "recordNumbers"; $_recordNumbers)

$csvText:=INV_RightClickToExcel_eos($entityObject; $listingWYSIWYG)

$docName:="InvoiceList_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237($docName; $csvText)

$err:=util_Launch_External_App($docName)
