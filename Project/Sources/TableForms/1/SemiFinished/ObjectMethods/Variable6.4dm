QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4)  //to get type
If (Records in selection:C76([Raw_Materials_Groups:22])>=1)
	tText:=[Raw_Materials_Groups:22]ChargeCode:11
Else 
	tText:="0-0000-0000"
End if 