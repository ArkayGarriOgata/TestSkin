If (bSubmit=1)
	If (FG_PrepServiceManditoriesSet)
		FG_PrepServiceStateChange("Submit"; 4D_Current_date)
		
	Else 
		bSubmit:=0
		[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
		BEEP:C151
		ALERT:C41("To Submit, all sliders must be"+" set to 'No' or some value and the 'If so:s' are filled in."+Char:C90(13)+"See note in status bar below."; "Fix")
	End if 
	
Else 
	[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
End if 
