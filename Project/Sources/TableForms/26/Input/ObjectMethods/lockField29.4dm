
$validatedUPC:=BarCode_UPC_A_CheckDigit([Finished_Goods:26]UPC:37)
If ($validatedUPC#[Finished_Goods:26]UPC:37)
	uConfirm("Double check the UPC code, should it be "+$validatedUPC+" ?"; "Yes"; "No")
	If (ok=1)
		[Finished_Goods:26]UPC:37:=$validatedUPC
	End if 
End if 