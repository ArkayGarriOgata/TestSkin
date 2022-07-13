Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$i:=Find in array:C230(aSelected; "X")
		If (($i>-1) & (asDiff2>0))
			OBJECT SET ENABLED:C1123(bPick; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
		End if 
		
End case 
