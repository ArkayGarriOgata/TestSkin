// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/05/13, 12:39:31
// ----------------------------------------------------
// Form Method: [Finished_Goods_Locations].PlusMinusDelete
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		For ($i; 1; Size of array:C274(abDelete))
			abDelete{$i}:=False:C215
		End for 
		
		OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
		
		LISTBOX SELECT ROW:C912(abJobits; 0; lk remove from selection:K53:3)
		
End case 
