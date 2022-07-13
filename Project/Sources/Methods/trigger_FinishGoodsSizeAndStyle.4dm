//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/19/08, 11:52:16
// ----------------------------------------------------
// Method: trigger_FinishGoodsSizeAndStyle
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Deleting Record Event:K3:3)
		QUERY:C277([Finished_Goods_SnS_Additions:150]; [Finished_Goods_SnS_Additions:150]FileOutlineNum:1=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
		DELETE SELECTION:C66([Finished_Goods_SnS_Additions:150])
		
	Else 
		[Finished_Goods_SizeAndStyles:132]Dimensions_text:62:=""
		[Finished_Goods_SizeAndStyles:132]Dimensions_text:62:=[Finished_Goods_SizeAndStyles:132]Dim_A:17+Char:C90(Carriage return:K15:38)+[Finished_Goods_SizeAndStyles:132]Dim_B:18+Char:C90(Carriage return:K15:38)+[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
End case 