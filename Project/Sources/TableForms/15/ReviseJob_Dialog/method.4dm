Case of 
	: (Form event code:C388=On Data Change:K2:15)
		$hit:=Find in array:C230(aSelected; "X")
		If (Length:C16(tTitle)>0) & (Length:C16(sState)=2) & (iJobid>0) & ($hit>-1)
			OBJECT SET ENABLED:C1123(bRevise; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bRevise; False:C215)
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		If (Length:C16(sState)>0)
			tText:=Job_ReviseFindDiff([Estimates:17]EstimateNo:1; ->sState)
		Else 
			tText:=""
		End if 
		
		If (Length:C16(tText)>0)
			If ([Estimates:17]JobNo:50#0)
				iJobId:=Job_ReviseFindJob([Estimates:17]JobNo:50)
			End if 
		End if 
		
		tTitle:=""
		$hit:=Find in array:C230(aSelected; "X")
		If (Length:C16(tTitle)>0) & (Length:C16(sState)=2) & (iJobid>0) & ($hit>-1)
			OBJECT SET ENABLED:C1123(bRevise; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bRevise; False:C215)
		End if 
		
		GOTO OBJECT:C206(tTitle)
End case 