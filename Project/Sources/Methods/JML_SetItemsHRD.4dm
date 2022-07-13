//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/30/06, 14:25:38
// ----------------------------------------------------
// Method: JML_SetItemsHRD
// ----------------------------------------------------
// Modified by: Mel Bohince (3/10/16) treat <>MAGIC_DATE like 00/00/00 and give option to move sooner, was only able to push out

newHRD:=[Job_Forms_Master_Schedule:67]MAD:21

CUT NAMED SELECTION:C334([Finished_Goods:26]; "redrawThem")
READ WRITE:C146([Job_Forms_Items:44])
$numJMI:=qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
Case of 
	: ($numJMI=1)
		If (fLockNLoad(->[Job_Forms_Items:44]))
			[Job_Forms_Items:44]MAD:37:=[Job_Forms_Master_Schedule:67]MAD:21
			SAVE RECORD:C53([Job_Forms_Items:44])
		End if 
		
	: ($numJMI>1)
		ARRAY BOOLEAN:C223(ListBox1; 0)
		ARRAY LONGINT:C221(aLi; 0)
		ARRAY TEXT:C222(aSelected; 0)
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY TEXT:C222(aJobit; 0)
		ARRAY LONGINT:C221(aSubForm; 0)
		ARRAY DATE:C224(aDate; 0)
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3; >; [Job_Forms_Items:44]Jobit:4; >; [Job_Forms_Items:44]SubFormNumber:32; >)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]; aLi; [Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]SubFormNumber:32; aSubForm; [Job_Forms_Items:44]MAD:37; aDate; [Job_Forms_Items:44]ProductCode:3; aCPN)
		ARRAY TEXT:C222(aSelected; $numJMI)
		//pre select dates that would be pushed later
		For ($i; 1; $numJMI)
			If (aDate{$i}<newHRD) | (aDate{$i}=<>MAGIC_DATE)  // Modified by: Mel Bohince (3/10/16) treat magic date like 00/00/00
				aSelected{$i}:="X"
				aDate{$i}:=newHRD
			Else 
				aSelected{$i}:=""
			End if 
		End for 
		
		C_LONGINT:C283($i; $numRecs; $hit; $numAdded; $winRef)
		$winRef:=OpenSheetWindow(->[Job_Forms_Items:44]; "SetHaveReadyDate")
		//*Decide on hrd to use for each jobit
		DIALOG:C40([Job_Forms_Items:44]; "SetHaveReadyDate")
		CLOSE WINDOW:C154
		If (OK=1)
			For ($i; 1; $numJMI)
				If (aSelected{$i}="X")
					GOTO RECORD:C242([Job_Forms_Items:44]; aLi{$i})
					If (fLockNLoad(->[Job_Forms_Items:44]))
						[Job_Forms_Items:44]MAD:37:=aDate{$i}
						SAVE RECORD:C53([Job_Forms_Items:44])
					End if 
				End if 
			End for 
		End if 
		
		ARRAY BOOLEAN:C223(ListBox1; 0)
		ARRAY LONGINT:C221(aLi; 0)
		ARRAY TEXT:C222(aSelected; 0)
		ARRAY TEXT:C222(aCPN; 0)
		ARRAY TEXT:C222(aJobit; 0)
		ARRAY LONGINT:C221(aSubForm; 0)
		ARRAY DATE:C224(aDate; 0)
		
	Else 
		BEEP:C151
End case 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
USE NAMED SELECTION:C332("redrawThem")