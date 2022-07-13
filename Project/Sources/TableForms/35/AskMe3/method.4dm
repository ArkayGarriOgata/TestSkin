
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground(230; 230; 255; 255; 255; 255)
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Finished_Goods_Locations:35]; "Finished_Goods_Locations")
		
End case 
