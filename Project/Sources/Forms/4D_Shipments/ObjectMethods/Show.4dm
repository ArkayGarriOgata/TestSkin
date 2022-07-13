$Event:=Form event code:C388
Case of 
	: ($Event=On Clicked:K2:4)
		$Pt_courant:=OBJECT Get pointer:C1124(Object current:K67:2)
		C_LONGINT:C283($Pt_courant->)
		If ($Pt_courant->=1)
			OBJECT SET VISIBLE:C603(*; "lb_Shipements_col_Responsable"; True:C214)
		Else 
			OBJECT SET VISIBLE:C603(*; "lb_Shipements_col_Responsable"; False:C215)
		End if 
		
End case 