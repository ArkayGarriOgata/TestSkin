//%attributes = {"publishedWeb":true}
//Job_SubformBreakDown(jobform)
// Modified by: Mel Bohince (1/25/13) add product code
//rpt items and counts then compare to net sheets
//see also JBNSubformRatio, Est_SubformBreakDown

C_LONGINT:C283($i; $numItems; $j; $numSubforms)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$jobForm:=$1
If (Count parameters:C259=1)
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	
	$docName:="SubformBreakDown_"+$jobForm+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
Else 
	uConfirm("Save to Excel doc or to screen?"; "Excel"; "Screen")
	If (ok=1)
		$t:=Char:C90(9)
		$cr:=Char:C90(13)
		$docName:="SubformBreakDown_"+$jobForm+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->$docName)
	Else 
		$docName:=""
		$t:=" "*5
		$cr:=Char:C90(13)
		utl_LogIt("init")
	End if 
End if 

QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobForm)
ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
$numItems:=Records in selection:C76([Job_Forms_Items:44])
$numSubforms:=0

SELECTION TO ARRAY:C260([Job_Forms_Items:44]SubFormNumber:32; $aSF; [Job_Forms_Items:44]Jobit:4; $aJobit; [Job_Forms_Items:44]Qty_Yield:9; $ayld; [Job_Forms_Items:44]NumberUp:8; $aitemUp; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]MAD:37; $aHRD)
For ($i; 1; $numItems)  //get highest subform number used
	If ($aSF{$i}>$numSubforms)
		$numSubforms:=$aSF{$i}
	End if 
End for 

ARRAY DATE:C224($aSF_HRD; $numSubforms)
For ($i; 1; $numSubforms)
	$aSF_HRD{$i}:=<>Magic_date
End for 

For ($i; 1; $numSubforms)
	For ($j; 1; $numItems)
		If ($aSF{$j}=$i)
			If ($aHRD{$j}<$aSF_HRD{$i})
				$aSF_HRD{$i}:=$aHRD{$j}
			End if 
		End if 
	End for 
End for 
//make matrix:

//sf1     5000/2
//sf2                    2500/1 
//sf3                                     5000/2
//ttl       5000/2   2500/1     5000/2
ARRAY LONGINT:C221($aQty; $numItems; $numSubforms)  //sparce arrays
ARRAY LONGINT:C221($aUP; $numItems; $numSubforms)  //sparce arrays
ARRAY LONGINT:C221($aQtyT; $numSubforms)  //tight array
ARRAY LONGINT:C221($aUPT; $numSubforms)  //tight array
For ($i; 1; $numItems)
	$aQty{$i}{$aSF{$i}}:=$ayld{$i}
	$aUP{$i}{$aSF{$i}}:=$aitemUp{$i}
	$aQtyT{$aSF{$i}}:=$aQtyT{$aSF{$i}}+$ayld{$i}
	$aUPT{$aSF{$i}}:=$aUPT{$aSF{$i}}+$aitemUp{$i}
End for 

//set up column headings
xText:="Jobit       "+$t
For ($i; 1; $numSubforms)
	xText:=xText+"||-------- "+String:C10($i)+" ---"+$t+"----------||"+$t
End for 
xText:=xText+$cr
For ($i; 1; $numSubforms)
	xText:=xText+"Up"+$t+"Yield"+$t
End for 
xText:=xText+$cr

For ($i; 1; $numItems)
	xText:=xText+$cr  //+("-"*80)
	xText:=xText+$aJobit{$i}+$t
	For ($j; 1; $numSubforms)  //print sparce arrays
		xText:=xText+String:C10($aUP{$i}{$j})+$t+String:C10($aQty{$i}{$j})+$t
	End for 
	xText:=xText+$cr+$aCPN{$i}+$cr
End for 
xText:=xText+$cr  //+("="*80)
xText:=xText+"TOTALS     "+$t
For ($j; 1; $numSubforms)  //print tight arrays
	xText:=xText+String:C10($aUPT{$j})+$t+String:C10($aQtyT{$j})+$t
End for 
xText:=xText+$cr

//net sheet summary totals
xText:=xText+"SHEETS     "+$t
$totalSheets:=0
For ($j; 1; $numSubforms)
	$sheets:=$aQtyT{$j}/$aUPT{$j}
	$totalSheets:=$totalSheets+$sheets
	xText:=xText+String:C10($sheets)+$t+"<--"+$t
End for 
xText:=xText+$cr
If ($totalSheets=[Job_Forms:42]EstNetSheets:28)
	xText:=xText+"net sheets ok"+$cr
Else 
	xText:=xText+"net sheets wrong"+$cr
End if 
xText:=xText+$cr
xText:=xText+"SUBFORM HRD:"+$t
For ($j; 1; $numSubforms)
	xText:=xText+String:C10($aSF_HRD{$j}; Internal date short special:K1:4)+$t+"<--"+$t
End for 
xText:=xText+$cr+$cr



BEEP:C151
If (Count parameters:C259=1)  // & (False)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	$err:=util_Launch_External_App($docName)
	
Else 
	If (Length:C16($docName)=0)
		utl_LogIt(xText; 1)
		utl_LogIt("show")
	Else 
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		$err:=util_Launch_External_App($docName)
	End if 
End if 