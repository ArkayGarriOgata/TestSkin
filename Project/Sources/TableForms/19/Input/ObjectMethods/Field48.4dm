//Script: OutLineNumber()  120997  MLB
//get related attributes
If (Length:C16(Old:C35([Estimates_Carton_Specs:19]OutLineNumber:15))>0)  //• mlb - 4/3/03  14:11
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numFG)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=([Estimates_Carton_Specs:19]CustID:6+":"+[Estimates_Carton_Specs:19]ProductCode:5))
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numFG>0)
		BEEP:C151
		ALERT:C41("You must use a Prep Service request to change an "+"Outline's file number in the Finished Good record."; "Just Quoting")
		//[CARTON_SPEC]OutLineNumber:=Old([CARTON_SPEC]OutLineNumber)
	End if 
End if 

QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Estimates_Carton_Specs:19]OutLineNumber:15)
If (Records in selection:C76([Finished_Goods_PackingSpecs:91])=1)
	If ([Estimates_Carton_Specs:19]PackingQty:61=0)
		[Estimates_Carton_Specs:19]PackingQty:61:=[Finished_Goods_PackingSpecs:91]CaseCount:2
	End if 
	If ([Estimates_Carton_Specs:19]GlueType:41="")
		[Estimates_Carton_Specs:19]GlueType:41:=[Finished_Goods_PackingSpecs:91]GlueType:9
	End if 
	If ([Estimates_Carton_Specs:19]SpecialPacking:50="")
		[Estimates_Carton_Specs:19]SpecialPacking:50:="Rows: "+String:C10([Finished_Goods_PackingSpecs:91]Rows:3)+" Height: "+String:C10([Finished_Goods_PackingSpecs:91]Layers:4)+" RowCount: "+String:C10([Finished_Goods_PackingSpecs:91]RowCount:5)+" Case Size: "+[Finished_Goods_PackingSpecs:91]CaseSizeLWH:7+" Gluer: "+[Finished_Goods_PackingSpecs:91]GluerCCNumber:6
	End if 
End if 
REDUCE SELECTION:C351([Finished_Goods_PackingSpecs:91]; 0)
//
QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=[Estimates_Carton_Specs:19]OutLineNumber:15)
If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=1)
	[Estimates_Carton_Specs:19]Style:4:=[Finished_Goods_SizeAndStyles:132]Style:14
	[Estimates_Carton_Specs:19]SquareInches:16:=[Finished_Goods_SizeAndStyles:132]SquareInches:48
	[Estimates_Carton_Specs:19]SamplesSupplied:10:=[Finished_Goods_SizeAndStyles:132]Samples:28
	[Estimates_Carton_Specs:19]StripHoles:46:=[Finished_Goods_SizeAndStyles:132]Windowed:23
	[Estimates_Carton_Specs:19]Height:19:=[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
	[Estimates_Carton_Specs:19]Width:17:=[Finished_Goods_SizeAndStyles:132]Dim_A:17
	[Estimates_Carton_Specs:19]Depth:18:=[Finished_Goods_SizeAndStyles:132]Dim_B:18
End if 
REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)