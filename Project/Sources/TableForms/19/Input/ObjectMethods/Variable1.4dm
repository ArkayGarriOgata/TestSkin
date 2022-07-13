// Modified by: Garri Ogata (9/21/21) added EsCS_SetItemT ()

C_LONGINT:C283($temp)

$temp:=Num:C11(Request:C163("Enter the new item number: "; [Estimates_Carton_Specs:19]Item:1; "Change"; "Cancel"))
If (ok=1)
	If ($temp>0) & ($temp<100)
		[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT($temp)
		//[Estimates_Carton_Specs]Item:=String($temp;"00")
		Estimate_ReCalcNeeded
		uConfirm("You need to apply this change to each differential and rebuild the forms that use"+" this item."; "OK"; "Help")
	Else 
		uConfirm("Enter a number greater than zero and less then 100."; "OK"; "Help")
	End if 
End if 