Case of 
	: (Form event code:C388=On Load:K2:1)
		xText:=<>FloatingAlert
		
	: (Form event code:C388=On Outside Call:K2:11)
		If (Not:C34(<>fQuit4D))
			If (Substring:C12(<>FloatingAlert; 1; 1)#"&")  //not an prefix
				xText:=<>FloatingAlert
			Else 
				xText:=<>FloatingAlert+Char:C90(13)+"-----"+Char:C90(13)+xText
			End if 
			
			If (Length:C16(xText)>0)
				SHOW PROCESS:C325(Current process:C322)
				BRING TO FRONT:C326(Current process:C322)
			Else 
				HIDE PROCESS:C324(Current process:C322)
			End if 
			
		Else 
			CANCEL:C270
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		HIDE PROCESS:C324(Current process:C322)
		
	: (Form event code:C388=On Close Box:K2:21)
		HIDE PROCESS:C324(Current process:C322)
		
End case 
