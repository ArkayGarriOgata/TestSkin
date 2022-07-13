//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/19/08, 12:33:18
// ----------------------------------------------------
// Method: rfc_UpdateByPlanner
// Description:
// Starting with planner fields and buttons, see what should be turned on
// ----------------------------------------------------

Case of 
	: ([Finished_Goods_SizeAndStyles:132]DateDone:6#!00-00-00!)  //WHEN DONE:
		uSetEntStatus(->[Finished_Goods_SizeAndStyles:132]; False:C215)  //get anything that was missed
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]DateApproved:8; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]Approved:9; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->[Finished_Goods_SizeAndStyles:132]GlueAppvNumber:53; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("prod@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->bSubmit; True:C214; "Submitted")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(*; "prod@"; True:C214)  //allow setting of product code and description
		OBJECT SET ENABLED:C1123(bSubmit; False:C215)
		OBJECT SET ENABLED:C1123(bAddRequest; True:C214)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)
		
	: ([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4#0)  //WHEN STARTED
		$startTime:=String:C10(TS2Time([Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4); HH MM AM PM:K7:5)
		SetObjectProperties(""; ->bSetStart; True:C214; $startTime)  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bSubmit; False:C215)  //CAN'T KILL NOW
		
	: ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!)  //WHEN SUBMITTED:
		SetObjectProperties(""; ->bSubmit; True:C214; "Kill")  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bSubmit; True:C214)
		
	: ([Finished_Goods_SizeAndStyles:132]AdditionalRequest:54>0)  //WHEN ADDITIONAL REQUEST:
		//can't change specs or dimensions, can change the following:
		SetObjectProperties("prod@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("plnr@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(*; "prod@"; True:C214)
		OBJECT SET ENABLED:C1123(*; "plnr@"; True:C214)
		OBJECT SET ENABLED:C1123(bShowOL; True:C214)  //should be something available to open
		OBJECT SET ENABLED:C1123(bAddRequest; False:C215)
		rfc_OptionsShow  //open all the options
		
	Else 
		SetObjectProperties("prod@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("spec@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("plnr@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("Dim@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(*; "prod@"; True:C214)  //allow setting of product code and description
		OBJECT SET ENABLED:C1123(*; "spec@"; True:C214)
		OBJECT SET ENABLED:C1123(*; "plnr@"; True:C214)
		OBJECT SET ENABLED:C1123(bAddRequest; False:C215)
		rfc_OptionsShow  //open all the options
End case 