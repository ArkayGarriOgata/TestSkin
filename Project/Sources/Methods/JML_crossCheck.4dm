//%attributes = {"publishedWeb":true}
//PM: JML_crossCheck() -> 
//@author mlb - 7/31/01  15:05

C_LONGINT:C283($i; $hit)

READ ONLY:C145([Job_Forms:42])

QUERY:C277([Job_Forms:42]; [Job_Forms:42]Status:6#"C@"; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Status:6#"K@"; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5#"@.00")  //find active forms
SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJF)
SORT ARRAY:C229($aJF; >)

READ ONLY:C145([Job_Forms_Master_Schedule:67])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]JobForm:4#"@.**")
SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; $aJML)
SORT ARRAY:C229($aJML; >)

xtext:="No JML found:"+Char:C90(13)
For ($i; 1; Size of array:C274($aJF))
	$hit:=Find in array:C230($aJML; $aJF{$i})
	If ($hit<0)
		xtext:=xtext+$aJF{$i}+Char:C90(13)
	End if 
End for 

xtext:=xtext+Char:C90(13)+Char:C90(13)+"No JF found:"+Char:C90(13)
For ($i; 1; Size of array:C274($aJML))
	$hit:=Find in array:C230($aJF; $aJML{$i})
	If ($hit<0)
		xtext:=xtext+$aJML{$i}+Char:C90(13)
	End if 
End for 

$docRef:=Create document:C266("JMLcrossChk.Log")
SEND PACKET:C103($docRef; xText)
CLOSE DOCUMENT:C267($docRef)