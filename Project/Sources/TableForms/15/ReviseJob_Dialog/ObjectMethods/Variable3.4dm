If (Length:C16(tText)=0)
	If (Length:C16(sState)>0)
		tText:=Job_ReviseFindDiff([Estimates:17]EstimateNo:1; ->sState)
	End if 
End if 

If (Length:C16(tText)>0)
	If (iJobId#0)
		iJobId:=Job_ReviseFindJob(iJobId)
		If ([Jobs:15]Status:4="Reserved")
			tTitle:="Plan Established"
		Else 
			tTitle:=""
		End if 
		
	End if 
Else 
	GOTO OBJECT:C206(sState)
End if 