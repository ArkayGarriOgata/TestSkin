//%attributes = {"publishedWeb":true}
//PM:  x_Print_RM_Labels  3/26/01  mlb

$count:=1
QUERY:C277([Raw_Materials_Locations:25])
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Location:2; >; [Raw_Materials_Locations:25]Commodity_Key:12; >; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >; [Raw_Materials_Locations:25]POItemKey:19; >)
While (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
	$input:=[Raw_Materials_Locations:25]POItemKey:19
	If (Length:C16($input)=9)
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$input)
		$numPOI:=Records in selection:C76([Purchase_Orders_Items:12])
		
		If ($numPOI=1)
			$rmCode:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
			$desc:=Substring:C12([Purchase_Orders_Items:12]RM_Description:7; 1; 40)  //• 5/22/98 cs changed from [PO_ITEMS]RM_Description  
			$uom:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
			$dept:=[Purchase_Orders_Items:12]CompanyID:45+" - "+[Purchase_Orders_Items:12]DepartmentID:46
			
			
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
			$vendor:=[Vendors:7]Name:2
			REDUCE SELECTION:C351([Vendors:7]; 0)
			RM_PrintLabel  //set up the printer  
			
			For ($i; 1; $count)
				RM_PrintLabel($input; $rmCode; $desc; $vendor; $uom; $dept)
			End for 
			
			RM_PrintLabel("11")  //close the channel      
		End if   //poi found
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	End if   //length    
	
	
	NEXT RECORD:C51([Raw_Materials_Locations:25])
End while 
REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
//