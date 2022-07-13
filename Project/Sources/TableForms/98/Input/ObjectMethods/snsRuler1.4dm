Case of 
	: (calVar1=0)
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
	: (calVar1=1)
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="No"
	: (calVar1=2)
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:="Yes"
		[Finished_Goods:26]HaveSnS:54:=True:C214
		If ([Finished_Goods:26]DateSnSReceived:57=!00-00-00!)
			[Finished_Goods:26]DateSnSReceived:57:=4D_Current_date
		End if 
		
	Else 
		[Finished_Goods_Specifications:98]SizeAndStyleApproved:12:=""
End case 