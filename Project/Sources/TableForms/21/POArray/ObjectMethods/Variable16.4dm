If (aPOItem>1)
	aPOItem:=aPOItem-1
	aPOQty:=aPOQty-1
	aQtyAvl:=aQtyAvl-1
	aPOPartNo:=aPOPartNo-1
	aPOPrice:=aPOPrice-1
	aUM1:=aUM1-1
	aUM2:=aUM2-1
	arNum1:=arNum1-1
	arDenom1:=arDenom1-1
	arNum2:=arNum2-1
	arDenom2:=arDenom2-1
	aComm:=aComm-1
	axPoRemark:=axPoRemark-1
	gSelectPOItem  //2/9/95
Else 
	BEEP:C151
End if 
//