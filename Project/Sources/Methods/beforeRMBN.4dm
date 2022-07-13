//%attributes = {"publishedWeb":true}
//(P) beforeRMBN: before phase processing for [RM_BINS]
//12/5/94 correct the spelling of AccountManger

If (User in group:C338(Current user:C182; "RoleCostAccountant") | (Current user:C182="Designer"))
	If (Is new record:C668([Raw_Materials_Locations:25]))
		ALERT:C41("Bin Location Records must be create via Receipt or Adjustment.")
		CANCEL:C270
	End if 
	
Else 
	uSetEntStatus(->[Raw_Materials_Locations:25]; False:C215)
End if 

READ ONLY:C145([Raw_Material_Labels:171])
RELATE MANY:C262([Raw_Materials_Locations:25]pk_id:32)
