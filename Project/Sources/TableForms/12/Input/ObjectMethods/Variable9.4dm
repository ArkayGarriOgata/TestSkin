//bCancelRec
fPOIMaint:=False:C215
fCancel:=True:C214
If (Is new record:C668([Purchase_Orders_Items:12]))  //reset the item counter
	sItemNo:=String:C10(Num:C11(sItemNo)-1; "00")
End if 

//EOS