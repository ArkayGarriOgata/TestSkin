// ----------------------------------------------------
// Object Method: [Finished_Goods_SizeAndStyles].Input.imgButton3
// ----------------------------------------------------

If ([Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!)  //then set the date to mark as done
	If ([Finished_Goods_SizeAndStyles:132]SquareInches:48>0)
		[Finished_Goods_SizeAndStyles:132]DateDone:6:=4D_Current_date
		[Finished_Goods_SizeAndStyles:132]DoneBy:10:=<>zResp
		OBJECT SET ENABLED:C1123(*; "img@"; False:C215)
		SetObjectProperties(""; ->bSetDone; True:C214; "Un-Done")  // Modified by: Mark Zinke (5/13/13)
		OBJECT SET ENABLED:C1123(bSetDone; True:C214)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		//uConfirm ("Have you put "+[Finished_Goods_SizeAndStyles]FileOutlineNum+".pdf into the EngDraw directory?";"OK";"Help")
	Else 
		uConfirm("Please enter the Square Inches to be used when estimating with this S&S."; "OK"; "Help")
		GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]SquareInches:48)
	End if 
	
Else 
	[Finished_Goods_SizeAndStyles:132]DateDone:6:=!00-00-00!
	SetObjectProperties(""; ->bSetDone; True:C214; "Done")  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(*; "img@"; True:C214)
	SetObjectProperties("img@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(bShowOL; True:C214)
	If ([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4#0)
		$startTime:=String:C10(TS2Time([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); HH MM AM PM:K7:5)
		SetObjectProperties(""; ->bSetStart; True:C214; $startTime)  // Modified by: Mark Zinke (5/13/13)
	End if 
	OBJECT SET ENABLED:C1123(bSetStart; True:C214)
End if 