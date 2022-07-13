Case of 
	: (Form event code:C388=On Load:K2:1)
		b4:=1
		lastTab:=<>Activitiy
		If (lastTab<1)  // Modified by: Mel Bohince (11/24/15) a zero causes a crash in v14.4
			lastTab:=1
		End if 
		
		SELECT LIST ITEMS BY POSITION:C381(iJMLtabs; lastTab)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		bDone:=1
		
	Else 
		RELATE ONE:C42([Finished_Goods_Color_SpecMaster:128]projectId:4)
End case 