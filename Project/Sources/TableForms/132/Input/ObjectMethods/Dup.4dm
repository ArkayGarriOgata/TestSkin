uConfirm("Make a duplicate of "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+"?"; "Duplicate"; "Cancel")
If (ok=1)
	SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
	//rfc_duplicate ([Finished_Goods_SizeAndStyles]FileOutlineNum)
	$ctrlNumOld:=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1
	
	DUPLICATE RECORD:C225([Finished_Goods_SizeAndStyles:132])
	[Finished_Goods_SizeAndStyles:132]pk_id:61:=Generate UUID:C1066
	$fileNum:=rfc_newOutlineNumber("rfc")
	[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1:=$fileNum
	[Finished_Goods_SizeAndStyles:132]DateCreated:3:=4D_Current_date
	rfc_resetWorkflow
	[Finished_Goods_SizeAndStyles:132]AdditionalRequest:54:=0
	[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27:="This is a copy of file#"+$ctrlNumOld+Char:C90(13)+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]SpecialInstructions:27
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Finished_Goods_SizeAndStyles]z_SYNC_ID;->[Finished_Goods_SizeAndStyles]z_SYNC_DATA)
	SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
	
	rfc_OnLoadForm
	
End if 