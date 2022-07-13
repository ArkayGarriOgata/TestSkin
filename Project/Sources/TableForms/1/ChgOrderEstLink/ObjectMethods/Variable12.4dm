//(s) rInclOther
ARRAY TEXT:C222(aOrdType; 0)
ARRAY REAL:C219(aOrdQty; 0)
ARRAY LONGINT:C221(aOrdNum; 0)
ARRAY REAL:C219(aOrdCost; 0)
C_BOOLEAN:C305($End)
C_LONGINT:C283(lReceipt)

$End:=False:C215
lReceipt:=1

Repeat 
	uDialog("SpecialBilling"; 300; 170)
	If (OK=1)
		INSERT IN ARRAY:C227(aOrdCost; 1)
		INSERT IN ARRAY:C227(aOrdNum; 1)
		INSERT IN ARRAY:C227(aOrdQty; 1)
		INSERT IN ARRAY:C227(aOrdType; 1)
		aOrdCost{1}:=Num:C11(sPoLocation)  //these fields reused from another dialog
		aOrdNum{1}:=lReceipt
		aOrdQty{1}:=Num:C11(sChargeCode)
		aOrdType{1}:=sDesc
		lReceipt:=lReceipt+1
	End if 
Until (OK=0)
If (Size of array:C274(aOrdNum)=0)
	Self:C308->:=0
End if 
//eos