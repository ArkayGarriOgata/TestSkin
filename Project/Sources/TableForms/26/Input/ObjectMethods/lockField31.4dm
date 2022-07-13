// ----------------------------------------------------
// Object Method: [Finished_Goods].Input.lockField31
// ----------------------------------------------------

If ([Finished_Goods:26]StripHoles:38)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowMatl:39; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowGauge:40; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowWth:41; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowHth:42; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	GOTO OBJECT:C206([Finished_Goods:26]WindowMatl:39)
Else 
	[Finished_Goods:26]WindowMatl:39:=""
	[Finished_Goods:26]WindowGauge:40:=0
	[Finished_Goods:26]WindowWth:41:=0
	[Finished_Goods:26]WindowHth:42:=0
	SetObjectProperties(""; ->[Finished_Goods:26]WindowMatl:39; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowGauge:40; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowWth:41; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->[Finished_Goods:26]WindowHth:42; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
End if 