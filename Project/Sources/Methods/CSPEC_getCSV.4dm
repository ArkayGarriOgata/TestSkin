//%attributes = {}
// _______
// Method: CSPEC_getCSV   ( ) ->
// By: Mel Bohince @ 11/19/19, 13:41:11
// Description
// 
// Added by: Garri Ogata (2/11/21) Item column per Kristopher request.
// Added by: Garri Ogata (10/06/21) SqIn column per Kristopher request.
// ----------------------------------------------------

C_TEXT:C284($1; $find; $controlNumber; $csvToExport)
C_OBJECT:C1216($carton)  //;$inkSelection;$ink;$inks)
//C_COLLECTION($inks;$inksFilter)

If (Count parameters:C259=1)
	$find:=$1
Else 
	$find:="9-2037.00"  //"9-2437.00"// "9-2433.00" //    //
End if 
//[Estimates_Carton_Specs]//starting table

$csvToExport:=""
//column labels
$csvToExport:=$csvToExport+txt_quote("Estimate_No")+","
$csvToExport:=$csvToExport+txt_quote("CustID")+","
$csvToExport:=$csvToExport+txt_quote("Item")+","
$csvToExport:=$csvToExport+txt_quote("ProductCode")+","
$csvToExport:=$csvToExport+txt_quote("Description")+","
$csvToExport:=$csvToExport+txt_quote("OutLineNumber")+","
$csvToExport:=$csvToExport+txt_quote("SqIn")+","
$csvToExport:=$csvToExport+String:C10("Qty1Temp")+","
$csvToExport:=$csvToExport+String:C10("Qty2Temp")+","
$csvToExport:=$csvToExport+String:C10("Qty3Temp")+","
$csvToExport:=$csvToExport+String:C10("Qty4Temp")+","
$csvToExport:=$csvToExport+String:C10("Qty5Temp")+","
$csvToExport:=$csvToExport+String:C10("Qty6Temp")+","
$csvToExport:=$csvToExport+String:C10("Side")+","
$csvToExport:=$csvToExport+String:C10("Rotation")+","
$csvToExport:=$csvToExport+String:C10("Ink")+","
$csvToExport:=$csvToExport+String:C10("Color...")+"\r"

//get the rows
For each ($carton; ds:C1482.Estimates_Carton_Specs.query("Estimate_No = :1 and diffNum = :2"; $find; "00"))
	$csvToExport:=$csvToExport+txt_quote($carton.Estimate_No)+","
	$csvToExport:=$csvToExport+txt_quote($carton.CustID)+","
	$csvToExport:=$csvToExport+txt_quote($carton.Item)+","
	$csvToExport:=$csvToExport+txt_quote($carton.ProductCode)+","
	$csvToExport:=$csvToExport+txt_quote($carton.Description)+","
	$csvToExport:=$csvToExport+txt_quote($carton.OutLineNumber)+","
	$csvToExport:=$csvToExport+String:C10($carton.SquareInches)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty1Temp)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty2Temp)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty3Temp)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty4Temp)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty5Temp)+","
	$csvToExport:=$csvToExport+String:C10($carton.Qty6Temp)+","
	
	//get the inks from the control records inks
	If ($carton.PRODUCT_CODE#Null:C1517)
		$controlNumber:=$carton.PRODUCT_CODE.ControlNumber
		
		//faster with classic
		READ ONLY:C145([Finished_Goods_Specs_Inks:188])
		QUERY:C277([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]ControlNumber:6=$controlNumber)
		If (Records in selection:C76([Finished_Goods_Specs_Inks:188])>0)
			SELECTION TO ARRAY:C260([Finished_Goods_Specs_Inks:188]Side:2; $aSide; [Finished_Goods_Specs_Inks:188]Rotation:1; $aRot; [Finished_Goods_Specs_Inks:188]InkNumber:3; $aInk; [Finished_Goods_Specs_Inks:188]Color:4; $aColor)
			MULTI SORT ARRAY:C718($aSide; >; $aRot; >; $aInk; $aColor)
			For ($i; 1; Size of array:C274($aSide))
				$csvToExport:=$csvToExport+$aSide{$i}+","
				$csvToExport:=$csvToExport+String:C10($aRot{$i})+","
				$csvToExport:=$csvToExport+$aInk{$i}+","
				$csvToExport:=$csvToExport+$aColor{$i}+","
			End for 
		Else 
			$csvToExport:=$csvToExport+"No inks found."+",,,"
		End if 
		REDUCE SELECTION:C351([Finished_Goods_Specs_Inks:188]; 0)
		
		//$inkSelection:=ds.Finished_Goods_Specs_Inks.query("ControlNumber = :1";$controlNumber)
		//If ($inkSelection.length>0)
		//  //$inks:=New collection  //using collection didnt help
		//  //$inksFilter:=New collection("Side";"Rotation";"InkNumber";"Color")
		//  //$inks:=$inkSelection.toCollection($inksFilter).orderBy("Side asc, Rotation asc")
		//$inks:=$inkSelection.orderBy("Side asc, Rotation asc")
		//For each ($ink;$inks)
		//$csvToExport:=$csvToExport+$ink.Side+","
		//$csvToExport:=$csvToExport+string($ink.Rotation)+","
		//$csvToExport:=$csvToExport+$ink.InkNumber+","
		//$csvToExport:=$csvToExport+$ink.Color+","
		//End for each 
		//Else 
		//$csvToExport:=$csvToExport+"No inks found."+",,,"
		//End if   //ink selection
		
	Else 
		$csvToExport:=$csvToExport+"No F/G record found."+",,,"
	End if 
	
	//end the row
	$csvToExport:=$csvToExport+"\r"
End for each 

//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)
$find:=Replace string:C233($find; "."; "_")+"_"  //use the query criterion in the filename

$docName:=$find+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO BLOB:C554($csvToExport; $txtToExport; UTF8 text without length:K22:17)
BLOB TO DOCUMENT:C526(document; $txtToExport)
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("To send to Phoenix")
End if 




