//Searchpicker sample code

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		C_BOOLEAN:C305(useFindWidget)
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "RM VPN Desc Comm Dept")
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: (Not:C34(useFindWidget))
				useFindWidget:=True:C214  //toggle, coming from legacy [zz_control];"Select_dio"
				
			: (Length:C16(vSearch)>0)
				$criterian:="@"+vSearch+"@"
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Commodity_Key:2=$criterian; *)
				QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Raw_Matl_Code:1=$criterian; *)
				QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Description:4=$criterian; *)
				QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]DepartmentID:28=$criterian; *)
				QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]VendorPartNum:3=$criterian)
				
			Else 
				ALL RECORDS:C47([Raw_Materials:21])
		End case 
		
		ORDER BY:C49([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1; >)
		
End case 
