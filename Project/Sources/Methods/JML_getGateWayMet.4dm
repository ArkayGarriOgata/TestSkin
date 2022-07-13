//%attributes = {"publishedWeb":true}
//PM: JML_getGateWayMet(jobform) -> date
//@author mlb - 3/4/02  12:09
//call by JML_AutoUpdate, currently (11/09/04) disabled
// • mel (11/17/04, 16:19:07) re enabled

C_TEXT:C284($1)
C_DATE:C307($0)

$0:=!00-00-00!

If ([Job_Forms_Master_Schedule:67]JobForm:4#$1)
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
End if 

If (util_isDateNull(->[Job_Forms_Master_Schedule:67]DateClosingMet:23))
	If ([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18#!00-00-00!) & ([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12#!00-00-00!)
		If ([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18>[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12)
			$0:=[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18
		Else 
			$0:=[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12
		End if 
		
	Else   //incase it was set manually
		$0:=[Job_Forms_Master_Schedule:67]DateClosingMet:23
	End if 
	
Else   //incase it was set manually
	$0:=[Job_Forms_Master_Schedule:67]DateClosingMet:23
End if 