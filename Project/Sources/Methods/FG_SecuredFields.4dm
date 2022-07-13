//%attributes = {}
// Method: FG_SecuredFields () -> 
// ----------------------------------------------------
// by: mel: 04/14/05, 11:23:45
// ----------------------------------------------------
// Description:
// Handle the enterability of fields owned by 
// special groups or spl purpose, managed
// independed of planner's lock down
// ----------------------------------------------------
// • mel (1/6/05, 14:38:43)limit who can enter the dates on this screen

If (User in group:C338(Current user:C182; "JobGateKeeper"))
	SetObjectProperties("Tool@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "Tool@"; True:C214)
Else 
	SetObjectProperties("Tool@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "Tool@"; False:C215)
End if 

// • mel (4/13/05, 16:47:30) limit access to the Launch fields on the tooling tab
If (User in group:C338(Current user:C182; "LaunchGateKeeper"))
	SetObjectProperties("Launch@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "Launch@"; True:C214)
Else 
	SetObjectProperties("Launch@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "Launch@"; False:C215)
End if 

SetObjectProperties(""; ->[Finished_Goods:26]Preflight:66; True:C214; ""; User in group:C338(Current user:C182; "RoleImaging"))  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->bResetControl; User in group:C338(Current user:C182; "Planners"))  // Modified by: Mark Zinke (5/6/13)

//Calcuated Fields
SetObjectProperties("calc@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)

//conditional fields
If (Length:C16([Finished_Goods:26]ControlNumber:61)>0)
	SetObjectProperties(""; ->[Finished_Goods:26]OutLine_Num:4; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]ColorSpecMaster:77; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]GlueDirection:104; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]UPC:37; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (Records in selection:C76([Job_Forms_Items:44])>0)
	SetObjectProperties(""; ->[Job_Forms_Items:44]MAD:37; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(b_mad; True:C214)
Else 
	SetObjectProperties(""; ->[Job_Forms_Items:44]MAD:37; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(b_mad; False:C215)
End if 

If (ELC_isEsteeLauderCompany([Finished_Goods:26]CustID:2))
	SetObjectProperties("EL@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties("EL@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
	If ([Finished_Goods:26]CustID:2="00199")
		SetObjectProperties(""; ->[Finished_Goods:26]GSR:79; True:C214)  // Modified by: Mark Zinke (5/6/13)
	End if 
End if 

If ([Finished_Goods:26]StripHoles:38) & (mbLock2=1)  //open
	SetObjectProperties(""; ->[Finished_Goods:26]WindowMatl:39; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowGauge:40; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowWth:41; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowHth:42; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties(""; ->[Finished_Goods:26]WindowMatl:39; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowGauge:40; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowWth:41; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowHth:42; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (User in group:C338(Current user:C182; "FGcanDelete"))
	OBJECT SET ENABLED:C1123(bDelete; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 