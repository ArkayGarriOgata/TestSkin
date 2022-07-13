//%attributes = {"publishedWeb":true}
//PM: FG_PrepServicePreApproved() -> 
//@author mlb - 2/28/03  16:18

If ([Finished_Goods_Specifications:98]PreApproved:67)
	util_setDateIfNull(->[Finished_Goods_Specifications:98]DateDirectFiled:66; 4D_Current_date)
	bQAfiled:=1
	FG_PrepServiceStateChange("Approved"; 4D_Current_date)
Else 
	bQAfiled:=0
	[Finished_Goods_Specifications:98]DateDirectFiled:66:=!00-00-00!
End if 
