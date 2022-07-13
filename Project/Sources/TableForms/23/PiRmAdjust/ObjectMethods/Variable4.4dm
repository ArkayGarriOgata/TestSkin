//(s) sString [rm_bin] PiRmAdjSumry.v
Self:C308->:=ChrgCodeToLoc([Raw_Materials_Transactions:23]CompanyID:20)

If (vDoc#?00:00:00?)
	SEND PACKET:C103(vDoc; "Division "+Self:C308->+Char:C90(13))
End if 