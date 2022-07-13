//FM: MakeOrder() -> 
//@author mlb - 8/28/02  10:47

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties("creating@"; -><>NULL; False:C215)
		i0:=1
		i1:=0
		i2:=0
		i3:=0
		b1:=1
		b2:=0
		
		cb1:=1
		cb2:=0
		cb3:=0
		If (r2=0)
			OBJECT SET ENABLED:C1123(cb2; False:C215)
			cb1:=2
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
				//OBJECT SET ENABLED(bOk;False)
		End case 
		
		vOrd:=0
		SetObjectProperties("order1@"; -><>NULL; False:C215)
		SetObjectProperties("order2@"; -><>NULL; False:C215)
End case 