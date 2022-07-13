If (Size of array:C274(aBrand)>0)
	If (Find in array:C230(aBrand; aBrand{0})>-1)
		[Finished_Goods:26]Line_Brand:15:=aBrand{0}
		[Finished_Goods:26]ModFlag:31:=True:C214
	Else 
		BEEP:C151
		[Finished_Goods:26]Line_Brand:15:=Old:C35([Finished_Goods:26]Line_Brand:15)
		aBrand{0}:=[Finished_Goods:26]Line_Brand:15
	End if 
	
Else 
	BEEP:C151
	[Finished_Goods:26]Line_Brand:15:=Old:C35([Finished_Goods:26]Line_Brand:15)
	aBrand{0}:=[Finished_Goods:26]Line_Brand:15
End if 

//EOS