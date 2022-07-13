//%attributes = {"publishedWeb":true}
//PM:  Job_ReviseFindJob  2/27/01  mlb
//load job and its forms 

C_LONGINT:C283($1; $0; $jobid)
ARRAY TEXT:C222(aJFid; 0)
ARRAY TEXT:C222(asOrdStat; 0)
ARRAY TEXT:C222(aSelected; 0)
ARRAY DATE:C224(aDate; 0)
ARRAY LONGINT:C221(aRecNo; 0)

$jobid:=0

QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$1)
If (Records in selection:C76([Jobs:15])=1)
	$jobid:=[Jobs:15]JobNo:1
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=$jobid)
	If (Records in selection:C76([Job_Forms:42])>0)
		SELECTION TO ARRAY:C260([Job_Forms:42]; aRecNo; [Job_Forms:42]JobFormID:5; aJFid; [Job_Forms:42]Status:6; asOrdStat; [Job_Forms:42]PlnnerReleased:59; aDate)
	End if 
	
	SELECTION TO ARRAY:C260([Estimates_DifferentialsForms:47]; $aRecNo; [Estimates_DifferentialsForms:47]FormNumber:2; $aFormNo)
	For ($i; 1; Size of array:C274($aRecNo))
		$jobForm:=String:C10($jobid; "00000")+"."+String:C10($aFormNo{$i}; "00")
		$hit:=Find in array:C230(aJFid; ($jobForm))
		If ($hit=-1)  //new form
			INSERT IN ARRAY:C227(aRecNo; 1; 1)
			INSERT IN ARRAY:C227(aJFid; 1; 1)
			INSERT IN ARRAY:C227(asOrdStat; 1; 1)
			INSERT IN ARRAY:C227(aDate; 1; 1)
			aRecNo{1}:=-1*$aRecNo{$i}
			aJFid{1}:=$jobForm
			asOrdStat{1}:="New"
			aDate{1}:=!00-00-00!
		End if 
	End for 
	
	SORT ARRAY:C229(aJFid; aRecNo; asOrdStat; aDate; >)
	ARRAY TEXT:C222(aSelected; Size of array:C274(aJFid))
	For ($i; 1; Size of array:C274(aJFid))
		Case of 
			: (asOrdStat{$i}="C@")  //closed or complete
				aSelected{$i}:=""
			: (asOrdStat{$i}="WIP")  //in productions' hands
				aSelected{$i}:=""
			Else 
				aSelected{$i}:="X"
		End case 
	End for 
	
Else 
	REDUCE SELECTION:C351([Jobs:15]; 0)
	$jobid:=0
	ALERT:C41("Job "+String:C10($1)+" was not found")
End if 

$0:=$jobid