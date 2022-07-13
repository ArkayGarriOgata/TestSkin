//(s) [fin_Good]input2'classortype
//• 10/3/97 cs added code to cllean up correctly if user cancels below confirm
//• 4/16/98 cs insure that the correct classification is in hand
uConfirm("You will not be able to cancel changes if you continue. Continue anyway?"; "Continue"; "Stop")

If (ok=1)
	If ([Finished_Goods_Classifications:45]Class:1#Self:C308->)  //• 4/16/98 cs insure that the correct classification is in hand
		QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=Self:C308->)
	End if 
	
	If ([Finished_Goods:26]GL_Income_Code:22#[Finished_Goods_Classifications:45]GL_income_code:3)
		[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
	End if 
	[Finished_Goods:26]ModFlag:31:=True:C214
	SAVE RECORD:C53([Finished_Goods:26])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28)
	UNLOAD RECORD:C212([Customers_Order_Lines:41])
	afterFG  //Need [Finished_Goods] Record - for 4D Open
	sFGAction:="MOD"
Else   //• 10/3/97 cs 
	Self:C308->:=Old:C35(Self:C308->)  //• 10/3/97 cs 
	RELATE ONE:C42([Finished_Goods:26]ClassOrType:28)  //• 10/3/97 cs 
	GOTO OBJECT:C206(Self:C308->)  //• 10/3/97 cs 
End if   //ok
//EOS