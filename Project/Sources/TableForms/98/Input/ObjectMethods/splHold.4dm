// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 3/15/02  10:24
// ----------------------------------------------------
// Object Method: [Finished_Goods_Specifications].Input.splHold
// ----------------------------------------------------

If ([Finished_Goods_Specifications:98]Hold:62)
	Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; -(Yellow:K11:2+(256*Black:K11:16)))
	[Finished_Goods_Specifications:98]CommentsFromImaging:20:="Hold set "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromImaging:20
Else 
	Core_ObjectSetColor(->[Finished_Goods_Specifications:98]DateSubmitted:5; -(Black:K11:16+(256*White:K11:1)))
	[Finished_Goods_Specifications:98]CommentsFromImaging:20:="Hold released "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromImaging:20
	[Finished_Goods_Specifications:98]DateSubmitted:5:=4D_Current_date
	SetObjectProperties("splHold"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/16/13)
End if 