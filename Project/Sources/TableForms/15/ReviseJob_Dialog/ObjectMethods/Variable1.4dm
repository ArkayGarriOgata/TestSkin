tText:=Job_ReviseFindDiff([Estimates:17]EstimateNo:1; ->sState)
If (Length:C16(tText)>0)
	If (iJobId#0)
		iJobId:=Job_ReviseFindJob(iJobId)
	End if 
	
Else 
	GOTO OBJECT:C206(sState)
End if 


