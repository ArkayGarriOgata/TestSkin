

// Method: [Job_Forms].InputActual2.modOnlyButton2 ( )  -> 
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
If (Not:C34(<>Auto_Ink_Issue))  // Modified by: Mel Bohince (9/13/13) 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "beforeInk")
		InkPO([Job_Forms:42]JobFormID:5; "*")
		USE NAMED SELECTION:C332("beforeInk")
		CLEAR NAMED SELECTION:C333("beforeInk")
		
	Else 
		//InkPO empty methode
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	BEEP:C151
End if 

