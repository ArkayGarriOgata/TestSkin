//%attributes = {}
// _______
// Method: FG_Location_Export   ( ) ->
// By: MelvinBohince @ 01/10/22, 15:27:17
// Description
// simple export of all ams location records
// ----------------------------------------------------
// Modified by: MelvinBohince (1/15/22) move the loop to an execute on server method
// and add option to filter by cust, cpn, or location

C_TEXT:C284($csvToExport; $filter)
$csvToExport:=""

C_OBJECT:C1216($filter_o)  //Modified by: MelvinBohince (1/15/22) 
$filter_o:=New object:C1471
//$filter_o.custID:="00074"
//$filter_o.productCode:="2EFR-01-011A"
//$filter_o.location:="FG:V_@"  //"FG:V_2"
uConfirm("All locations or filter by custid, product, and or location?"; "All"; "Filter")
If (ok=0)
	C_TEXT:C284($criterian)
	$criterian:=Request:C163("Customer's ID?"; ""; "This Customer"; "Any")
	If (ok=1) & (Length:C16($criterian)>1)
		$filter_o.custID:=$criterian
	End if 
	
	$criterian:=Request:C163("Product Code?"; ""; "This Product"; "Any")
	If (ok=1) & (Length:C16($criterian)>1)
		$filter_o.productCode:=$criterian
	End if 
	
	$criterian:=Request:C163("Location?"; ""; "This Location"; "Any")
	If (ok=1) & (Length:C16($criterian)>1)
		$filter_o.location:=$criterian
	End if 
	
End if 


$csvToExport:=FG_Location_Export_EOS($filter_o)  // Modified by: MelvinBohince (1/15/22) move the loop to an execute on server method

//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="FGL_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $csvToExport)
CLOSE DOCUMENT:C267($docRef)

zwStatusMsg("FGL Export"; "CSV file saved to: "+document)

$err:=util_Launch_External_App($docName)

