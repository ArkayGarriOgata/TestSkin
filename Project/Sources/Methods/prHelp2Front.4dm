//%attributes = {"publishedWeb":true}
//•3/3/97 cs I tried this and thought it better this way : - )

If (False:C215)
	$id:=uProcessID("Impact Assistant")
	If ($id#-1)
		BRING TO FRONT:C326($id)
	Else 
		$id:=New process:C317("uHelp"; <>lMinMemPart; "Impact Assistant")
		If (False:C215)
			//uHelp
		End if 
	End if 
End if 

ALERT:C41("I am sorry but the Help System is not currently functioning.")