Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Count in array:C907(ListBox1; True:C214)=1) & (Count in array:C907(ListBox2; True:C214)=1)
			OBJECT SET ENABLED:C1123(bMatch; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bMatch; False:C215)
		End if 
		
		
		
	: (Form event code:C388=On Load:K2:1)
		aCPN:=Find in array:C230(aCPN; sCPN)
		PnP_DeliveryScheduleQry(sCPN)
		OBJECT SET ENABLED:C1123(b4Edit; True:C214)
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
End case 

