Case of 
	: (Form event code:C388=On Load:K2:1)
		$hit:=Find in array:C230(aSelected; "X")  //$i:=Find in array(ause;"•")
		If ($hit=-1)
			OBJECT SET ENABLED:C1123(bOk; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(bOk; True:C214)
		End if 
		
End case 
