//(s) [fin_Good]input2'classortype

//• 10/3/97 cs added code to cllean up correctly if user cancels below confirm

//• 4/16/98 cs insure that the correct classification is in hand

// • mel (2/10/04, 15:49:38) put this in the validate phase


//uConfirm ("You will not be able to cancel changes if you continue. Continue anyway?";"Continue";"Stop")

//

//If (ok=1)

If ([Finished_Goods_Classifications:45]Class:1#[Finished_Goods:26]ClassOrType:28)  //• 4/16/98 cs insure that the correct classification is in hand
	
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods:26]ClassOrType:28)
	[Finished_Goods:26]ModFlag:31:=True:C214
End if 

If ([Finished_Goods:26]GL_Income_Code:22#[Finished_Goods_Classifications:45]GL_income_code:3)
	[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
	[Finished_Goods:26]ModFlag:31:=True:C214
End if 

//SAVE RECORD([Finished_Goods])

//QUERY([OrderLines];[OrderLines]ProductCode=[Finished_Goods]ProductCode;*)

//QUERY([OrderLines]; & ;[OrderLines]CustID=[Finished_Goods]CustID)

//APPLY TO SELECTION([OrderLines];[OrderLines]Classification:=[Finished_Goods]ClassOrType)

//UNLOAD RECORD([OrderLines])

//afterFG   `Need [Finished_Goods] Record - for 4D Open

//sFGAction:="MOD"

//Else   `• 10/3/97 cs 

//Self->:=Old(Self->)  `• 10/3/97 cs 

//RELATE ONE([Finished_Goods]ClassOrType)  `• 10/3/97 cs 

//GOTO AREA(Self->)  `• 10/3/97 cs 

//End if   `ok

//EOS