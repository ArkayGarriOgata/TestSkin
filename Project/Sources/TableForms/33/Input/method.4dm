//FM: input2() -> 
//@author Mel - 5/21/03  12:39

Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeFGRC
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Finished_Goods_Transactions:33]ModDate:17; ->[Finished_Goods_Transactions:33]ModWho:18; ->[Finished_Goods_Transactions:33]zCount:10)
End case 
//