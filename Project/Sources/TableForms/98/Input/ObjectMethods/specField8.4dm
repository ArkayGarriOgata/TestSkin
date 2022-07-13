[Finished_Goods_Specifications:98]OutLine_Num:65:=Replace string:C233([Finished_Goods_Specifications:98]OutLine_Num:65; " "; "")
QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=[Finished_Goods_Specifications:98]OutLine_Num:65)
If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=1)
	[Finished_Goods:26]Width:7:=[Finished_Goods_SizeAndStyles:132]Dim_A:17
	[Finished_Goods:26]Depth:8:=[Finished_Goods_SizeAndStyles:132]Dim_B:18
	[Finished_Goods:26]Height:9:=[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
	[Finished_Goods_Specifications:98]StockCaliper:23:=[Finished_Goods_SizeAndStyles:132]StockCaliper:21
	[Finished_Goods_Specifications:98]StockType:21:=[Finished_Goods_SizeAndStyles:132]StockType:20
	[Finished_Goods:26]Style:32:=[Finished_Goods_SizeAndStyles:132]Style:14
	[Finished_Goods:26]HaveSnS:54:=True:C214
	[Finished_Goods:26]SquareInch:6:=[Finished_Goods_SizeAndStyles:132]SquareInches:48
	
	[Finished_Goods_Specifications:98]CommentsFromQA:53:=" A# set to "+[Finished_Goods_Specifications:98]OutLine_Num:65+" from "+[Finished_Goods:26]OutLine_Num:4+" "+[Finished_Goods_Specifications:98]CommentsFromQA:53
	[Finished_Goods_Specifications:98]Size_n_style:79:=[Finished_Goods_SizeAndStyles:132]DateApproved:8
	If ([Finished_Goods_Specifications:98]Size_n_style:79#!00-00-00!)
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="Yes"
		calVar1:=2
	Else 
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="No"
		calVar1:=1
	End if 
	
Else 
	zwStatusMsg("WARNING"; "[SizeAndStyle]FileOutlineNum="+[Finished_Goods_Specifications:98]OutLine_Num:65+" was not found.")
	[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
	calVar1:=0
	BEEP:C151
End if 