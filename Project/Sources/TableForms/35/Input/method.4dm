


//(LP) [FG_BINS]'Input
<>iLayout:=3501
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeFGBN
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Finished_Goods_Locations:35]ModDate:21; ->[Finished_Goods_Locations:35]ModWho:22; ->[Finished_Goods_Locations:35]zCount:18)
End case 
//