//(s) bAskMe
//upr 1213
If (app_LoadIncludedSelection("init"; ->[Finished_Goods:26]ProductCode:1)>0)
	<>AskMeFG:=[Finished_Goods:26]ProductCode:1
	<>AskMeCust:=""  //[CustomerOrder]CustID
	displayAskMe("New")
	
	app_LoadIncludedSelection("clear"; ->[Finished_Goods:26]ProductCode:1)
End if 


//