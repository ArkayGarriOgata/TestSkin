//(s) custid [finished goods]input2

//• 2/17/97 cs upr 1848

If (Length:C16([Finished_Goods:26]CustID:2)=5)
	[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
	If ([Finished_Goods:26]CustID:2#"")
		RELATE ONE:C42([Finished_Goods:26]CustID:2)
		uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
	End if 
	[Finished_Goods:26]ModFlag:31:=True:C214
	FgArtDefaults  //• 2/17/97 upr 1848 set art defaults according to customer
	
	
Else 
	BEEP:C151
	ALERT:C41("You didn't enter a 5 digit Customer ID.")
	[Finished_Goods:26]CustID:2:=Old:C35([Finished_Goods:26]CustID:2)
End if 
//EOS