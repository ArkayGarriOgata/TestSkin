//%attributes = {}
// _______
// Method: RMX_PI_Tag_Rpt   ( ) ->
// By: Mel Bohince @ 12/20/21, 14:16:52
// Description
// 
// ----------------------------------------------------

C_DATE:C307(dDateBegin; $1; $2; dDateEnd)
C_TEXT:C284($docName; $docShortName; $3; $distributionList)


If (Count parameters:C259>2)
	dDateBegin:=$1
	dDateEnd:=$2
	$distributionList:=$3
	OK:=1
	bSearch:=0
	
Else 
	windowTitle:="RM Transaction Date Range for Tag Rpt"
	$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)  // Modified by: Mel Bohince (11/24/21) properly size date range dialog
	dDateBegin:=Current date:C33  //Date("01-01-"+String(Year of(Current date)))
	dDateEnd:=Current date:C33
	DIALOG:C40([zz_control:1]; "DateRange2")
End if 

If (ok=1)
	
	$title:="Physical Inventory RM Tag Report for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
	
	zwStatusMsg("RM TAG RPT"; "adjustments dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+" Please wait...")
	
	
	C_OBJECT:C1216($rmx_e; $rmx_es)
	$rmx_es:=ds:C1482.Raw_Materials_Transactions.query("XferDate >= :1 and XferDate <= :2 and Xfer_Type = :3"; dDateBegin; dDateEnd; "ADJUST").orderBy("ReferenceNo")
	
	If ($rmx_es.length>0)
		//now build the report
		C_TEXT:C284($text; $fieldDelimitor; $recordDelimitor)
		$fieldDelimitor:=","
		$recordDelimitor:="\r"
		
		C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
		$rows_c:=New collection:C1472  //there will be a row for each transaction
		
		If (True:C214)  //start with the column headings  
			$columns_c:=New collection:C1472
			$columns_c.push("viaLocation")
			$columns_c.push("POItemKey")
			$columns_c.push("Raw_Matl_Code")
			$columns_c.push("Commodity_Key")
			$columns_c.push("Qty")
			$columns_c.push("ActCost(unit)")
			$columns_c.push("ExtendedCost")
			$columns_c.push("ReferenceNo")
			$columns_c.push("ModWho")
			
			$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
		End if   //headings
		
		For each ($rmx_e; $rmx_es)
			
			$columns_c:=New collection:C1472
			$columns_c.push($rmx_e.viaLocation)
			$columns_c.push($rmx_e.POItemKey)
			$columns_c.push($rmx_e.Raw_Matl_Code)
			$columns_c.push($rmx_e.Commodity_Key)
			$columns_c.push(String:C10($rmx_e.Qty))
			$columns_c.push(String:C10(Round:C94($rmx_e.ActCost; 4)))
			$columns_c.push(String:C10(Round:C94($rmx_e.ActCost*$rmx_e.Qty; 2)))
			$columns_c.push($rmx_e.ReferenceNo)
			$columns_c.push($rmx_e.ModWho)
			
			$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
			
		End for each 
		
		$text:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText
		
	Else 
		$text:="No ADJUSTs found in the specified date range."
		ALERT:C41($text)
	End if 
	
	zwStatusMsg("RM TAG RPT"; "Finished retrieving adjustments dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd))
	
	$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals
	
	$docName:="RM_TAG_RPT_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
	$docShortName:=$docName  //capture before path is prepended
	C_TIME:C306($docRef)
	$docRef:=util_putFileName(->$docName)
	CLOSE DOCUMENT:C267($docRef)
	
	TEXT TO DOCUMENT:C1237(document; $text)
	
	If (Count parameters:C259>2)
		$text:="Open attached with Excel."
		EMAIL_Sender($title; ""; $text; $distributionList; $docName)
		util_deleteDocument($docName)
		
	Else 
		$err:=util_Launch_External_App($docName)
	End if   //#params
	
	
End if   //ok=1
