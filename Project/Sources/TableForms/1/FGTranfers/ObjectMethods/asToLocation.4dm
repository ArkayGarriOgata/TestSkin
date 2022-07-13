//(s) [control]frTransfers.sCriterion4 
//If (Position(asMove{asMove};Self->)=0)
//Self->:=asMove{asMove}+Self->
//End if 

If (iMode=2)  //receiving
	If (Substring:C12(sCriterion4; 1; 2)#"CC")
		uConfirm("FG Receipts must go to CC:R or CC:"; "CC:R"; "CC:")
		If (ok=1)
			sCriterion4:="CC:R"
		Else 
			sCriterion4:="CC:"
		End if 
	End if 
End if 

If (sVerifyLocation(Self:C308))
	If (wms_locationsRequiringReason(Self:C308->))  //move to exam `•100798  mlb  UPR 1972
		sCriterion9:="Reject"
	Else 
		sCriterion9:=""
	End if 
	SetReturnReject
	
	//If (FGL_isBinOccupied (asMove{0}))
	//BEEP
	//ALERT("WARNING: "+asMove{0}+" is not an empty Location";"Continue")
	//End if 
End if 
//