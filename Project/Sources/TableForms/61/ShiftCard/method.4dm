
Case of 
	: (Form event code:C388=On Load:K2:1)
		dDateBegin:=Current date:C33
		dDateEnd:=Current date:C33
		cost_center:=""
		cb1:=1
		cb2:=1
		cb3:=1
		rb0:=0
		rb1:=1
		rb2:=0
		rb3:=0
		rb4:=0
		sOperator:=""  //lead person's initials// Modified by: Mel Bohince (9/13/15) v14 fix
		OBJECT SET ENABLED:C1123(*; "Bless"; False:C215)  //CREATE EMPTY SET("$ListboxSet0")
		
End case 
