// _______
// Method: [ProductionSchedules].GlueScheduleSettings.Column1   ( ) ->
// By: Mel Bohince @ 06/27/19, 17:29:57
// Description
// 
// ----------------------------------------------------

If (aCCname{abOK}#"ALL")
	$hit:=Find in array:C230(aCCname; "ALL")
	abOK{$hit}:=False:C215
	
Else   //turn everything else off
	
	For ($i; 1; Size of array:C274(aCCname))
		If (Position:C15(aCCname{$i}; psg_assignments)>0)
			abOK{$i}:=False:C215
		End if 
	End for 
	$hit:=Find in array:C230(aCCname; "ALL")
	abOK{$hit}:=True:C214
	
End if 