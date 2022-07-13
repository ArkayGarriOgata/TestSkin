//%attributes = {"publishedWeb":true}
//PM: PS_pickSequence(job) -> jobSequence
//@author mlb - 5/20/02  16:52

C_LONGINT:C283($1; $job; $winRef; $hit)
C_TEXT:C284($0)
//pick seq from array
ARRAY TEXT:C222(aOL; 0)
ARRAY TEXT:C222(aBullet; 0)

$job:=$1

READ ONLY:C145([Job_Forms_Machines:43])
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=String:C10($job)+"@")
SELECTION TO ARRAY:C260([Job_Forms_Machines:43]JobForm:1; $aJF; [Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]CostCenterID:4; $aCC)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
$numSeq:=Size of array:C274($aJF)
ARRAY TEXT:C222(aOL; $numSeq)

For ($i; 1; $numSeq)
	aOL{$i}:=Substring:C12($aJF{$i}; 7; 2)+"."+String:C10($aSeq{$i}; "000")+" "+$aCC{$i}
End for 
If ($numSeq>0)
	SORT ARRAY:C229(aOL; >)
	ARRAY TEXT:C222(aBullet; $numSeq)
	
	$winRef:=Open form window:C675([zz_control:1]; "SimplePick"; 5)
	t10:="Click 1 "+String:C10($job)+" Seq wanted in the "+sCriterion1+" schedule"
	DIALOG:C40([zz_control:1]; "SimplePick")
	CLOSE WINDOW:C154($winRef)
	If (ok=1)
		$hit:=Find in array:C230(aBullet; "•")
		$0:=String:C10($job)+"."+Substring:C12(aOL{$hit}; 1; 6)
		
	Else 
		$0:="no pick"
	End if 
End if 
ARRAY TEXT:C222(aOL; 0)
ARRAY TEXT:C222(aBullet; 0)