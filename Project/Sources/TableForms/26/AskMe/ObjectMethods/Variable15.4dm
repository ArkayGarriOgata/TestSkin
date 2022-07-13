//•031297  mBohince 


//$winRef:=OpenSheetWindow (->[zz_control];"FGNotesDisplay";"AskMe Preferences"
If (allOrderlines=1)
	$ord:="ON"
Else 
	$ord:="OFF"
End if 
If (allReleases=1)
	$rel:="ON"
Else 
	$rel:="OFF"
End if 
If (allinventory=1)
	$inv:="ON"
Else 
	$inv:="OFF"
End if 
If (allJobs=1)
	$job:="ON"
Else 
	$job:="OFF"
End if 
If (True:C214)  //(iHistory=1)
	$hist:=String:C10(Size of array:C274(<>aAskMeHistory))
Else 
	$hist:="0"
End if 
uConfirm("Show all:"+" Orders="+$ord+" Releases="+$rel+" Inventory="+$inv+" Jobs="+$job+" History="+$hist; "Coming Soon"; "Help")
BEEP:C151
//CLOSE WINDOW

