//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/23/15, 10:25:03
// ----------------------------------------------------
// Method: pattern_html_table_email
// Description
// build a html table to be passed to 'Email_html_table' template
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($b; $t; $r; $tableData; $subject; $prebody)
$tableData:=""
$subject:="MySubject "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
$prebody:="BlahBlahBlah."

//so this pattern compiles, example
ARRAY TEXT:C222(aCPN; 0)
ARRAY LONGINT:C221($aInventory; 0)
ARRAY REAL:C219($aValue; 0)
$count:=0
$ttl_qty:=0
$ttl_value:=0
// end example

//light font for column headers
$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$r:="</td></tr>"+Char:C90(13)

//Optional inclusion of prebody, redundant to iPhone users
$tableData:="<tr><td colspan=\"3\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"+$prebody+$r
//The column labels
$tableData:=$tableData+$b+"GCAS"+$t+"Inventory"+$t+"$Value"+$r

//For data rows, the $b will alternate backgounds
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"

$numElements:=Size of array:C274(aCPN)
$row:=0
uThermoInit($numElements; "Saving...")
For ($i; 1; $numElements)
	If ($aInventory{$i}>0)
		$row:=$row+1
		If (($row%2)#0)  //alternate row color
			$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
		Else 
			$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
		End if 
		$tableData:=$tableData+$b+aCPN{$i}+$t+String:C10($aInventory{$i}; "##,###,###")+$t+String:C10($aValue{$i}; "##,###,###")+$r
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

//Totals section
$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$tableData:=$tableData+$b+"TOTALS ["+String:C10($count)+"]"+$t+String:C10($ttl_qty; "##,###,###")+$t+String:C10($ttl_value; "$##,###,###")+$r

If (Count parameters:C259>0)
	distributionList:=Email_WhoAmI
Else 
	distributionList:=Request:C163("Send to:"; "mel.bohince@arkay.com"; "OK"; "Cancel")
End if 
Email_html_table($subject; $prebody; $tableData; 600; distributionList)