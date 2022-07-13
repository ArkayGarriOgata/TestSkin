//FM: RM_Xfer Maintenance() -> 
//@author Mel - 5/21/03  11:37

Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeRMRC
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Raw_Materials_Transactions:23]ModDate:17; ->[Raw_Materials_Transactions:23]ModWho:18; ->[Raw_Materials_Transactions:23]zCount:16)
End case 
//

