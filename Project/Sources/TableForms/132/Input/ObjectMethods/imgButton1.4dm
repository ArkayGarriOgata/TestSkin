// ----------------------------------------------------
// Object Method: [Finished_Goods_SizeAndStyles].Input.imgButton1
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If ([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4=0)
	[Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4:=TSTimeStamp
	$startTime:=String:C10(TS2Time([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); HH MM AM PM:K7:5)
	SetObjectProperties(""; ->bSetStart; True:C214; $startTime)
	
Else 
	uConfirm("Already started at "+TS2String([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); "OK"; "Not Started")
	If (ok=0)
		[Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4:=0
		SetObjectProperties(""; ->bSetStart; True:C214; "Start")
	End if 
End if 