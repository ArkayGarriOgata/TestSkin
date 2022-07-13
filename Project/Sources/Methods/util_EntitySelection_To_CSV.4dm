//%attributes = {}
// _______
// Method: util_EntitySelection_To_CSV   ( ds.Customers.all() {;"49 53" }) ->
// By: Mel Bohince @ 04/29/21, 11:03:20
// Description
// export all the fields of an entity selection in param 1 to a CSV file unless their 
// field number is passed in the 2nd parama separated by commas, skip blobs and relation attributes
// dates need special attention depending on the ultimate destination, using YYYY-MM-DD
// was FGX_export, based on pattern_CSV_Export
// ----------------------------------------------------

C_OBJECT:C1216($es; $1; $entity)
C_TEXT:C284($2)  //$skipFields
C_COLLECTION:C1488($skipFields_c)

If (Count parameters:C259>0)
	$es:=$1
	$skipFields_c:=Split string:C1554($2; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
Else   //test
	C_DATE:C307($start_d; $end_d)
	$start_d:=!2021-04-01!
	$end_d:=!2021-04-30!
	$es:=ds:C1482.Finished_Goods_Transactions.query("XactionDate >= :1  and XactionDate <= :2 and XactionType = :3"; $start_d; $end_d; "ship").orderBy("transactionDateTime")
	//$skipFields:=String(Field(->[Finished_Goods_Transactions]LocationToRecNo);"0000")  //
	//$skipFields:=$skipFields+", "+String(Field(->[Finished_Goods_Transactions]LocationFromRecNo);"0000")
	//$skipFields:=$skipFields+", "+String(Field(->[Finished_Goods_Transactions]TransactionFailed);"0000")
	//$skipFields:=$skipFields+", "+String(Field(->[Finished_Goods_Transactions]z_SYNC_ID);"0000")
	$skipFields_c:=Split string:C1554("21,23,25,35"; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
End if 

C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","  //\t
$recordDelimitor:="\r"

If ($es.length>0)
	C_COLLECTION:C1488($rows_c; $columns_c)
	$rows_c:=New collection:C1472  //there will be a row for each invoice 
	//start with the column headings
	$columns_c:=New collection:C1472
	
	ARRAY TEXT:C222($_properties; 0)
	ARRAY LONGINT:C221($_propType; 0)
	OB GET PROPERTY NAMES:C1232($es.first(); $_properties; $_propType)
	For ($i; 1; Size of array:C274($_properties))
		If ($_propType{$i}<Is object:K8:27) & ($_propType{$i}#Is undefined:K8:13)  //supported type //is object = 38, is undefined = 5
			If ($skipFields_c.indexOf(String:C10($i))=-1)
				$columns_c.push($_properties{$i})
			End if 
		End if 
	End for 
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
	C_LONGINT:C283($outerBar; $outerLoop; $out)
	$outerBar:=Progress New  //new progress bar
	$outerLoop:=$es.length
	$out:=0
	Progress SET TITLE($outerBar; "Exporting "+String:C10($outerLoop)+" to CSV file")
	
	For each ($entity; $es)
		$out:=$out+1
		Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
		
		$columns_c:=New collection:C1472  //set up for the next row of date
		
		For ($i; 1; Size of array:C274($_properties))
			If ($_propType{$i}<38) & ($_propType{$i}#5)  //supported type //is object = 38, is undefined = 5
				If ($skipFields_c.indexOf(String:C10($i))=-1)
					$columns_c.push(txt_ToCSV_attribute($entity; $_properties{$i}))
				End if 
			End if 
		End for 
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
	
	Progress QUIT($outerBar)  //remove the thermometer
	BEEP:C151
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
	
	//save the text to a document
	
	C_TEXT:C284($path; $suggestFileName; $docName)  //see also pattern_SaveAs ( )
	$suggestFileName:="CSV_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM:K7:2); ":"; "")+".csv"
	$path:=util_DocumentPath+$suggestFileName  //suggest putting in the ams_doc's folder
	$docName:=Select document:C905($path; "CSV"; "Save the missing records as:"; File name entry:K24:17)
	If (ok=1)
		$docRef:=Create document:C266(Document)  //name the export file
		If (ok=1)
			CLOSE DOCUMENT:C267($docRef)  //document is ready for use
			
			TEXT TO DOCUMENT:C1237(Document; $csvToExport)
			CLOSE DOCUMENT:C267($docRef)
			
			uConfirm("CSV file with "+String:C10($rows_c.length)+" rows saved to: "+Document; "Thanks!!!"; "Why?")
			If (ok=0)
				ALERT:C41("Just trying to help.")
			End if 
			$err:=util_Launch_External_App(Document)
			
		Else   //es is empty
			ALERT:C41("No records found.")
		End if 
		
	End if   //doc created
End if   //doc named
