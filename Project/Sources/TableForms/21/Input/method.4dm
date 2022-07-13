//(LP) [RAW_MATERIALS]Input
//• 7/29/97 cs added new field - maxhazardOnHand 
//this is a feld for tracking the maxiumamount of hazardous materials that
//are ALLOWED by law to be in storage. - will be used by Req/POs to limit orders
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeRM
		
	: (Form event code:C388=On Validate:K2:3)
		[Raw_Materials:21]ModDate:47:=4D_Current_date
		[Raw_Materials:21]ModWho:48:=<>zResp
		
	: (Form event code:C388=On Unload:K2:2)
		fRMMaint:=False:C215
		
		UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
		UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
End case 
//EOLP