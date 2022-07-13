//%attributes = {"publishedWeb":true}
//(p) sLocRMFromPOI
//• 6/12/97 cs created from script in RM field on Req
//$1 - flag this is called from Requisition
//• cs 9/10/97 
C_TEXT:C284($1)
fNewRM:=True:C214
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
Case of 
	: (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		If (Not:C34(User in group:C338(Current user:C182; "RMcreate")))
			ALERT:C41([Purchase_Orders_Items:12]Raw_Matl_Code:15+" Does Not Exist. Contact the Purchasing Department.")  //• mlb - 5/9/02  15:00stop createion
			sPOIClearRM("*")
			[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
			
		Else 
			ALERT:C41([Purchase_Orders_Items:12]Raw_Matl_Code:15+" Does Not Exist. Please Enter the Details.")  //BA
			iComm:=0  //• 4/11/97 cs 
			tSubGroup:=""  //• 4/11/97 cs 
			fNewRM:=True:C214
			[Purchase_Orders_Items:12]Qty_Shipping:4:=0  //q-mail 1/20/95
			[Purchase_Orders_Items:12]ExtPrice:11:=0
			[Purchase_Orders_Items:12]Qty_Ordered:30:=0  //q-mail 1/20/95
			[Purchase_Orders_Items:12]CompanyID:45:=[Purchase_Orders:11]CompanyID:43  //on new RMs the company ID is not being set
		End if 
		
	: (Records in selection:C76([Raw_Materials:21])=1)
		If ([Raw_Materials:21]Status:25="Active")
			CONFIRM:C162("Make this order item like: "+[Raw_Materials:21]Raw_Matl_Code:1+"  -  "+[Raw_Materials:21]Description:4)
			If (ok=1)
				If (Count parameters:C259=0)
					POI_makeLikeRM
				Else 
					POI_makeLikeRM("*")
				End if 
				sRMflexFields([Purchase_Orders_Items:12]CommodityCode:16; 1)
				iComm:=[Purchase_Orders_Items:12]CommodityCode:16
				fNewRm:=False:C215
				
			Else 
				BEEP:C151
				ALERT:C41([Raw_Materials:21]Raw_Matl_Code:1+" is no longer an Active item, contact Purchasing for a replacement item.")
				REDUCE SELECTION:C351([Raw_Materials:21]; 0)
				sPOIClearRM("*")
				[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""  //• cs 9/10/97 stop ability to attempt to create a dup RM code    
			End if 
			
		Else 
			REDUCE SELECTION:C351([Raw_Materials:21]; 0)
			sPOIClearRM("*")
			[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""  //• cs 9/10/97 stop ability to attempt to create a dup RM code    
		End if 
		
	Else   //multiple hits
		BEEP:C151
		
End case 

//