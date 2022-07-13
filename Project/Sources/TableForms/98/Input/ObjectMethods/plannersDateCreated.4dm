If ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
	If (FG_PrepServiceManditoriesSet)
		FG_PrepServiceStateChange("Submit"; [Finished_Goods_Specifications:98]DateSubmitted:5)
	Else 
		bSubmit:=0
		[Finished_Goods_Specifications:98]DateSubmitted:5:=!00-00-00!
		BEEP:C151
		ALERT:C41("To Submit, all sliders must be"+" set to 'No' or some value and the 'If so:s' are filled in."; "Fix")
	End if 
Else 
	bSubmit:=0
End if 