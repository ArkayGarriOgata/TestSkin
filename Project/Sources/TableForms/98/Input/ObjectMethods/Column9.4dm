QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Finished_Goods_Specs_Inks:188]InkNumber:3)
If (Records in selection:C76([Raw_Materials:21])>0)
	[Finished_Goods_Specs_Inks:188]Color:4:=[Raw_Materials:21]Flex5:23
End if 

If (Length:C16([Finished_Goods_Specs_Inks:188]ControlNumber:6)=0)
	[Finished_Goods_Specs_Inks:188]ControlNumber:6:=[Finished_Goods_Specifications:98]ControlNumber:2
End if 
