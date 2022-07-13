If ([Finished_Goods_SizeAndStyles:132]DateWanted:42<4D_Current_date)
	[Finished_Goods_SizeAndStyles:132]DateWanted:42:=!00-00-00!
	uConfirm("This ain't no time machine, pick a date in the future."; "Bad English"; "Is not a")
End if 