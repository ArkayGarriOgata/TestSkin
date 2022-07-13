//%attributes = {}
// _______
// Method: CSPEC_getJSON   ( ) ->
// By: Mel Bohince @ 11/19/19, 09:36:47
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($0; $entity; $estimatesCartons)
C_COLLECTION:C1488($cartonsCollection; $filter)
C_TEXT:C284($1; $find; $jsonString)

If (Count parameters:C259=1)
	$find:=$1
Else 
	$find:="9-2433.00"
End if 
//[Estimates_Carton_Specs]

$estimatesCartons:=ds:C1482.Estimates_Carton_Specs.query("Estimate_No = :1 and diffNum = :2"; $find; "00")
If ($estimatesCartons.length#0)
	
	$filter:=New collection:C1472
	$filter.push("Estimate_No")
	$filter.push("CartonSpecKey")
	$filter.push("CustID")
	$filter.push("ProductCode")
	$filter.push("Description")
	//$filter.push("OutLineNumber")
	$filter.push("Qty1Temp")
	$filter.push("Qty2Temp")
	$filter.push("Qty3Temp")
	$filter.push("Qty4Temp")
	$filter.push("Qty5Temp")
	$filter.push("Qty6Temp")
	$filter.push("FG_SIZE_AND_STYLE.FileOutlineNum")
	$filter.push("FG_SIZE_AND_STYLE.Dim_A")
	$filter.push("FG_SIZE_AND_STYLE.Dim_B")
	$filter.push("FG_SIZE_AND_STYLE.Dim_Ht")
	$filter.push("FG_SIZE_AND_STYLE.Style")
	$filter.push("FG_SIZE_AND_STYLE.Top")
	$filter.push("FG_SIZE_AND_STYLE.Bottom")
	
	$cartonsCollection:=New collection:C1472
	$cartonsCollection:=$estimatesCartons.toCollection($filter; dk with primary key:K85:6+dk with stamp:K85:28)
	
	$jsonString:=JSON Stringify:C1217($cartonsCollection; *)
	
	C_TEXT:C284($docName)
	C_TIME:C306($docRef)
	$find:=Replace string:C233($find; "."; "_")+"_"
	$docName:=$find+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".json"
	$docRef:=util_putFileName(->$docName)
	CLOSE DOCUMENT:C267($docRef)
	TEXT TO BLOB:C554($jsonString; $txtToExport; UTF8 text without length:K22:17)
	BLOB TO DOCUMENT:C526(document; $txtToExport)  //document
	
	
	CLOSE DOCUMENT:C267($docRef)
Else 
	BEEP:C151
End if 

