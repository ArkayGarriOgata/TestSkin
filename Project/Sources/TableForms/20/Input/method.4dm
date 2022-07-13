Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Estimates_Machines:20]))
			CANCEL:C270
			
		Else 
			//OBJECT SET ENABLED(bDelete;False)  `user is not allow to delete these things
			If (imode>2)
				OBJECT SET ENABLED:C1123(bAddMatl; False:C215)
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
			End if 
			
			// Modified by Mel Bohince on 3/30/07 at 16:26:40 : Force update of obsolete CC's
			$hold_cc:=[Estimates_Machines:20]CostCtrID:4
			[Estimates_Machines:20]CostCtrID:4:=CostCenterEquivalent([Estimates_Machines:20]CostCtrID:4)
			If (Length:C16([Estimates_Machines:20]CostCtrID:4)=0)
				ALERT:C41("You need to replace the "+$hold_cc; "Try Again")
				[Estimates_Machines:20]CostCtrID:4:=CostCenterEquivalent($hold_cc)
				If (Length:C16([Estimates_Machines:20]CostCtrID:4)=0)
					ALERT:C41("You didn't replace the "+$hold_cc; "Abort")
					If (Current user:C182="kristopher koertge") | (Current user:C182="designer")
						[Estimates_Machines:20]CostCtrID:4:=Request:C163("Kris, enter whatever you want for the "+$hold_cc; $hold_cc; "OK"; "Cancel")
					Else 
						CANCEL:C270
					End if 
				End if 
			End if 
			
			CostCtr_FlexFieldLabels
			If ((Position:C15([Estimates_Machines:20]CostCtrID:4; <>EMBOSSERS)>0) | (Position:C15([Estimates_Machines:20]CostCtrID:4; <>STAMPERS)>0))
				$shouldUse:=CostCtr_Description_Tweak(->[Estimates_Machines:20]CostCtrName:2; "save")
			End if 
			
			Mat_ViaMach:=True:C214  //tells material delete procedure how to restore material selection
		End if 
		qryCostCenter([Estimates_Machines:20]CostCtrID:4; [Estimates_Machines:20]UseStdDated:43)  //3/15/95 upr 66    
		
		If (<>SubformCalc)  //3/20/95 upr 66
			If ([Estimates_Machines:20]FormChangeHere:9)  //3/15/95 upr 66 
				If (FORM Get current page:C276=2)
					//qryEstSubForm
				End if 
				Core_ObjectSetColor(->[Estimates_Machines:20]FormChangeHere:9; -(3+(256*0)))
				//[Estimates_Machines]Flex_field1:=Sum()  `it would be possible to
				//[Estimates_Machines]Flex_Field2:=Sum()  `chg these in a way so 
				//[Estimates_Machines]Flex_Field3:=Sum()  `that the after phase
				//[Estimates_Machines]Flex_Field4:=Sum()  `wont be run
				//[Estimates_Machines]Flex_Field7:=Sum()
			Else 
				Core_ObjectSetColor(->[Estimates_Machines:20]FormChangeHere:9; -(15+(256*0)))
			End if 
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		//If (◊SubformCalc)  `3/20/95 upr 66
		//If ([Estimates_Machines]FormChangeHere)  `3/15/95 upr 66  
		//[Estimates_Machines]Flex_field1:=Sum()
		//[Estimates_Machines]Flex_Field2:=Sum()
		//[Estimates_Machines]Flex_Field3:=Sum()
		//[Estimates_Machines]Flex_Field4:=Sum()
		//[Estimates_Machines]Flex_Field7:=Sum()
		//End if 
		//End if 
		
		If ((Position:C15([Estimates_Machines:20]CostCtrID:4; <>EMBOSSERS)>0) | (Position:C15([Estimates_Machines:20]CostCtrID:4; <>STAMPERS)>0))
			$shouldUse:=CostCtr_Description_Tweak(->[Estimates_Machines:20]CostCtrName:2; "save")
		End if 
		
		Estimate_ReCalcNeeded
		
		uUpdateTrail(->[Estimates_Machines:20]ModDate:35; ->[Estimates_Machines:20]ModWho:36; ->[Estimates_Machines:20]zCount:34)
		
	: (Form event code:C388=On Unload:K2:2)
		USE NAMED SELECTION:C332("materialsOnForm")
		Mat_viaMach:=False:C215
End case 