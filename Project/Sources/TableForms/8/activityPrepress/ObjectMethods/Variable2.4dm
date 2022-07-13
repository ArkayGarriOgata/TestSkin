Case of 
	: (Form event code:C388=On Clicked:K2:4)
		utl_HelpSelector
		
	: (Form event code:C388=On Load:K2:1)
		If (iHelpItem<1)
			iHelpItem:=1
		End if 
		SELECT LIST ITEMS BY POSITION:C381(hlHelp; iHelpItem)
End case 