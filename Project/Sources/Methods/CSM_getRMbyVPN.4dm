//%attributes = {}
// Method: CSM_getRMbyVPN () -> 
// ----------------------------------------------------
// by: mel: 10/25/03, 10:43:24
// ----------------------------------------------------

If (Length:C16([Finished_Goods_Color_SpecSolids:129]vpn:5)>0) & (Length:C16([Finished_Goods_Color_SpecSolids:129]inkRMcode:4)=0)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]VendorPartNum:3=[Finished_Goods_Color_SpecSolids:129]vpn:5)
	If (Records in selection:C76([Raw_Materials:21])>0)
		[Finished_Goods_Color_SpecSolids:129]colorName:10:=[Raw_Materials:21]Flex5:23
		[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:=[Raw_Materials:21]Raw_Matl_Code:1
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
	End if 
	SET QUERY LIMIT:C395(0)
End if 