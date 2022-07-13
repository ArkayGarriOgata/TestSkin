//%attributes = {}
// Method: FG_LockDown (true or false) -> 
// ----------------------------------------------------
// by: mel: 02/11/04, 10:36:11
// ----------------------------------------------------

C_BOOLEAN:C305($1)

If ($1)  //lock down changes
	mbLock1:=1
	mbLock2:=0
	
	ARRAY TEXT:C222(aBrand; 1)
	aBrand{1}:=[Finished_Goods:26]Line_Brand:15
	aBrand:=1
	aBrand{0}:=aBrand{1}
	OBJECT SET ENABLED:C1123(aBrand; False:C215)
	OBJECT SET ENABLED:C1123(b_dummy; False:C215)
	If (iMode<3)
		//If ([Finished_Goods]Status#"FINAL")
		//[Finished_Goods]Status:="FINAL"
		//End if 
	End if 
	SetObjectProperties("lock@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
	SetObjectProperties("leaf@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(*; "lock@"; False:C215)
	
Else   //allow changes
	If (User in group:C338(Current user:C182; "Planners"))
		mbLock1:=0
		mbLock2:=1
		GOTO OBJECT:C206([Finished_Goods:26]CartonDesc:3)
		SetObjectProperties("lock@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties("leaf@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/6/13)
		
		uBuildBrandList(->[Finished_Goods:26]Line_Brand:15)
		OBJECT SET ENABLED:C1123(aBrand; True:C214)
		OBJECT SET ENABLED:C1123(b_dummy; True:C214)
		OBJECT SET ENABLED:C1123(*; "lock@"; True:C214)
		
	Else 
		BEEP:C151
		ALERT:C41("Lock Status can only be removed by a Planner.")
		mbLock1:=1
		mbLock2:=0
	End if 
End if 

FG_SecuredFields  //***Special fields and buttons