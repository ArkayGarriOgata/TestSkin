//%attributes = {"publishedWeb":true}
//(p) ucancelestimate

If (Is new record:C668([Estimates:17]))  //try not to leave orphans
	If ((Records in selection:C76([Estimates_Differentials:38])>0) | (Records in selection:C76([Estimates_Carton_Specs:19])>0) | (Records in selection:C76([Estimates_PSpecs:57])>0))
		uConfirm("You are about to loose your estimate and its "+"differentials, carton specs, & process specs?"; "Proceed"; "Go back")
		If (ok=1)
			READ WRITE:C146([Estimates_Carton_Specs:19])
			READ WRITE:C146([Estimates_PSpecs:57])
			READ WRITE:C146([Estimates_Differentials:38])
			READ WRITE:C146([Estimates_Materials:29])
			READ WRITE:C146([Estimates_Machines:20])
			If (False:C215)  //avoid the sort
				gEstimateLDWkSh("Both")
			Else 
				QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1)
			End if 
			
			DELETE SELECTION:C66([Estimates_Carton_Specs:19])
			DELETE SELECTION:C66([Estimates_PSpecs:57])
			DELETE SELECTION:C66([Estimates_Differentials:38])
			DELETE SELECTION:C66([Estimates_Materials:29])
			DELETE SELECTION:C66([Estimates_Machines:20])
			CANCEL:C270
		End if 
		
	Else 
		CANCEL:C270
	End if   //ok, cancel the rec
	
Else   //not  on new record
	CANCEL:C270
End if 
//