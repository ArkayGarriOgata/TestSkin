//OM: Hold() -> 
//@author mlb - 11/15/13

If ([Finished_Goods_SizeAndStyles:132]Hold:59)
	Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]DateSubmitted:5; -(Yellow:K11:2+(256*Black:K11:16)))
	[Finished_Goods_SizeAndStyles:132]CommentsFromStructDesign:58:="Hold set "+String:C10(4D_Current_date)+". Submit date was "+String:C10([Finished_Goods_SizeAndStyles:132]DateSubmitted:5)+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]CommentsFromStructDesign:58
	[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=Add to date:C393(Current date:C33; 0; 0; 1)  //move it out a little, keeping it in the queue
Else 
	Core_ObjectSetColor(->[Finished_Goods_SizeAndStyles:132]DateSubmitted:5; -(Black:K11:16+(256*White:K11:1)))
	[Finished_Goods_SizeAndStyles:132]CommentsFromStructDesign:58:="Hold released "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_SizeAndStyles:132]CommentsFromStructDesign:58
	[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=4D_Current_date
End if 