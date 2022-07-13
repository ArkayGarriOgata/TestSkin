//(s)[Estimate].Input_bDelCarton
// Modified by: Garri Ogata (5/10/21) Commented out adding spaces to [Estimates_DifferentialsForms]Notes

If (app_LoadIncludedSelection("init"; ->[Estimates_Carton_Specs:19]CartonSpecKey:7; "CSPEC")=1)
	$diff:=[Estimates_Carton_Specs:19]diffNum:11  //should be ◊sQtyWorksht
	$item:=[Estimates_Carton_Specs:19]Item:1
	If ($diff=<>sQtyWorksht)
		uConfirm("Are you sure you want to delete item: "+[Estimates_Carton_Specs:19]Item:1+" code: "+[Estimates_Carton_Specs:19]ProductCode:5+" from ALL differentials?"; "Delete"; "Cancel")
		If (OK=1)
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
			QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]Item:1=$item)
			If (Records in selection:C76([Estimates_Carton_Specs:19])>0)  //able to find it
				RELATE MANY SELECTION:C340([Estimates_FormCartons:48]Carton:1)
				If (Records in selection:C76([Estimates_FormCartons:48])>0)
					util_DeleteSelection(->[Estimates_FormCartons:48])  //delete the formcartons
				End if 
				//now delete the cspecs
				util_DeleteSelection(->[Estimates_Carton_Specs:19])
			End if 
			
			C_LONGINT:C283($i; $numDiff)
			$numDiff:=Records in selection:C76([Estimates_Differentials:38])
			//If ($diff=◊sQtyWorksht)  `then it needs to be taken off all forms
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				FIRST RECORD:C50([Estimates_Differentials:38])
				For ($i; 1; $numDiff)
					Estimate_ReCalcNeeded
					NEXT RECORD:C51([Estimates_Differentials:38])
				End for 
				
				
			Else 
				
				//¨4D PS :why i Estimate_ReCalcNeeded you have line 22 see fonction Estimate_ReCalcNeeded
				APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]TotalPieceYld:10:=0)
				APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]TotalPieces:8:=0)
				APPLY TO SELECTION:C70([Estimates_Differentials:38]; [Estimates_Differentials:38]CostTTL:14:=0)
				
				// Modified by: Garri Ogata (5/10/21) 
				//For ($i;1;$numDiff)
				//[Estimates_DifferentialsForms]Notes:=[Estimates_DifferentialsForms]Notes+" "
				//End for 
				
				
			End if   // END 4D Professional Services : January 2019 First record
			
			gEstimateLDWkSh("Last")
			
		Else 
			app_LoadIncludedSelection("clear"; ->[Estimates_Carton_Specs:19]CartonSpecKey:7; "CSPEC")
		End if 
		
	Else 
		uConfirm("Are you sure you want to delete item: "+[Estimates_Carton_Specs:19]Item:1+" code: "+[Estimates_Carton_Specs:19]ProductCode:5+" from differential "+$diff+"?"; "Delete"; "Cancel")
		If (OK=1)
			RELATE MANY:C262([Estimates_FormCartons:48]Carton:1)
			If (Records in selection:C76([Estimates_FormCartons:48])>0)
				util_DeleteSelection(->[Estimates_FormCartons:48])  //delete the formcartons
			End if 
			//now delete the cspecs
			util_DeleteSelection(->[Estimates_Carton_Specs:19])
		End if 
	End if 
	
Else 
	app_LoadIncludedSelection("clear"; ->[Estimates_Carton_Specs:19]CartonSpecKey:7; "CSPEC")
	uConfirm("Select ONE carton."; "OK"; "Help")
End if 