Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$hit:=Find in array:C230(ListBox1; True:C214)
		If ($hit>-1)
			OBJECT SET ENABLED:C1123(bOk; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bOk; False:C215)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		bOk:=1
		ACCEPT:C269
End case 
