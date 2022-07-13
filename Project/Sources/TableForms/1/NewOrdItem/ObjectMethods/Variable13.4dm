//•052599  mlb make sure that only new or spl billing items are entered
$numfound:=qryFinishedGood("#CPN"; sDesc)
If ($numfound>0)  //make sure its a spl billing type
	If ([Finished_Goods:26]SpecialBilling:23)
		r2:=Num:C11([Finished_Goods:26]ClassOrType:28)
		sDesc:=[Finished_Goods:26]ProductCode:1
		
	Else   //its a finished good
		BEEP:C151
		ALERT:C41(sDesc+" is the CPN of a existing Finished Good that is not flagged as Spl Billing"+Char:C90(13)+"Use 'Finished Good' button to add this item.")
		//ALERT("Must use 'Finished Good' button to add a Finished Good.")
		sDesc:=""
	End if 
End if 
//