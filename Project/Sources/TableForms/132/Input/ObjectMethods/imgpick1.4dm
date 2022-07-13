If (Length:C16([Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53)=0)
	BEEP:C151
	[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46:=!00-00-00!
	GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53)
Else 
	If ([Finished_Goods_SizeAndStyles:132]DateGlueApproved:46#!00-00-00!)
		Cal_getDate(->[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46; Month of:C24([Finished_Goods_SizeAndStyles:132]DateGlueApproved:46); Year of:C25([Finished_Goods_SizeAndStyles:132]DateGlueApproved:46))
	Else 
		Cal_getDate(->[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46)
	End if 
End if 
//