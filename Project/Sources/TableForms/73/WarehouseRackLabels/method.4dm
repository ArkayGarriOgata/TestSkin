OBJECT SET VISIBLE:C603(*; "arrowdown1"; False:C215)
OBJECT SET VISIBLE:C603(*; "arrowup1"; False:C215)
OBJECT SET VISIBLE:C603(*; "arrowdown2"; False:C215)
OBJECT SET VISIBLE:C603(*; "arrowup2"; False:C215)

If (Position:C15("-"; SSCC_HumanReadable1)>0) & (Position:C15("--"; SSCC_HumanReadable1)=0)  //looks like a rack location, and not a little bin
	If (Substring:C12(SSCC_HumanReadable1; (Length:C16(SSCC_HumanReadable1)); 1)="1")
		OBJECT SET VISIBLE:C603(*; "arrowdown1"; True:C214)
		OBJECT SET VISIBLE:C603(*; "arrowup1"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "arrowdown1"; False:C215)
		OBJECT SET VISIBLE:C603(*; "arrowup1"; True:C214)
	End if 
	
	If (Substring:C12(SSCC_HumanReadable2; (Length:C16(SSCC_HumanReadable2)); 1)="1")
		OBJECT SET VISIBLE:C603(*; "arrowdown2"; True:C214)
		OBJECT SET VISIBLE:C603(*; "arrowup2"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "arrowdown2"; False:C215)
		OBJECT SET VISIBLE:C603(*; "arrowup2"; True:C214)
	End if 
End if 
