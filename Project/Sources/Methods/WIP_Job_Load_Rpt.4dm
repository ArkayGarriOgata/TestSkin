//%attributes = {}
// _______
// Method: WIP_Job_Load_Rpt   ( ) ->
// By: Mel Bohince @ 12/22/21, 12:29:09
// Description
// Report the loads on jobs in Wip status
// ----------------------------------------------------

C_COLLECTION:C1488($jf_in_WIP_c)
$jf_in_WIP_c:=ds:C1482.Job_Forms.query("Status = :1"; "WIP").toCollection("JobFormID").extract("JobFormID")

If ($jf_in_WIP_c.length>0)
	$title:="WIP Jobform Loads"
	C_OBJECT:C1216($jfl_e; $jfl_es)
	$jfl_es:=ds:C1482.Job_Forms_Loads.query("JobForm in :1"; $jf_in_WIP_c)
	
	
	C_TEXT:C284($text; $fieldDelimitor; $recordDelimitor)
	$fieldDelimitor:=","
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
	$rows_c:=New collection:C1472  //there will be a row for each transaction
	
	If (True:C214)  //start with the column headings  
		$columns_c:=New collection:C1472
		$columns_c.push("JobForm")
		$columns_c.push("LoadID")
		$columns_c.push("LoadNumber")
		$columns_c.push("Location")
		$columns_c.push("Qty")
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	End if   //headings
	
	For each ($jfl_e; $jfl_es)
		
		$columns_c:=New collection:C1472
		$columns_c.push($jfl_e.JobForm)
		$columns_c.push("#"+$jfl_e.LoadID)
		$columns_c.push($jfl_e.LoadNumber)
		$columns_c.push($jfl_e.Location)
		$columns_c.push(String:C10($jfl_e.Qty))
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
	
	$text:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText
	
Else 
	$text:="No JobForms found in WIP status."
	ALERT:C41($text)
End if 

zwStatusMsg("WIP RPT"; "Finished retrieving adjustments dated from "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd))

$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals

$docName:="WIP_Load_Rpt_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $text)

$err:=util_Launch_External_App($docName)
