If (Form event code:C388=On Load:K2:1)
	tText:="UPDATE Customers_Order_Lines "+Char:C90(13)
	tText:=tText+"   SET ProjectNumber = '00000', "+Char:C90(13)
	tText:=tText+"          modDate = '2010-10-26', "+Char:C90(13)
	tText:=tText+"          modWho = 'SQL' "+Char:C90(13)
	tText:=tText+"   WHERE ProductCode = '30256765'"+Char:C90(13)
	t1:=tText  //for last statement
End if 