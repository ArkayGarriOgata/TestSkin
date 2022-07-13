Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Job_Forms_Items_Costs:92]RemainingQuantity:15>0)
			Core_ObjectSetColor("*"; "displayfields"; -(Black:K11:16+(256*Light grey:K11:13)))
		Else 
			Core_ObjectSetColor("*"; "displayfields"; -(Light blue:K11:8+(256*Light grey:K11:13)))
		End if 
		
End case 