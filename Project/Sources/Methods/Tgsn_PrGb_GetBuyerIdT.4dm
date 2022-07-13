//%attributes = {}
//Method:  Tgsn_PrGb_GetBuyerIdT(tBillTo)=>tBuyerID
//Description: This method returns the correct BuyerID

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tBillTo; $0; $tBuyerID)
	
	$tBillTo:=$1
	
	$tBuyerID:=CorektBlank
	
End if   //Done Initialize

Case of   //Which buyer
		
	: ($tBillTo="01957")  //The P&G Company
		
		$tBuyerID:=TgsnktBuyerIDPrGb
		
	: ($tBillTo="09517")  //P&G Manufacturing Company
		
		$tBuyerID:=TgsnktBuyerIDPrGbMnfc
		
End case   //Done which buyer

$0:=$tBuyerID
