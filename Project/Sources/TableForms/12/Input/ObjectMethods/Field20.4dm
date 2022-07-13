//(S) [PO_ITEMS]RawMatlCode

POI_ClearInputForm([Purchase_Orders_Items:12]Raw_Matl_Code:15)

If (Length:C16([Purchase_Orders_Items:12]Raw_Matl_Code:15)>0)
	//READ WRITE([Raw_Materials])
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
	Case of 
		: (Records in selection:C76([Raw_Materials:21])=1)
			If (Position:C15([Raw_Materials:21]Status:25; " Obsolete PhaseOut ")>0)
				uConfirm("WARNING: "+[Raw_Materials:21]Raw_Matl_Code:1+" has the status of "+[Raw_Materials:21]Status:25; "Call Dan"; "Help")
			End if 
			//uConfirm ("Make this order item like: "+[Raw_Materials]Raw_Matl_Code;"Yes";"Try Again")
			//If (ok=1)
			POI_RMcodeChanged
			//End if 
			
		: (Records in selection:C76([Raw_Materials:21])=0)
			$msg:=[Purchase_Orders_Items:12]Raw_Matl_Code:15+" does not exist in the R/M table."
			uConfirm($msg; "New R/M"; "Try Again")
			If (ok=1)
				iComm:=0  //• 4/11/97 cs 
				tSubGroup:=""  //• 4/11/97 cs 
				fNewRM:=True:C214
				//•6/19/97 cs on new RMs the company ID is not being set
			Else   //start over
				[Purchase_Orders_Items:12]Raw_Matl_Code:15:=Old:C35([Purchase_Orders_Items:12]Raw_Matl_Code:15)
				GOTO OBJECT:C206([Purchase_Orders_Items:12]Raw_Matl_Code:15)
			End if 
			
		Else   //>1
			$msg:=[Purchase_Orders_Items:12]Raw_Matl_Code:15+" matches more than 1 item in the R/M table. Use the 'Pick R/M' button."
			uConfirm($msg; "OK"; "Help")
			[Purchase_Orders_Items:12]Raw_Matl_Code:15:=Old:C35([Purchase_Orders_Items:12]Raw_Matl_Code:15)
			GOTO OBJECT:C206([Purchase_Orders_Items:12]Raw_Matl_Code:15)
	End case 
	
End if 