//OM: Button1() -> 
//@author mlb - 10/30/01  15:50
WMS_PrintCaseLabels(6; <>JOBIT)


//◊JOBIT:=[JobMakesItem]Jobit
//If (Length(◊JOBIT)=11)
//$i:=qryFinishedGood ([JobMakesItem]CustId;[JobMakesItem]ProductCode)
//If ($i>0)
//$style:=Num(Request(◊JOBIT+" Labels, Nº Up [1, 6, 12]?";"6";"Print";"Cancel"))
//If (ok=1) & ($style>0)
//WMS_PrintCaseLabels ($style;[JobMakesItem]Jobit)
//End if 
//Else 
//BEEP
//ALERT("Click on an item first.")
//End if 
//
//Else 
//BEEP
//ALERT("Click on an item first.")
//End if 