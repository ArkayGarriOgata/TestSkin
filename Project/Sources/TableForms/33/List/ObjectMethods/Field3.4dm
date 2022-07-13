Case of 
	: ([Finished_Goods_Transactions:33]XactionType:2="Move")
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(15+(256*0)))  //blak 
		OBJECT SET FONT STYLE:C166([Finished_Goods_Transactions:33]XactionType:2; 0)  //bold     
		
	: ([Finished_Goods_Transactions:33]XactionType:2="Ship")
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(9+(256*0)))  //green  
		OBJECT SET FONT STYLE:C166([Finished_Goods_Transactions:33]XactionType:2; 1)  //bold
		
	: ([Finished_Goods_Transactions:33]XactionType:2="RevShip")
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(8+(256*1)))  //
	: ([Finished_Goods_Transactions:33]XactionType:2="Return")
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(8+(256*1)))  //   
	: ([Finished_Goods_Transactions:33]XactionType:2="Scrap")
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(8+(256*1)))  //  
		
	Else   //receipt
		Core_ObjectSetColor(->[Finished_Goods_Transactions:33]XactionType:2; -(3+(256*0)))  //red
		OBJECT SET FONT STYLE:C166([Finished_Goods_Transactions:33]XactionType:2; 1)  //bold
		
End case 