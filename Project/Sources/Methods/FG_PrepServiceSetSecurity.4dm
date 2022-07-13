//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceSetSecurity() -> 
//@author mlb - 3/7/03  12:26

//turn every thing off first
SetObjectProperties("planners@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
OBJECT SET ENABLED:C1123(*; "planners@"; False:C215)
SetObjectProperties("imaging@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
OBJECT SET ENABLED:C1123(*; "imaging@"; False:C215)
SetObjectProperties("qa@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
OBJECT SET ENABLED:C1123(*; "qa@"; False:C215)
SetObjectProperties("hide@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)//these are obsolete things taht havent been deleted yet
OBJECT SET ENABLED:C1123(*; "hide@"; False:C215)

If ([Finished_Goods_Specifications:98]Hold:62)
	SetObjectProperties("splHold"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties("splHold"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 
OBJECT SET ENABLED:C1123(bDelete; False:C215)

If (User in group:C338(Current user:C182; "Planners"))
	SetObjectProperties("planners@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "planners@"; True:C214)
End if 

If (User in group:C338(Current user:C182; "RoleImaging"))
	SetObjectProperties("imaging@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "imaging@"; True:C214)
End if 

If (User in group:C338(Current user:C182; "RoleQA"))
	SetObjectProperties("qa@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "qa@"; True:C214)
End if 

//If ([FG_Specification]DatePrepDone#!00/00/00!)  `restrict some changes to specs
If ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
	SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties("spec@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(bSubmit; False:C215)
	OBJECT SET ENABLED:C1123(*; "spec@"; False:C215)
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
	OBJECT SET ENABLED:C1123(bValidate; False:C215)
	If (User in group:C338(Current user:C182; "RoleImaging")) | (User in group:C338(Current user:C182; "FGcanDelete"))
		BEEP:C151
		ALERT:C41("Prep has been Submitted on this Control Number."; "Imaging Rules!")
		SetObjectProperties(""; ->[Finished_Goods_Specifications:98]DateSubmitted:5; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		OBJECT SET ENABLED:C1123(bSubmit; True:C214)
		OBJECT SET ENABLED:C1123(bValidate; True:C214)
		//ALERT("Prep is marked as Done on this Control Number.";"OK")
		
	Else 
		BEEP:C151
		ALERT:C41("Prep has been Submitted on this Control Number, "+"you will not be able to save spec changes."; "Limited Access")
		//ALERT("Prep is marked as Done on this Control Number, "+"you will not be able to save spec changes.";"Limited Access")
		UNLOAD RECORD:C212([Finished_Goods:26])
		READ ONLY:C145([Finished_Goods:26])
		LOAD RECORD:C52([Finished_Goods:26])
		UNLOAD RECORD:C212([Prep_Charges:103])
		READ ONLY:C145([Prep_Charges:103])
		LOAD RECORD:C52([Prep_Charges:103])
	End if 
End if 