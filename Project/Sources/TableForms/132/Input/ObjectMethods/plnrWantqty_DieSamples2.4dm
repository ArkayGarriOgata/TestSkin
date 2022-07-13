If (Length:C16([Finished_Goods_SizeAndStyles:132]EmailAddress:41)>=6) & (Position:C15("."; [Finished_Goods_SizeAndStyles:132]EmailAddress:41)>3) & (Position:C15(Char:C90(At sign:K15:46); [Finished_Goods_SizeAndStyles:132]EmailAddress:41)>1)
	[Finished_Goods_SizeAndStyles:132]EmailFile:34:=True:C214
Else 
	BEEP:C151
	uConfirm("Double check that email address."; "OK"; "Help")
	GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]EmailAddress:41)
End if 