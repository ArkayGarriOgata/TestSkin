<>iLayout:=2311  //(LP) [RM_XFER]'InputIS
Case of 
	: (fChoose)  //Choice List, do nothing    
	: (Form event code:C388=On Load:K2:1)
		beforeRMIS
		
	: (Form event code:C388=On Validate:K2:3)
		If (Modified record:C314([Raw_Materials_Transactions:23]))
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		End if 
End case 
//