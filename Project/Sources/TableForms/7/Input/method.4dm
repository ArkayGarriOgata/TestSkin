
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeVend
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		bDone:=1
		
	: (Form event code:C388=On Validate:K2:3)
		[Vendors:7]ModTimeStamp:31:=TSTimeStamp  //•091096  MLB  take any modification as msg trigger 
		[Vendors:7]ModDate:22:=4D_Current_date
		[Vendors:7]ModWho:23:=<>zResp
End case 
//