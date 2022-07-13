//(s) Commodity Key
If ([Raw_Materials_Groups:22]Commodity_Key:3#Self:C308->)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=Self:C308->)
	
	If (Records in selection:C76([Raw_Materials_Groups:22])=0)  //no group - invalid commkey
		ALERT:C41("The entered Commodity Key is invalid, Please try again.")
		Self:C308->:=Old:C35(Self:C308->)
	Else   //valid commkey
		
		If ([Raw_Materials_Transactions:23]Raw_Matl_Code:1#"")  //if there is a raw matl entry
			If ([Raw_Materials:21]Raw_Matl_Code:1#[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
			End if 
			//verify that the entered com key corresponds to RM code entry      
			If ([Raw_Materials:21]Commodity_Key:2#[Raw_Materials_Transactions:23]Commodity_Key:22)
				ALERT:C41("The entered Commodity Key is invalid for the entered Raw Material"+", Please try again.")
				Self:C308->:=Old:C35(Self:C308->)
			Else 
				[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2))  //assign com code
			End if 
		End if 
	End if 
End if 
//