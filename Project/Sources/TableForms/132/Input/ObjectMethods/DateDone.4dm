If ([Finished_Goods_SizeAndStyles:132]DateDone:6#!00-00-00!)
	If ([Finished_Goods_SizeAndStyles:132]SquareInches:48>0)
		[Finished_Goods_SizeAndStyles:132]DoneBy:10:=<>zResp
		SetObjectProperties(""; ->bSetDone; True:C214; "Un-Done")
		OBJECT SET ENABLED:C1123(*; "img@"; False:C215)
		OBJECT SET ENABLED:C1123(bSetDone; True:C214)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		uConfirm("Have you put "+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+".pdf into the EngDraw directory?"; "OK"; "Help")
	Else 
		uConfirm("Please enter the Square Inches to be used when estimating with this S&S."; "OK"; "Help")
		[Finished_Goods_SizeAndStyles:132]DateDone:6:=!00-00-00!
		GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]SquareInches:48)
	End if 
End if 