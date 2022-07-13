
Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		recNum:=aRecNum{ListBox}
		ACCEPT:C269
		
	: (Form event code:C388=On Clicked:K2:4)
		recNum:=aRecNum{ListBox}
		If (recNum>=0)
			OBJECT SET ENABLED:C1123(*; "use"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "use"; False:C215)
		End if 
		
End case 