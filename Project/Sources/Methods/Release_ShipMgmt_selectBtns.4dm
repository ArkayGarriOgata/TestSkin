//%attributes = {}
// _______
// Method: Release_ShipMgmt_selectBtns   ( ) ->
// By: Mel Bohince @ 06/25/20, 09:34:38
// Description
// 
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1) | (Form event code:C388=On Clicked:K2:4)
	If (Form:C1466.selected#Null:C1517)
		$enable:=(Form:C1466.selected.length>0)
		OBJECT SET ENABLED:C1123(*; "select@"; $enable)
	Else 
		OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
	End if 
End if 

