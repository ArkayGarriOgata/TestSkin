//%attributes = {"publishedWeb":true}
//(P) beforeRMRC: before phase processing for [RM_BINS]

Case of 
	: (<>rmXferInquire)
		//just display
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		//OBJECT SET ENABLED(bValidate;False)
		uSetEntStatus(->[Raw_Materials_Transactions:23]; False:C215)
		
	: (Is new record:C668([Raw_Materials_Transactions:23]))
		uSetEntStatus(->[Raw_Materials_Transactions:23]; True:C214)
		[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
		[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]Reason:5:="Created by Accounting"
		//OBJECT SET ENABLED(bDelete;False)
		OBJECT SET ENABLED:C1123(bValidate; True:C214)
		
	Else 
		uSetEntStatus(->[Raw_Materials_Transactions:23]; True:C214)
		OBJECT SET ENABLED:C1123(bDelete; True:C214)
		OBJECT SET ENABLED:C1123(bValidate; True:C214)
End case 

SetObjectProperties(""; ->[Raw_Materials_Transactions:23]ModWho:18; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Raw_Materials_Transactions:23]ModDate:17; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)