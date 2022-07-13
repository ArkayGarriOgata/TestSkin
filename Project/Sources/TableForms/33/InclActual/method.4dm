$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Clicked:K2:4)
		//GET HIGHLIGHTED RECORDS([Finished_Goods_Transactions];"clickedIncluded")
		
	: ($e=On Double Clicked:K2:5)
		
End case 

