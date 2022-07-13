Case of 
	: (Form event code:C388=On Load:K2:1)
		vAskMePID:=0
		
	: (Form event code:C388=On Display Detail:K2:22)
		sCPN:=JMI_getCPN([WMS_aMs_Exports:153]Jobit:9)
		If ([WMS_aMs_Exports:153]BinId:10="BNRCC")
			Core_ObjectSetColor("*"; "s@"; -(Black:K11:16+(256*Light grey:K11:13)))
		Else 
			Core_ObjectSetColor("*"; "s@"; -(Black:K11:16+(256*White:K11:1)))
		End if 
End case 
