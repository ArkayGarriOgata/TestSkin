//(s) sBinNo [rawmaterials]poarry
//allow user to change location, if changed to a location other than 
//an offical company/division - ask user for company
//• cs 2/13/97
//• 4/30/97 cs added code to create a text field for reporting on items
//  needing cross shipping (from one division to another)
// Modified by: Mel Bohince (10/28/21) add location ROC_WHS for roll stock

txt_CapNstrip(->sBinNo)
If (sVerifyLocation(->sBinNo))
	
	//If (sBinNo#sCompany)  //if this value changed
	//uConfirm ("You have changed the Location on this Item, was this your intent?";"Yes";"No")
	//If (OK=1)
	//$Tab:=Char(9)
	//  //xText:=sPoNumber+$Tab+sCompany+$Tab+sRmCode+$Tab+sBinNo+Char(13)  //• 4/30/97 cs added code to create a text 
	$arkay:=" Arkay Roanoke Vista ROC_WHS"  // Modified by: Mel Bohince (10/28/21) 
	If (Position:C15(sBinNo; $arkay)=0)  //if the new location is not a company
		$Text:="The Receiving Location on this item was changed to a location outside of Arkay.\r"
		$Text:=$Text+"Please select which Company/Division is to be responsible for this item."
		uYesNoCancel($Text; "Hauppauge"; "Roanoke"; "Vista")  //get user to make a sleection
		
		Case of   //assign hiden var based on user selection
			: (bAccept=1)  //Araky
				sCompany:="Hauppauge"
			: (bCancel=1)  //Roanoke
				sCompany:="Roanoke"
			: (bNo=1)  //Labels
				sCompany:="Vista"
		End case 
	Else   //it is a valid company make assignment to hidden var
		sCompany:=sBinNo
	End if 
	//End if 
End if 

//End if 