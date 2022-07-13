$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		If ([Jobs:15]ProcessSpec:14#[Job_Forms:42]ProcessSpec:46)
			Core_ObjectSetColor(->[Job_Forms:42]ProcessSpec:46; -(Red:K11:4+(256*White:K11:1)))
		Else 
			Core_ObjectSetColor(->[Job_Forms:42]ProcessSpec:46; -(Black:K11:16+(256*White:K11:1)))
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Job_Forms:42]; "clickedCSpec")
		
	: ($e=On Double Clicked:K2:5)
		
End case 
