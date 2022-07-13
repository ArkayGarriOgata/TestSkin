//%attributes = {}

// Method: PSG_ApplySettingOptions ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/26/14, 13:53:04
// ----------------------------------------------------
// Description
// show or hide rows of the listbox based on parameters set in the Gear dialog
//
// ----------------------------------------------------
// Modified by: Mel Bohince (6/16/21)  hide the N/S's when only looking at a specific gluer

C_LONGINT:C283($0; $day_of_week)
C_TEXT:C284($psg_progress; $1; $psg_assignments; $2; $psg_timeing; $3)
If (Count parameters:C259=3)
	$psg_progress:=$1
	$psg_assignments:=$2
	$psg_timeing:=$3
Else 
	$psg_progress:="Anything"
	$psg_assignments:=<>Gluers+" 9xx N/A"
	$psg_timeing:="All Releases"
End if 

C_DATE:C307($fence)
If ($psg_timeing="All Releases")
	$fence:=!2026-12-25!
	
Else   //show 3 days excluding weekend
	$fence:=util_DateOfNext3Days
End if 

iQtyWant:=0
rDuration:=0
For ($i; 1; Size of array:C274(aRecNum))
	abHidden{$i}:=False:C215  //show it by default
	
	Case of   //progress
		: ($psg_progress="D/C")
			If (aDieCut{$i}#"YES")
				abHidden{$i}:=True:C214  //Hide it
			End if 
			
		: ($psg_progress="Printed")
			If (aPrinted{$i}#"Yes")
				abHidden{$i}:=True:C214  //Hide it
			End if 
			
		: ($psg_progress="WIP")  //In wip but not d/c
			If (aProgressStatus{$i}#"WIP")
				abHidden{$i}:=True:C214
			Else 
				If (aDieCut{$i}="YES")
					abHidden{$i}:=True:C214  //Hide it
				End if 
			End if 
	End case 
	
	Case of   //assignments
		: (abHidden{$i}=True:C214)
			//pass, already hidden
			
		: ($psg_assignments="All")
			//pass, don't care
			
		: (Position:C15(aGluer{$i}; $psg_assignments)=0)  //this gluer not found in gluer-string
			abHidden{$i}:=True:C214
			
		: (aGluer{$i}=$psg_assignments)  //this is the gluer requested, is it scheduled?  // Modified by: Mel Bohince (6/16/21)  hide the N/S's when only looking at a specific gluer
			If (aPrior{$i}<1)
				abHidden{$i}:=True:C214
			End if 
			
		Else 
			
	End case 
	
	If (abHidden{$i}=False:C215)  //not already hidden
		If (aReleased{$i}>$fence)  //timing
			abHidden{$i}:=True:C214  //Hide it
		End if 
	End if 
	
	If (Not:C34(abHidden{$i}))
		iQtyWant:=iQtyWant+aQtyPlnd{$i}
		rDuration:=rDuration+aDurationHrs{$i}
	End if 
End for 
rDuration:=Round:C94(rDuration; 0)

$0:=Count in array:C907(abHidden; False:C215)