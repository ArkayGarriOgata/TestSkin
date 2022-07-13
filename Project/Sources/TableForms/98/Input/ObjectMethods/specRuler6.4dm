Case of 
	: (calVar7=0)
		[Finished_Goods_Specifications:98]Coated:26:=""
	: (calVar7=1)
		[Finished_Goods_Specifications:98]Coated:26:="No"
		calVar8:=1
		[Finished_Goods_Specifications:98]CoatingMethod:27:="No"
		calVar9:=1
		[Finished_Goods_Specifications:98]CoatingOmit:28:="No"
	: (calVar7=2)
		[Finished_Goods_Specifications:98]Coated:26:="Dull"
	: (calVar7=3)
		[Finished_Goods_Specifications:98]Coated:26:="Satin"
	: (calVar7=4)
		[Finished_Goods_Specifications:98]Coated:26:="Semi"
	: (calVar7=5)
		[Finished_Goods_Specifications:98]Coated:26:="Gloss"
	Else 
		[Finished_Goods_Specifications:98]Coated:26:=""
End case 
