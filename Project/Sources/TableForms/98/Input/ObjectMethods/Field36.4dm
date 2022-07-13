// ----------------------------------------------------
// Object Method: [Finished_Goods_Specifications].Input.Field36
// ----------------------------------------------------

If ([Finished_Goods:26]Status:14="Final")
	If (Not:C34(User in group:C338(Current user:C182; "Planners")))
		BEEP:C151
		ALERT:C41("Only planners can change the status to 'Final'.")
		[Finished_Goods:26]Status:14:=Old:C35([Finished_Goods:26]Status:14)
	Else 
		mbLock1:=1
		mbLock2:=0
		uSetEntStatus(->[Finished_Goods:26]; False:C215)
		SetObjectProperties(""; ->[Finished_Goods:26]Notes:20; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		
		ARRAY TEXT:C222(aBrand; 1)
		aBrand{1}:=[Finished_Goods:26]Line_Brand:15
		aBrand:=1
	End if 
End if 