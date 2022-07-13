//(s) bfixFg [finished goods]input2

//•2/17/97 upr 1848

$custId:=Request:C163("What is the correct CustID"; "00000")
If (ok=1)
	If (Length:C16($custId)=5)
		[Finished_Goods:26]CustID:2:=$custId
		RELATE ONE:C42([Finished_Goods:26]CustID:2)
		If ([Customers:16]ID:1#"")
			[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
			uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
			FgArtDefaults  //• 2/17/97 upr 1848 set art defaults according to customer
			
		End if 
		[Finished_Goods:26]ModFlag:31:=True:C214
		
	Else 
		BEEP:C151
		ALERT:C41("You didn't enter a 5 digit Customer ID.")
	End if 
	
End if 
//