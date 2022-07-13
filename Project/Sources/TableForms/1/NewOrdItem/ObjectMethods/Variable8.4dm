//(s) rInclOther 
r2:=25
sDesc:="Preparatory"

If (False:C215)
	ARRAY TEXT:C222(aOrdType; 1)
	ARRAY REAL:C219(aOrdQty; 1)
	ARRAY LONGINT:C221(aOrdNum; 1)
	ARRAY REAL:C219(aOrdCost; 1)
	C_BOOLEAN:C305($End)
	C_LONGINT:C283(lReceipt)
	
	$End:=False:C215
	lReceipt:=1
	uDialog("SpecialBilling"; 300; 170)
	If (OK=1)
		aOrdCost{1}:=Num:C11(sPoLocation)  //these fields reused from another dialog
		aOrdNum{1}:=lReceipt
		aOrdQty{1}:=Num:C11(sChargeCode)
		aOrdType{1}:=sDesc
		lReceipt:=lReceipt+1
	End if 
	If (Size of array:C274(aOrdNum)=0)
		Self:C308->:=0
		rInclPrep:=1
	End if 
End if   //false

//eos