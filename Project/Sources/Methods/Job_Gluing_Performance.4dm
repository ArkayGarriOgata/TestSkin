//%attributes = {}
// _______
// Method: Job_Gluing_Performance   ( ) -> csv file
// By: Mel Bohince @ 10/01/21, 14:00:31
// Description
// report to show gluing exceptions that should be addressed
// guided by Mike Sanctuary
// ----------------------------------------------------

C_OBJECT:C1216($jmi_es; $jmi_e)
C_DATE:C307($date; $1)

$date:=Add to date:C393(Current date:C33; 0; 0; -1)
If (Count parameters:C259=0)
	$date:=Date:C102(Request:C163("What date?"; String:C10($date); "Ok"; "Cancel"))
Else 
	$date:=$1
End if 
$tolerance:=0.25

C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

C_COLLECTION:C1488($rows_c; $columns_c)

//these will be the columns
$rows_c:=New collection:C1472  //there will be a row for each jobit 
//start with the column headings
$columns_c:=New collection:C1472
$columns_c.push("Jobit")
$columns_c.push("Budget_Rate")
$columns_c.push("Actual_Rate")
$columns_c.push("Difference")
$columns_c.push("Outliar")
$columns_c.push("ProductCode")
$columns_c.push("Run_Act")
$columns_c.push("Want_Qty")
$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers

//find the jobs completed on the day of interest
$jmi_es:=ds:C1482.Job_Forms_Items.query("Completed = :1"; $date).orderBy("Jobit")

For each ($jmi_e; $jmi_es)
	//calc the rate as WantQty/Run_Act
	$mt_es:=ds:C1482.Job_Forms_Machine_Tickets.query("Jobit = :1"; $jmi_e.Jobit)
	$runHrs:=$mt_es.sum("Run_Act")
	If ($runHrs>0)
		$rateAct:=Round:C94($jmi_e.Qty_Want/$runHrs; -2)
	Else 
		$rateAct:=0
	End if 
	
	$rateBud:=$jmi_e.GlueRate*1000
	
	$columns_c:=New collection:C1472  //set up for the next row of date
	
	$columns_c.push($jmi_e.Jobit)
	$columns_c.push(String:C10($rateBud))
	$columns_c.push(String:C10($rateAct))
	
	$delta:=$rateAct-$rateBud
	$columns_c.push(String:C10($delta))
	If (Abs:C99($delta)/$rateBud>$tolerance)
		$columns_c.push("Outliar")
	Else 
		$columns_c.push("√")
	End if 
	//some extra info
	$columns_c.push($jmi_e.ProductCode)
	$columns_c.push(String:C10($runHrs))
	$columns_c.push(String:C10($jmi_e.Qty_Want))
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

//slap them together
$csvToExport:=$rows_c.join($recordDelimitor)

//show the params
$csvToExport:=$csvToExport+(3*$recordDelimitor)  //skip some spaces
$csvToExport:=$csvToExport+"Date: "+String:C10($date)+" Outliar Tolerance: "+String:C10($tolerance*100)+"%"

//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="GLUING_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $csvToExport)
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("Just trying to help.")
End if 
$err:=util_Launch_External_App($docName)
