Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If (Self:C308->>0)
			$Loc:=Find in array:C230(aCommCode; String:C10(Self:C308->; "00")+"@")
			If ($Loc>-1)
				[y_accounting_dept_commodities:89]CommDesc:3:=Substring:C12(aCommCode{$loc}; 6)
			Else 
				BEEP:C151
				ALERT:C41(String:C10(Self:C308->)+" is not currently available.")
				[y_accounting_dept_commodities:89]CommodityCode:1:=0
			End if 
			
		Else 
			[y_accounting_dept_commodities:89]CommDesc:3:=""
		End if 
End case 