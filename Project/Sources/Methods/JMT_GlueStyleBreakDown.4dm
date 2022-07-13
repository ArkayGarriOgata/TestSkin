//%attributes = {}
// _______
// Method: JMT_GlueStyleBreakDown   ( ) ->
// By: Mel Bohince @ 08/27/21, 08:34:22
// Description
// rpt which glue styles each gluer is doing
// ----------------------------------------------------

C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

C_OBJECT:C1216($criteria_o)
$criteria_o:=New object:C1471
$criteria_o.dateFrom:=Date:C102(FiscalYear("start"; 4D_Current_date))
$criteria_o.dateTo:=4D_Current_date

CostCtrInit  //load gluers array if needed


C_COLLECTION:C1488($costCentersOfInterest_c)
$costCentersOfInterest_c:=New collection:C1472
ARRAY TO COLLECTION:C1563($costCentersOfInterest_c; <>aGLUERS)

//remove outside gluing 9xx
C_TEXT:C284($outsideGluing)
$costCentersOfInterest_c:=$costCentersOfInterest_c.orderBy(ck ascending:K85:9)
$outsideGluing:=$costCentersOfInterest_c.pop()

If ($outsideGluing#"9xx")
	ALERT:C41("O/S Gluing not removed, better check the results.")
End if 


C_OBJECT:C1216($mt_es; $mt_o; $jobit_e)
$mt_es:=ds:C1482.Job_Forms_Machine_Tickets.query("DateEntered >= :1 and DateEntered <= :2 and CostCenterID IN :3 and Jobit # :4"; $criteria_o.dateFrom; $criteria_o.dateTo; $costCentersOfInterest_c; "").orderBy("Jobit")
//[Job_Forms_Items]Jobit
//[Job_Forms_Machine_Tickets]Jobit
//[Job_Forms_Machine_Tickets]

C_COLLECTION:C1488($rows_c; $columns_c)
$rows_c:=New collection:C1472  //there will be a row for each invoice 
//start with the column headings
$columns_c:=New collection:C1472
$columns_c.push("CostCenter")
$columns_c.push("Jobit")
$columns_c.push("CartonStyle")
$columns_c.push("MR_Act")
$columns_c.push("Run_Act")
$columns_c.push("Down")
$columns_c.push("DownCategory")
$columns_c.push("Comment")
$columns_c.push("Qty_Good")
$columns_c.push("Qty_Waste")
$columns_c.push("Date")
$columns_c.push("Period")

$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers


For each ($mt_o; $mt_es)
	$jobit_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $mt_o.Jobit).first()
	If ($jobit_e#Null:C1517)
		$style:=$jobit_e.GlueStyle
	Else 
		$style:="Not Specified"
	End if 
	
	If ($style#"Not Specified")  //don't bother with it, prolly r&d or liner job
		$columns_c:=New collection:C1472  //set up for the next row of date
		
		$columns_c.push($mt_o.CostCenterID)
		$columns_c.push($mt_o.Jobit)
		$columns_c.push($style)
		$columns_c.push($mt_o.MR_Act)
		$columns_c.push($mt_o.Run_Act)
		$columns_c.push($mt_o.DownHrs)
		$columns_c.push($mt_o.DownHrsCat)
		$columns_c.push($mt_o.Comment)
		$columns_c.push($mt_o.Good_Units)
		$columns_c.push($mt_o.Waste_Units)
		$columns_c.push($mt_o.DateEntered)
		$columns_c.push(fYYYYMM($mt_o.DateEntered))
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	End if 
End for each 

$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="CSV_GlueStyle_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $csvToExport)
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("Just trying to help.")
End if 
$err:=util_Launch_External_App($docName)