//%attributes = {}
// -------
// Method: RMX_PlatesReport   (from;to;distro ) ->
// By: Mel Bohince @ 12/06/17, 16:34:47
// Description
// batch an email report of plates made in a date range
// ----------------------------------------------------
// Modified by: Mel Bohince (12/10/19) remove cd74 stuff and add commnets
// Modified by: Mel Bohince (8/30/21) change to CSV file

C_LONGINT:C283($i; $numElements)
C_DATE:C307($from; $1; $to; $2)
If (Count parameters:C259>0)
	$from:=$1
	$to:=$2
	$distributionList:=$3
	//$which:=$3
Else 
	$from:=!2021-06-06!
	$to:=!2021-06-23!  //$from  //
	$distributionList:="mel.bohince@arkay.com"
	//$type:="Summary"
End if 
//[Job_PlatingMaterialUsage]Comment
//Case of 
//: ($type="Summary")
//prep a summary for email body

C_TEXT:C284($tSubject; $tBodyHeader; $tableData)
$tSubject:="Plates made from "+String:C10($from; Internal date short special:K1:4)+" to "+String:C10($to; Internal date short special:K1:4)
$tBodyHeader:="Plates made from "+String:C10($from; Internal date short special:K1:4)+" to "+String:C10($to; Internal date short special:K1:4)+" open attachment for details."
$tableData:=""

ARRAY TEXT:C222($aOperator; 0)
ARRAY LONGINT:C221($aPlatesMade; 0)
Begin SQL
	SELECT Operator, sum(M1O+M1R+M2O+M2R+M3O+M3R+M4O+M4R+M5O+M5R) 
	from Job_PlatingMaterialUsage 
	where DateEntered between :$from and :$to 
	group by Operator 
	into :$aOperator, :$aPlatesMade
End SQL


$cursor:=Size of array:C274($aOperator)
$total:=0
$row:=1

$b:="<tr><td width=\"150\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
$e:="</td></tr>\r"

For ($i; 1; $cursor)
	$row:=$row+1
	If (($row%2)#0)  //alternate row color
		$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
	Else 
		$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
	End if 
	
	$tableData:=$tableData+$b+User_ResolveInitials($aOperator{$i})+$t+String:C10($aPlatesMade{$i})+$e
	
	$total:=$total+$aPlatesMade{$i}
End for 

$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$columnHeadings:=$b+"Operator"+$t+"PlatesMade"+$e
$columnTotals:=$b+"TOTALS"+$t+String:C10($total; "###,##0")+$e

$tableData:=$columnHeadings+$tableData+$columnTotals

//
//
//
//
//prep a detail for email attachment
//: ($type="Detail")
ARRAY TEXT:C222($aOperator; 0)
ARRAY TEXT:C222($aJobSeq; 0)
//ARRAY LONGINT($aM1O;0)  //CD74
//ARRAY LONGINT($aM1R;0)
ARRAY LONGINT:C221($aM2O; 0)  //XL105/6
ARRAY LONGINT:C221($aM2R; 0)
ARRAY LONGINT:C221($aM3O; 0)  //Large
ARRAY LONGINT:C221($aM3R; 0)
//ARRAY LONGINT($aM4O;0)  //Small
//ARRAY LONGINT($aM4R;0)
ARRAY LONGINT:C221($aM5O; 0)  //Cyrel
ARRAY LONGINT:C221($aM5R; 0)
ARRAY TEXT:C222($aComment; 0)
//SELECT Operator, JobSequence, M1O,M1R,M2O,M2R,M3O,M3R,M4O,M4R,M5O,M5R,Comment
Begin SQL
	SELECT Operator, JobSequence, M2O,M2R,M3O,M3R,M5O,M5R,Comment
	from Job_PlatingMaterialUsage 
	where DateEntered between :$from and :$to 
	order by Operator, JobSequence
	into :$aOperator, :$aJobSeq, :$aM2O,:$aM2R, :$aM3O, :$aM3R, :$aM5O, :$aM5R, :$aComment
End SQL
//Else 
//End case

//$text:="Operator\tJobSequence\tCustomer\tLine\tCD74-O\tCD74-R\tXL105/6-O\tXL105/6-R\tLarge-O\tLarge-R\tSmall-O\tSmall-R\tCyrel-O\tCyrel-R\r"
$text:="Operator,JobSequence,Customer,Line,XL105/6-O,XL105/6-R,Large-O,Large-R,Cyrel-O,Cyrel-R,Comment\r"

$numElements:=Size of array:C274($aOperator)
uThermoInit($numElements; "Processing Array")
READ ONLY:C145([Job_Forms:42])
For ($i; 1; $numElements)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Substring:C12($aJobSeq{$i}; 1; 8))
	//$text:=$text+$aOperator{$i}+"\t"+$aJobSeq{$i}+"\t"+CUST_getName ([Job_Forms]cust_id;"elc")+"\t"+[Job_Forms]CustomerLine+"\t"+String($aM1O{$i})+"\t"+String($aM1R{$i})+"\t"+String($aM2O{$i})+"\t"+String($aM2R{$i})+"\t"+String($aM3O{$i})+"\t"+String($aM3R{$i})+"\t"+String($aM4O{$i})+"\t"+String($aM4R{$i})+"\t"+String($aM5O{$i})+"\t"+String($aM5R{$i})+"\r"
	$text:=$text+$aOperator{$i}+","+$aJobSeq{$i}+","+CUST_getName([Job_Forms:42]cust_id:82; "elc")+","+[Job_Forms:42]CustomerLine:62+","+String:C10($aM2O{$i})+","+String:C10($aM2R{$i})+","+String:C10($aM3O{$i})+","+String:C10($aM3R{$i})+","+String:C10($aM5O{$i})+","+String:C10($aM5R{$i})+","+$aComment{$i}+"\r"
	uThermoUpdate($i)
End for 
uThermoClose
REDUCE SELECTION:C351([Job_Forms:42]; 0)

C_TEXT:C284($title; $text; $docName)
C_TIME:C306($docRef)

$title:="Plates made from "+String:C10($from; Internal date short special:K1:4)+" to "+String:C10($to; Internal date short special:K1:4)
$docName:="PlatesMadeDetail"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $title+"\r\r")
	SEND PACKET:C103($docRef; $text)
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	Email_html_table($tSubject; $tBodyHeader; $tableData; 600; $distributionList; $docName)
	
	If (Count parameters:C259>0)
		util_deleteDocument($docName)
	Else 
		$err:=util_Launch_External_App($docName)
	End if 
End if 






