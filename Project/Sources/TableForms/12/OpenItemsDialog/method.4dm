//FM: OpenItemsDialog() -> 
//@author mlb - 4/23/03  08:59

Case of 
	: (Form event code:C388=On Load:K2:1)
		cb1:=1
		b1:=1
		rb1:=1
		cb2:=0
		dDateBegin:=Add to date:C393(4D_Current_date; 0; -1; 0)
		dDateEnd:=Add to date:C393(4D_Current_date; 0; 2; 0)
End case 