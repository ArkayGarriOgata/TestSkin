//%attributes = {}
// Method: CSM_getRMbyColor () -> 
// ---------------------------------------------------
// by: mel: 10/25/03, 10:36:40
// ----------------------------------------------------

Case of 
	: ([Finished_Goods_Color_SpecSolids:129]colorName:10="c")
		[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:="KU-88201"
		//[ColorSpecSolid]approved:=True
		
	: ([Finished_Goods_Color_SpecSolids:129]colorName:10="y")
		[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:="KU-88203"
		//[ColorSpecSolid]approved:=True
		
	: ([Finished_Goods_Color_SpecSolids:129]colorName:10="m")
		[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:="KU-88202"
		//[ColorSpecSolid]approved:=True
		
	: ([Finished_Goods_Color_SpecSolids:129]colorName:10="k")
		[Finished_Goods_Color_SpecSolids:129]inkRMcode:4:="8KYY26173"
		//[ColorSpecSolid]approved:=True
End case 

If (Length:C16([Finished_Goods_Color_SpecSolids:129]inkRMcode:4)>0)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Finished_Goods_Color_SpecSolids:129]inkRMcode:4)
	If (Records in selection:C76([Raw_Materials:21])>0)
		[Finished_Goods_Color_SpecSolids:129]colorName:10:=[Raw_Materials:21]Flex5:23
		[Finished_Goods_Color_SpecSolids:129]vpn:5:=[Raw_Materials:21]VendorPartNum:3
		REDUCE SELECTION:C351([Raw_Materials:21]; 0)
	End if 
	SET QUERY LIMIT:C395(0)
End if 