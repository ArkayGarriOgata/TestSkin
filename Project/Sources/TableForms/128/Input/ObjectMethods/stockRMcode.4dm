READ ONLY:C145([Raw_Materials:21])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Finished_Goods_Color_SpecMaster:128]stockRMcode:10)
If (Records in selection:C76([Raw_Materials:21])#1)
	BEEP:C151
	ALERT:C41("this will later be a picklist")
	[Finished_Goods_Color_SpecMaster:128]stockRMcode:10:="Not valid"
Else 
	ALERT:C41("this will later select the vendor")
	
End if 
