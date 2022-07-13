Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (aSelected{ListBox1}="")
			aSelected{ListBox1}:="X"
		Else 
			aSelected{ListBox1}:=""
		End if 
		
		$hit:=Find in array:C230(aSelected; "X")
		If ($hit>-1)
			OBJECT SET ENABLED:C1123(bOK; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bOK; False:C215)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		aSelected{ListBox1}:="X"
		bOK:=1
		ACCEPT:C269
End case 