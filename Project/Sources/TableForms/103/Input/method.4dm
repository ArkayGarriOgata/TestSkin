//FM: Input() -> 
//@author mlb - 5/22/01  12:55

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Prep_Charges:103]))
			[Prep_Charges:103]ControlNumber:1:=[Finished_Goods_Specifications:98]ControlNumber:2
		End if 
End case 
//