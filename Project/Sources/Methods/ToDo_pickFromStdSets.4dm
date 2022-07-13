//%attributes = {"publishedWeb":true}
//PM: ToDo_pickFromStdSets() -> 
//@author mlb - 5/13/02  16:39
C_TEXT:C284($jobform; $1; $pjtNum; $3)
C_DATE:C307($dateDue; $2)
If (Count parameters:C259=3)
	$jobform:=$1
	$dateDue:=$2
	$pjtNum:=$3
	ok:=1
Else 
	<>jobform:=Request:C163("The Tasks are for job form:"; <>jobform; "Continue"; "Cancel")
	$jobform:=<>jobform
	READ ONLY:C145([Jobs:15])
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12(<>jobform; 1; 5))))
	If (Records in selection:C76([Jobs:15])>0)
		$pjtNum:=[Jobs:15]ProjectNumber:18
		REDUCE SELECTION:C351([Jobs:15]; 0)
	Else 
		$pjtNum:=""
	End if 
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=<>jobform)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		$dateDue:=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	Else 
		$dateDue:=!00-00-00!
	End if 
End if 

If (ok=1)
	//select the approvals required for this job
	C_LONGINT:C283($i)
	
	READ WRITE:C146([To_Do_Tasks:100])
	READ ONLY:C145([To_Do_Tasks_Sets:99])
	ALL RECORDS:C47([To_Do_Tasks_Sets:99])
	ORDER BY:C49([To_Do_Tasks_Sets:99]; [To_Do_Tasks_Sets:99]Category:2; >; [To_Do_Tasks_Sets:99]Task:3; >)
	ARRAY TEXT:C222(aBullet; 0)
	SELECTION TO ARRAY:C260([To_Do_Tasks_Sets:99]id:1; aAppvId; [To_Do_Tasks_Sets:99]Category:2; aAppvCat; [To_Do_Tasks_Sets:99]Task:3; aAppvName; [To_Do_Tasks_Sets:99]AssignedTo:5; aAppvGroup)
	ARRAY TEXT:C222(aBullet; Size of array:C274(aAppvId))
	REDUCE SELECTION:C351([To_Do_Tasks_Sets:99]; 0)
	
	QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=$jobform)
	CREATE SET:C116([To_Do_Tasks:100]; "approvalForThisJob")
	SELECTION TO ARRAY:C260([To_Do_Tasks:100]Task:3; $aPrevious)
	For ($i; 1; Size of array:C274($aPrevious))
		$hit:=Find in array:C230(aAppvName; $aPrevious{$i})
		If ($hit>-1)
			aBullet{$hit}:="√"
		End if 
	End for 
	
	NewWindow(450; 320; 0; 5; "Click on the Approvals Required for form "+$jobform)
	DIALOG:C40([To_Do_Tasks_Sets:99]; "PickFromList")
	CLOSE WINDOW:C154
	
	If (ok=1)
		
		
		For ($i; 1; Size of array:C274(aBullet))
			USE SET:C118("approvalForThisJob")
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]Task:3=aAppvName{$i})
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			
			Case of 
				: (aBullet{$i}="")  //remove
					If (Records in selection:C76([To_Do_Tasks:100])>0)
						CREATE SET:C116([To_Do_Tasks:100]; "removeApp")
						DIFFERENCE:C122("approvalForThisJob"; "removeApp"; "approvalForThisJob")
						CLEAR SET:C117("removeApp")
						DELETE SELECTION:C66([To_Do_Tasks:100])
					End if 
					
				: (aBullet{$i}="√")  //add
					If (Records in selection:C76([To_Do_Tasks:100])=0)
						CREATE RECORD:C68([To_Do_Tasks:100])
						[To_Do_Tasks:100]Jobform:1:=$jobform
						[To_Do_Tasks:100]Category:2:=aAppvCat{$i}
						[To_Do_Tasks:100]Task:3:=aAppvName{$i}
						[To_Do_Tasks:100]CreatedBy:8:=<>zResp
						If (Length:C16(aAppvGroup{$i})>0)
							[To_Do_Tasks:100]AssignedTo:9:=aAppvGroup{$i}
						Else 
							[To_Do_Tasks:100]AssignedTo:9:=Current user:C182
						End if 
						
						[To_Do_Tasks:100]DateDue:10:=$dateDue
						[To_Do_Tasks:100]PjtNumber:5:=$pjtNum
						SAVE RECORD:C53([To_Do_Tasks:100])
						ADD TO SET:C119([To_Do_Tasks:100]; "approvalForThisJob")
					End if 
					
			End case 
		End for 
		
		USE SET:C118("approvalForThisJob")
		CLEAR SET:C117("approvalForThisJob")
		
	End if 
End if 
