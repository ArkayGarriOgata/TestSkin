If ([Finished_Goods_Specifications:98]UPC_encoded:76#[Finished_Goods:26]UPC:37)
	Core_ObjectSetColor(->[Finished_Goods_Specifications:98]UPC_encoded:76; -(Red:K11:4))
	[Finished_Goods_Specifications:98]CommentsFromQA:53:=" UPC set to "+[Finished_Goods_Specifications:98]UPC_encoded:76+" from "+[Finished_Goods:26]UPC:37+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
End if 

$validatedUPC:=BarCode_UPC_A_CheckDigit([Finished_Goods_Specifications:98]UPC_encoded:76)
If ($validatedUPC#[Finished_Goods_Specifications:98]UPC_encoded:76)
	uConfirm("Double check the UPC code, should it be "+$validatedUPC+" ?"; "Yes"; "No")
	If (ok=1)
		[Finished_Goods_Specifications:98]UPC_encoded:76:=$validatedUPC
	End if 
End if 