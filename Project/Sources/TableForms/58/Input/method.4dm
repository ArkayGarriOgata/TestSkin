Case of 
		//upr 1206  9/6/94    
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Jobs:15])
		READ ONLY:C145([Job_Forms:42])
		READ ONLY:C145([Job_Forms_Master_Schedule:67])
		
		READ ONLY:C145([Job_Forms_Materials:55])
		READ ONLY:C145([Purchase_Orders_Items:12])
		READ ONLY:C145([Raw_Materials_Locations:25])
		
		
		If (Length:C16([Raw_Materials_Allocations:58]JobForm:3)=8)
			//QUERY([JobForm];[JobForm]JobFormID=[RM_Allocations]JobForm)
			$com:=Substring:C12([Raw_Materials_Allocations:58]commdityKey:13; 1; 2)
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=($com+"@"); *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]JobForm:1=[Raw_Materials_Allocations:58]JobForm:3)
		End if 
		
		If (Length:C16([Raw_Materials_Allocations:58]Raw_Matl_Code:1)>0)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=[Raw_Materials_Allocations:58]Raw_Matl_Code:1; *)
			QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Raw_Materials_Allocations:58]ModDate:8; ->[Raw_Materials_Allocations:58]ModWho:9; ->[Raw_Materials_Allocations:58]zCount:10)
End case 
//