//%attributes = {"publishedWeb":true}
//(p) zoomRm
//upr 1294 11/2/94
//• 6/12/97 cs cleared selection when canceled
//  added incomming parameter flag for Requisition call
C_LONGINT:C283($temp; $recNo)
C_TEXT:C284($1)
$temp:=iMode

If ($temp<=2)
	iMode:=2
Else 
	iMode:=3
End if 
fromZoom:=True:C214
iMode:=2

//READ WRITE([Raw_Materials])
POI_ClearInputForm([Purchase_Orders_Items:12]Raw_Matl_Code:15)

If (Length:C16([Purchase_Orders_Items:12]Raw_Matl_Code:15)>0)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
	QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]Status:25="Active")
	
	Case of 
		: (Records in selection:C76([Raw_Materials:21])=1)
			//uConfirm ("Make this order item like: "+[Raw_Materials]Raw_Matl_Code+"  -  "+[Raw_Materials]Description;"Yes";"No")
			//If (ok=1)
			POI_RMcodeChanged
			//
			//Else 
			//[Purchase_Orders_Items]Raw_Matl_Code:=""
			//GOTO AREA([Purchase_Orders_Items]Raw_Matl_Code)
			//End if 
			
		: (Records in selection:C76([Raw_Materials:21])>1)
			uConfirm([Purchase_Orders_Items:12]Raw_Matl_Code:15+" does not uniquely describe a R/M. Use the 'Pick R/M' button."; "Try Again"; "Help")
			[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
			GOTO OBJECT:C206([Purchase_Orders_Items:12]Raw_Matl_Code:15)
			
		Else 
			uConfirm([Purchase_Orders_Items:12]Raw_Matl_Code:15+" does not match any R/M codes."; "Try Again"; "Help")
			[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
			GOTO OBJECT:C206([Purchase_Orders_Items:12]Raw_Matl_Code:15)
	End case 
	
Else 
	Case of 
		: (Length:C16([Purchase_Orders_Items:12]Commodity_Key:26)>0)
			$match:=[Purchase_Orders_Items:12]Commodity_Key:26+"@"
			$recNo:=fPickList(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials:21]Commodity_Key:2; ->[Raw_Materials:21]Description:4; $match)
		: ([Purchase_Orders_Items:12]CommodityCode:16>0)
			$match:=String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+"@"
			$recNo:=fPickList(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials:21]Commodity_Key:2; ->[Raw_Materials:21]Description:4; $match)
		Else 
			$recNo:=fPickList(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials:21]Commodity_Key:2; ->[Raw_Materials:21]Description:4)
	End case 
	
	If ($recNo#-1)
		GOTO RECORD:C242([Raw_Materials:21]; $recNo)
		uConfirm("Make this order item like: "+[Raw_Materials:21]Raw_Matl_Code:1+"  -  "+[Raw_Materials:21]Description:4; "Yes"; "Try Again")
		If (ok=1)
			POI_RMcodeChanged
			
		Else 
			If (Count parameters:C259=1)  //• 6/12/97 cs 
				uClearSelection(->[Raw_Materials:21])
			End if 
		End if 
		
	Else 
		
	End if 
End if 
uClearSelection(->[Raw_Materials:21])  //• 6/12/97 cs 



iMode:=$temp

If ($temp=2)
	OBJECT SET ENABLED:C1123(bAcceptRec; True:C214)
	OBJECT SET ENABLED:C1123(bDelete; True:C214)
	OBJECT SET ENABLED:C1123(bDeleteRec; True:C214)
End if 

If ($temp=1)
	OBJECT SET ENABLED:C1123(bAcceptRec; True:C214)
End if 
fromZoom:=False:C215
//