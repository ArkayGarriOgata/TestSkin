$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
		If ([Job_Forms_Items:44]Completed:39#!00-00-00!)
			Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Good:10; -(Red:K11:4+(256*Light grey:K11:13)); True:C214)
		Else 
			Core_ObjectSetColor(->[Job_Forms_Items:44]Qty_Good:10; -(Black:K11:16+(256*White:K11:1)); True:C214)
		End if 
		
	: ($e=On Clicked:K2:4)
		//GET HIGHLIGHTED RECORDS([Job_Forms_Items];"clickedIncluded")
		
	: ($e=On Double Clicked:K2:5)
		
End case 


//EOLP

