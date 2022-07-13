//%attributes = {}
// Method: CSM_Approve () -> 
// ----------------------------------------------------
// by: mel: 03/10/04, 10:55:29
// ----------------------------------------------------
//based on: FG_PrepServiceApprove(date) -> 
//@author mlb - 3/7/03  12:44

If ([Finished_Goods_Color_SpecMaster:128]Approved:23)
	If ([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19=!00-00-00!) | ([Finished_Goods_Color_SpecMaster:128]DateDone:20=!00-00-00!) | ([Finished_Goods_Color_SpecMaster:128]DateSent:21=!00-00-00!) | ([Finished_Goods_Color_SpecMaster:128]DateReturned:22=!00-00-00!)
		$continue:=False:C215
		CONFIRM:C162("Approve this spec without normal workflow?"; "Approve"; "Ooops")
		If (OK=1)
			$continue:=True:C214
			If ([Finished_Goods_Color_SpecMaster:128]DateReturned:22=!00-00-00!)
				[Finished_Goods_Color_SpecMaster:128]DateReturned:22:=4D_Current_date
			End if 
		Else 
			[Finished_Goods_Color_SpecMaster:128]Approved:23:=False:C215
		End if 
	Else 
		$continue:=True:C214
	End if 
	
End if 