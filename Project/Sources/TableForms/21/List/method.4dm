app_basic_list_form_method

Case of 
	: (Form event code:C388=On Load:K2:1)
		cb1:=0
		cb2:=0
		MESSAGES OFF:C175
		READ ONLY:C145([Raw_Materials_Locations:25])
		READ ONLY:C145([Purchase_Orders_Items:12])
		
		If (Read only state:C362([Raw_Materials:21]))
			OBJECT SET VISIBLE:C603(*; "Search@"; False:C215)
		Else 
			OBJECT SET VISIBLE:C603(*; "Search@"; True:C214)
		End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		$rm_code:=Uppercase:C13([Raw_Materials:21]Raw_Matl_Code:1)
		rOnHand:=0
		rOnOrder:=0
		
		If (cb1=1)
			Begin SQL
				SELECT sum(QtyOH) from Raw_Materials_Locations where upper(Raw_Matl_Code) = :$rm_code into :rOnHand
			End SQL
			
			//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]Raw_Matl_Code=[Raw_Materials]Raw_Matl_Code)
			//If (Records in selection([Raw_Materials_Locations])>0)
			//rOnHand:=Sum([Raw_Materials_Locations]QtyOH)
			//Else 
			//rOnHand:=0
			//End if 
		End if 
		//
		
		If (cb2=1)
			Begin SQL
				SELECT sum(Qty_Open) from Purchase_Orders_Items where upper(Raw_Matl_Code) = :$rm_code 
				and Canceled = False
				and Qty_Open > 0
				into :rOnOrder
			End SQL
			
			//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]Raw_Matl_Code=[Raw_Materials]Raw_Matl_Code;*)
			//QUERY([Purchase_Orders_Items]; & ;[Purchase_Orders_Items]Canceled=False;*)
			//QUERY([Purchase_Orders_Items]; & ;[Purchase_Orders_Items]Qty_Open>0)
			//If (Records in selection([Purchase_Orders_Items])>0)
			//rOnOrder:=Sum([Purchase_Orders_Items]Qty_Open)
			//Else 
			//rOnOrder:=0
			//End if 
		End if 
		//
End case 
