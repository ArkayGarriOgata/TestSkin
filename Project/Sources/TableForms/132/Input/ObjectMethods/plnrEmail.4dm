// Method: [Finished_Goods_SizeAndStyles].Input.plnrEmailFileAddress

If (email_validate_address([Finished_Goods_SizeAndStyles:132]EmailAddress:41))
	[Finished_Goods_SizeAndStyles:132]EmailFile:34:=True:C214
	
Else 
	BEEP:C151
	uConfirm("Double check that email address."; "OK"; "Help")
	[Finished_Goods_SizeAndStyles:132]EmailAddress:41:=""
	GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]EmailAddress:41)
End if 
