//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/19/08, 12:33:43
// ----------------------------------------------------
// Method: rfc_UpdateByImaging
// ----------------------------------------------------

//start with all their stuff on
OBJECT SET ENABLED:C1123(*; "img@"; True:C214)
OBJECT SET ENABLED:C1123(*; "task@"; True:C214)

SetObjectProperties("img@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)

Case of 
	: ([Finished_Goods_SizeAndStyles:132]DateDone:6#!00-00-00!)  //WHEN DONE:
		uSetEntStatus(->[Finished_Goods_SizeAndStyles:132]; False:C215)
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		
		SetObjectProperties(""; ->bSubmit; True:C214; "Submitted")  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bSetDone; True:C214; "Un-Done")  // Modified by: Mark Zinke (5/6/13)
		
		OBJECT SET ENABLED:C1123(*; "img@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "task@"; False:C215)
		OBJECT SET ENABLED:C1123(bSetDone; True:C214)  //let them downgrade the state
		
		If ([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4#0)
			$startTime:=String:C10(TS2Time([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); HH MM AM PM:K7:5)
			SetObjectProperties(""; ->bSetStart; True:C214; $startTime)  // Modified by: Mark Zinke (5/6/13)
		End if 
		OBJECT SET ENABLED:C1123(bSetStart; False:C215)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		
	: ([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4#0)  //WHEN STARTED
		$startTime:=String:C10(TS2Time([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); HH MM AM PM:K7:5)
		SetObjectProperties(""; ->bSetStart; True:C214; $startTime)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bSubmit; True:C214; "Submitted")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		
	: ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!)  //WHEN SUBMITTED:
		SetObjectProperties(""; ->bSubmit; True:C214; "Submitted")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		
	: ([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54>0)  //WHEN ADDITIONAL REQUEST:
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		
End case 