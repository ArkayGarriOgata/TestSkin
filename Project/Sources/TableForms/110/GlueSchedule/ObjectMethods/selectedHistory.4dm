
// Method: [ProductionSchedules].GlueSchedule.selectedHistory ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/28/14, 16:20:45
// ----------------------------------------------------
// Description
// for the hilited records, find a the historical gluer
//
// ----------------------------------------------------

C_TEXT:C284($lastGluer)
C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274(aGlueListBox)

uThermoInit($numElements; "Looking for prior gluer...")
For ($i; 1; $numElements)
	If (aGlueListBox{$i})  //the row is hilited
		$lastGluer:=PSG_History(aCPN{$i})
		If ($lastGluer#"n/f")
			aGluer{$i}:=$lastGluer
			PSG_MasterArray("store"; $i)
			
		Else 
			$lastGluer:=PSG_History("*"; aOutline{$i})
			If ($lastGluer#"n/f")
				aGluer{$i}:=$lastGluer
				PSG_MasterArray("store"; $i)
			End if 
		End if 
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

/////////////////// orig code:
//$lastGluer:=PSG_History (aCPN{aGlueListBox})
//If ($lastGluer#"n/f")
//uConfirm (aCPN{aGlueListBox}+" was last glued on the "+$lastGluer;"Use again";"Cancel")
//If (ok=1)
//aGluer{aGlueListBox}:=$lastGluer
//PSG_MasterArray ("store";aGlueListBox)
//End if 
//
//Else 
//uConfirm ("Could not find a prior gluer used for "+aCPN{aGlueListBox}+", check by outline#?";"Outline";"Cancel")
//If (ok=1)
//$lastGluer:=PSG_History ("*";aOutline{aGlueListBox})
//If ($lastGluer#"n/f")
//uConfirm (aOutline{aGlueListBox}+" was last glued on the "+$lastGluer;"Use again";"Cancel")
//If (ok=1)
//aGluer{aGlueListBox}:=$lastGluer
//PSG_MasterArray ("store";aGlueListBox)
//End if 
//
//Else 
//uConfirm ("Could not find a prior gluer used for "+aOutline{aGlueListBox}+".";"Ok";"Shucks")
//End if 
//End if 
//End if 
//
//If ($lastGluer#"n/f")
//uConfirm ("In fact, use "+$lastGluer+" on unassigned "+aOutline{aGlueListBox}+"'s?";"Yeah baby";"Cancel")
//If (ok=1)
//$outline:=aOutline{aGlueListBox}
//$hit:=0
//Repeat 
//$hit:=Find in array(aOutline;$outline;($hit+1))
//If ($hit>-1)
//If (aGluer{$hit}="N/A")
//aGluer{$hit}:=$lastGluer
//PSG_MasterArray ("store";aGlueListBox)
//End if 
//End if 
//Until ($hit=-1)
//
//End if 
//End if 