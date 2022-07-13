Form:C1466.editEntity.Mode:=util_ComboBoxAction(->aMode; aMode{0})

If (Position:C15("AIR"; Form:C1466.editEntity.Mode)>0)
	Form:C1466.editEntity.Air_Shipment:=True:C214
Else 
	Form:C1466.editEntity.Air_Shipment:=False:C215
End if 

If (Length:C16(Form:C1466.editEntity.Mode)>0)
	If (Form:C1466.editEntity.Milestones=Null:C1517)
		Form:C1466.editEntity.Milestones:=New object:C1471
	End if 
	Form:C1466.editEntity.Milestones.BKC:=String:C10(Current date:C33; Internal date short special:K1:4)
	
	
	// Modified by: Mel Bohince (7/21/20) pass the mode off to the BOL
	C_LONGINT:C283($loadNumber)
	$loadNumber:=Num:C11(Form:C1466.editEntity.Mode)
	Form:C1466.editEntity.RemarkLine2:=String:C10(Abs:C99($loadNumber))  //get the number
	Form:C1466.editEntity.RemarkLine1:=Replace string:C233(Form:C1466.editEntity.Mode; String:C10($loadNumber); "")  //remove the number
	Form:C1466.editEntity.RemarkLine1:=Replace string:C233(Form:C1466.editEntity.RemarkLine1; "-"; "")  //remove the hyphen
	
End if 
