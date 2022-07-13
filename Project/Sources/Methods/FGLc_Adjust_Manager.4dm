//%attributes = {}
//Method:  FGLc_Adjust_Manager
//Description:  This method handles enabling and disabling of objects

If (True:C214)  //Initialize
	
	FGLc_tAdjust_Change:=CorektBlank
	
	OBJECT SET ENABLED:C1123(FGLc_nAdjust_AskMe; False:C215)  //Assume ask should be disabled
	OBJECT SET ENABLED:C1123(FGLc_nAdjust_ApplyChange; False:C215)  //Assume apply change should be disabled
	
	OBJECT SET RGB COLORS:C628(*; "Change"; Core_Color_GetRGBValueN(Light grey:K11:13); Background color none:K23:10)
	
End if   //Done Initialize

If (Core_ListBox_SelectedRowB(->FGLc_abAdjust_Negative))  //Ask me
	
	OBJECT SET ENABLED:C1123(FGLc_nAdjust_AskMe; True:C214)
	
End if   //Done ask me

Case of   //Apply change
		
	: (FGLc_tAdjust_Reason=CorektBlank)
	: (Not:C34(FGLc_Adjust_LocationChangeB(->FGLc_tAdjust_Change)))  //Change occurred
		
	Else   //Change
		
		OBJECT SET ENABLED:C1123(FGLc_nAdjust_ApplyChange; True:C214)
		
		OBJECT SET RGB COLORS:C628(*; "Change"; Core_Color_GetRGBValueN(Orange:K11:3); Background color none:K23:10)
		OBJECT SET RGB COLORS:C628(FGLc_tAdjust_Change; Core_Color_GetRGBValueN(Orange:K11:3); Background color none:K23:10)
		
End case   //Done apply change

