
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Clicked:K2:4)
		//GET HIGHLIGHTED RECORDS([Job_Forms_Items];"clickedIncluded")
		
	: ($e=On Double Clicked:K2:5)
		
End case 

