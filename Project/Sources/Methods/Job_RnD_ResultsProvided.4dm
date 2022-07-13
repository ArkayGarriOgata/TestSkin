//%attributes = {}
// ----------------------------------------------------
// Method: Job_RnD_ResultsProvided   ( ) ->
// By: Mel Bohince @ 04/01/16, 14:20:09
// Description
// if this is r&d / proof/line trial then an exit interview is needed
// ----------------------------------------------------
$okToComplete:=True:C214


If (Count parameters:C259=0)
	$jf:=Request:C163("Which jobform?"; ""; "Ok"; "Cancel")
Else 
	$jf:=$1
End if 

If ([Job_Forms:42]JobFormID:5#$jf)  //record current
	READ WRITE:C146([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jf)
	
End if 

If (Position:C15(Substring:C12([Job_Forms:42]JobType:33; 1; 1); " 2 5 6 ")>0)  //[Job_Forms]JobTypeDescription
	//answer the questions
	If (Length:C16([Job_Forms:42]RnD_Tested:90)=0)
		$okToComplete:=False:C215
	End if 
	
	If (Length:C16([Job_Forms:42]RnD_Results:91)=0)
		$okToComplete:=False:C215
	End if 
	
End if 

$0:=$okToComplete



