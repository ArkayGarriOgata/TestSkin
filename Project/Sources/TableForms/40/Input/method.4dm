//(LP) [CustomerOrder]'Input 
//mod 3/21/94 upr1028
//upr 1169 8/9/94
//upr 1115  11/18/94 chip
//upr 1221 11/22/94
//upr 1362 02/14/95 chip
//Upr 1268 02/16/95 chip
//2/15/95 upr 1326
//•060195  MLB  UPR 184
//• 10/7/97 cs memory efficency
//•110998  MLB  UPR sort by item#
Case of 
	: (Form event code:C388=On Load:K2:1)
		BeforeCustOrder  //• 10/7/97 cs memory saving
		//app_Log_Usage ("log";util_formName (Current form table);util_readOnlyState (Current form table))
		
	: (Form event code:C388=On Validate:K2:3)
		AfterCustOrder  //• 10/7/97 cs memory saving
		
	: (Form event code:C388=On Unload:K2:2)
		<>AskMeCust:="KILL"
		POST OUTSIDE CALL:C329(vAskMePID)
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
End case 

