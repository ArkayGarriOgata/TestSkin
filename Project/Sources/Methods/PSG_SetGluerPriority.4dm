//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/10/14, 11:32:19
// ----------------------------------------------------
// Method: PSG_SetGluerPriority
// Description
// Prioritize Gluers so short crews know where to focus 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (4/17/19) add windower

ARRAY TEXT:C222($aGluers; 0)
//
$allGluers:=txt_Trim(<>GLUERS)  //load all presses in an array for a build query below
$allGluers:=Replace string:C233($allGluers; "491"; "")
$allGluers:=Replace string:C233($allGluers; "505"; "")
$allGluers:=Replace string:C233($allGluers; "477"; "472")  // Modified by: Mel Bohince (4/17/19) 

$cnt_of_presses:=Num:C11(util_TextParser(16; $allGluers; Character code:C91(" "); 13))
For ($gluer; 1; $cnt_of_presses)
	APPEND TO ARRAY:C911($aGluers; util_TextParser($gluer))
End for 

//APPEND TO ARRAY($aGluers;"476")
//APPEND TO ARRAY($aGluers;"478")
//APPEND TO ARRAY($aGluers;"480")
//APPEND TO ARRAY($aGluers;"481")
//APPEND TO ARRAY($aGluers;"482")
//APPEND TO ARRAY($aGluers;"483")
//APPEND TO ARRAY($aGluers;"484")
//APPEND TO ARRAY($aGluers;"485")
//APPEND TO ARRAY($aGluers;"493")

READ WRITE:C146([Cost_Centers:27])
QUERY WITH ARRAY:C644([Cost_Centers:27]ID:1; $aGluers)
ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]Priority:42; >; [Cost_Centers:27]ID:1; >)

windowTitle:="Gluer Priorities"
$winRef:=OpenFormWindow(->[Cost_Centers:27]; "PrioritySetting"; ->windowTitle; windowTitle; 33)
DIALOG:C40([Cost_Centers:27]; "PrioritySetting")
CLOSE WINDOW:C154
If (ok=1)
	tGluerOrder:="Machine Priority: "
	SELECTION TO ARRAY:C260([Cost_Centers:27]Priority:42; $aPriority; [Cost_Centers:27]ID:1; $aPriorityCC)
	REDUCE SELECTION:C351([Cost_Centers:27]; 0)
	SORT ARRAY:C229($aPriority; $aPriorityCC; >)
	For ($i; 1; Size of array:C274($aPriority))
		If ($aPriority{$i}>0)
			tGluerOrder:=tGluerOrder+String:C10($aPriority{$i})+": "+$aPriorityCC{$i}+"     "
		End if 
	End for 
End if 
