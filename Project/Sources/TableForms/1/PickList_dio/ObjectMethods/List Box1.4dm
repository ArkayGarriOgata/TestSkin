Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$hit:=Find in array:C230(ListBox1; True:C214)
		If ($hit>-1)
			OBJECT SET ENABLED:C1123(bPick; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPick; False:C215)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		bPick:=1
		ACCEPT:C269
End case 
