//%attributes = {}
// Method: rfc_additionalRequest () -> 
// ----------------------------------------------------
// by: mel: 03/19/08
// ----------------------------------------------------

C_TEXT:C284($txt)
C_TEXT:C284($1)

If (Count parameters:C259=1)
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$1)
End if 

If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
	$txt:=""
	If ([Finished_Goods_SizeAndStyles:132]qty_samples:35>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[2]]="1")
		$txt:=$txt+"Sample="+String:C10([Finished_Goods_SizeAndStyles:132]qty_samples:35)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]qty_DieOnDisk:36>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[3]]="1")
		$txt:=$txt+"DieOnDisk="+String:C10([Finished_Goods_SizeAndStyles:132]qty_DieOnDisk:36)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]qty_EngDrawing:37>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[4]]="1")
		$txt:=$txt+"EgrDwg="+String:C10([Finished_Goods_SizeAndStyles:132]qty_EngDrawing:37)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]qty_ArtBoard:38>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[5]]="1")
		$txt:=$txt+"ArtBoard="+String:C10([Finished_Goods_SizeAndStyles:132]qty_ArtBoard:38)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]qty_ConvertDisk:39>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[6]]="1")
		$txt:=$txt+"ConvertDisk="+String:C10([Finished_Goods_SizeAndStyles:132]qty_ConvertDisk:39)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]qty_DieSamples:40>0) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[7]]="1")
		$txt:=$txt+"DieSample="+String:C10([Finished_Goods_SizeAndStyles:132]qty_DieSamples:40)+", "
	End if 
	If ([Finished_Goods_SizeAndStyles:132]EmailFile:34) & ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[8]]="1")
		$txt:=$txt+"EmailFile="+[Finished_Goods_SizeAndStyles:132]EmailAddress:41+" "
	End if 
	
	If (Position:C15("0"; [Finished_Goods_SizeAndStyles:132]TasksCompleted:56)>0)
		$txt:=$txt+" Tasks left uncompleted "+[Finished_Goods_SizeAndStyles:132]TasksCompleted:56
	End if 
	[Finished_Goods_SnS_Additions:150]Requests:3:=$txt
	
	[Finished_Goods_SnS_Additions:150]DateWanted:4:=[Finished_Goods_SizeAndStyles:132]DateWanted:42
	[Finished_Goods_SnS_Additions:150]DateSubmitted:5:=[Finished_Goods_SizeAndStyles:132]DateSubmitted:5
	[Finished_Goods_SnS_Additions:150]DateDone:6:=[Finished_Goods_SizeAndStyles:132]DateDone:6
	
Else 
	If (Count parameters:C259=1)
		BEEP:C151
		uConfirm([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+" was not found."; "OK"; "Help")
	End if 
End if 