//Searchpicker sample code

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Bin A# Job Cust")
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Length:C16(vSearch)=0)
			ALL RECORDS:C47([Job_DieBoard_Inv:168])
		Else 
			$criterian:="@"+vSearch+"@"
			QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=$criterian; *)
			QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]Customer:2=$criterian; *)
			QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]CatelogID:10=$criterian; *)
			QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]DieNumber:3=$criterian)
		End if 
		ORDER BY:C49([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]CatelogID:10; >)
		
End case 
