//%attributes = {}
// Method: JML_HRDreport () -> 
// ----------------------------------------------------
// by: mel: 08/25/04, 15:39:08
// ----------------------------------------------------
// Description:
// by Customer, see if HRD is better or worse the CWD -- for Marty
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs; $cursor; $totalJobs; $totalBetter; $outputStyle)
C_BOOLEAN:C305($break)

READ ONLY:C145([Job_Forms_Master_Schedule:67])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13#!00-00-00!)

ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Customer:2; >)

$outputStyle:=2
$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
ARRAY TEXT:C222($aCust; $numRecs)
ARRAY TEXT:C222($aScore; $numRecs)
ARRAY LONGINT:C221($aNumJobs; $numRecs)
ARRAY LONGINT:C221($aNumBetter; $numRecs)
$lastcust:=""
$cursor:=0
$cursor:=$cursor+1
$aCust{$cursor}:=[Job_Forms_Master_Schedule:67]Customer:2
$lastcust:=$aCust{$cursor}
$aNumJobs{$cursor}:=0
$aNumBetter{$cursor}:=0

uThermoInit($numRecs; "Updating Records")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		If ($lastcust#[Job_Forms_Master_Schedule:67]Customer:2)
			$aScore{$cursor}:=String:C10(Round:C94($aNumBetter{$cursor}/$aNumJobs{$cursor}*100; 0))+"%"
			$cursor:=$cursor+1
			$aCust{$cursor}:=[Job_Forms_Master_Schedule:67]Customer:2
			$lastcust:=$aCust{$cursor}
			$aNumJobs{$cursor}:=0
			$aNumBetter{$cursor}:=0
		End if 
		
		$aNumJobs{$cursor}:=$aNumJobs{$cursor}+1
		If ([Job_Forms_Master_Schedule:67]MAD:21<=[Job_Forms_Master_Schedule:67]FirstReleaseDat:13)
			If ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
				$aNumBetter{$cursor}:=$aNumBetter{$cursor}+1
			End if 
		End if 
		
		NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
		uThermoUpdate($i)
	End for 
	
Else 
	
	ARRAY TEXT:C222($_Customer; 0)
	ARRAY DATE:C224($_MAD; 0)
	ARRAY DATE:C224($_FirstReleaseDat; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]Customer:2; $_Customer; [Job_Forms_Master_Schedule:67]MAD:21; $_MAD; [Job_Forms_Master_Schedule:67]FirstReleaseDat:13; $_FirstReleaseDat)
	
	For ($i; 1; $numRecs; 1)
		
		If ($lastcust#$_Customer{$i})
			$aScore{$cursor}:=String:C10(Round:C94($aNumBetter{$cursor}/$aNumJobs{$cursor}*100; 0))+"%"
			$cursor:=$cursor+1
			$aCust{$cursor}:=$_Customer{$i}
			$lastcust:=$aCust{$cursor}
			$aNumJobs{$cursor}:=0
			$aNumBetter{$cursor}:=0
		End if 
		
		$aNumJobs{$cursor}:=$aNumJobs{$cursor}+1
		If ($_MAD{$i}<=$_FirstReleaseDat{$i})
			If ($_MAD{$i}#!00-00-00!)
				$aNumBetter{$cursor}:=$aNumBetter{$cursor}+1
			End if 
		End if 
		
		uThermoUpdate($i)
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

uThermoClose

$numRecs:=$cursor
ARRAY TEXT:C222($aCust; $numRecs)
ARRAY TEXT:C222($aScore; $numRecs)
ARRAY LONGINT:C221($aNumJobs; $numRecs)
ARRAY LONGINT:C221($aNumBetter; $numRecs)

$totalJobs:=0
$totalBetter:=0

xText:=txt_Pad("Customer"; " "; 1; 30)+txt_Pad("#Jobs"; " "; -1; 8)+txt_Pad("#Better"; " "; -1; 8)+txt_Pad("PCT"; " "; -1; 8)+<>CR
uThermoInit($numRecs; "Outputting")
For ($i; 1; $numRecs)
	$totalJobs:=$totalJobs+$aNumJobs{$i}
	$totalBetter:=$totalBetter+$aNumBetter{$i}
	xText:=xText+txt_Pad(Substring:C12($aCust{$i}; 1; 29); " "; 1; 30)+txt_Pad(String:C10($aNumJobs{$i}); " "; -1; 8)+txt_Pad(String:C10($aNumBetter{$i}); " "; -1; 8)+txt_Pad($aScore{$i}; " "; -1; 8)+<>CR
	uThermoUpdate($i)
End for 
uThermoClose

xText:=xText+txt_Pad(Substring:C12("Total:"; 1; 29); " "; 1; 30)+txt_Pad(String:C10($totalJobs); " "; -1; 8)+txt_Pad(String:C10($totalBetter); " "; -1; 8)+txt_Pad(String:C10(Round:C94($totalBetter/$totalJobs*100; 0))+"%"; " "; -1; 8)+<>CR
xTitle:="HRD v. CWD "+String:C10(4D_Current_date; System date short:K1:1)+" "+String:C10(Round:C94($totalBetter/$totalJobs*100; 0))+"%"
Case of 
	: ($outputStyle=1)
		utl_LogIt("init")
		utl_LogIt(xTitle+<>CR+<>CR+xText; 0)
		utl_LogIt("show")
		utl_LogIt("init")
		
	: ($outputStyle=2)
		$distributionList:=distributionList
		//$distributionList:="mel.bohince@arkay.com"+Char(9)
		
		EMAIL_Sender(xTitle; ""; xText; $distributionList)
		
	Else 
		rPrintText
End case 

xTitle:=""
xText:=""