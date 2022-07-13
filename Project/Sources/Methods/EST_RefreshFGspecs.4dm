//%attributes = {"publishedWeb":true}
//Est_RefreshFGspecs
//update all the cartonSpecs to the current info in the FG record

uConfirm("Update ALL CartonSpecs to match their FinishedGood record?"; "Refresh"; "Cancel")
If (OK=1)
	CUT NAMED SELECTION:C334([Estimates_Carton_Specs:19]; "refresh")
	gEstimateLDWkSh("Both")
	ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]ProductCode:5; >)
	For ($i; 1; Records in selection:C76([Estimates_Carton_Specs:19]))
		$Found:=qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5)
		If ($Found>0)
			FG_CspecLikeFG
		End if 
		
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
		NEXT RECORD:C51([Estimates_Carton_Specs:19])
	End for 
	
	USE NAMED SELECTION:C332("refresh")
End if   //ok