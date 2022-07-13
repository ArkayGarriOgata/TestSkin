//Searchpicker sample code

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		C_BOOLEAN:C305(useFindWidget)
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Prod Line C# A# Custid")
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: (Not:C34(useFindWidget))
				useFindWidget:=True:C214  //toggle, coming from legacy [zz_control];"Select_dio"
				
			: (Length:C16(vSearch)>0)
				$criterian:="@"+vSearch+"@"
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$criterian; *)
				QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods:26]Line_Brand:15=$criterian; *)
				QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods:26]ControlNumber:61=$criterian; *)
				QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods:26]OutLine_Num:4=$criterian; *)
				QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods:26]CustID:2=$criterian)
				
			Else 
				ALL RECORDS:C47([Finished_Goods:26])
		End case 
		
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
		
End case 
