//(s) sString [rm_bin] PiRmcount sheet
Self:C308->:=ChrgCodeToLoc([Raw_Materials_Locations:25]CompanyID:27)

If ([Raw_Materials_Groups:22]Commodity_Key:3#[Raw_Materials_Locations:25]Commodity_Key:12)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Raw_Materials_Locations:25]Commodity_Key:12)
End if 

If (vDoc#?00:00:00?)
	SEND PACKET:C103(vDoc; "Division "+Self:C308->+Char:C90(13))
End if 