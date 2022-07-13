// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/05/13, 09:40:18
// ----------------------------------------------------
// Form Method: [Finished_Goods_Locations].PlusMinusCheck
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	tJobIt:=""
	OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
	
	LISTBOX SELECT ROW:C912(abJobits; 0; lk remove from selection:K53:3)
	
End if 