//OM: i1() -> 
//@author mlb - 8/28/02  11:01

SetObjectProperties("order@"; -><>NULL; False:C215)
SetObjectProperties("creating@"; -><>NULL; True:C214)
vOrd:=0
OBJECT SET ENABLED:C1123(b1; True:C214)
OBJECT SET ENABLED:C1123(b2; True:C214)
b1:=1

OBJECT SET ENABLED:C1123(cb1; True:C214)
OBJECT SET ENABLED:C1123(cb2; True:C214)
OBJECT SET ENABLED:C1123(cb3; True:C214)
cb1:=1
cb2:=1
cb3:=1
If (r2=0)
	OBJECT SET ENABLED:C1123(cb2; False:C215)
	cb2:=0
End if 

If (r1=0)
	OBJECT SET ENABLED:C1123(cb1; False:C215)
	cb1:=0
End if 

If (r3=0)
	OBJECT SET ENABLED:C1123(cb3; False:C215)
	cb3:=0
End if 

Case of 
	: (cb2=1)  //nothing to bill
		cb1:=0
		cb3:=0
	: (cb1=1)
		cb3:=0
	: (cb3=1)
		//just leave it on        
	Else 
		OBJECT SET ENABLED:C1123(bOk; False:C215)
End case 