//(s) sRmCode [control]directbillink
If (Self:C308->#"")
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=Self:C308->; *)
	QUERY:C277([Raw_Materials:21];  & ; [Raw_Materials:21]CommodityCode:26=2)
	
	Case of 
		: (Records in selection:C76([Raw_Materials:21])=0)
			Self:C308->:=""
			ALERT:C41("The entered material code is not a Valid Ink.")
			
		: (Records in selection:C76([Raw_Materials:21])>1)
			Self:C308->:=""
			ALERT:C41("The entered material code is not a Unique Ink.")
	End case 
End if 
//