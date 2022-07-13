If (Form:C1466.editEntity.Milestones=Null:C1517)
	Form:C1466.editEntity.Milestones:=New object:C1471
End if 
If (Form:C1466.editEntity.ediASNmsgID=-1)
	Form:C1466.editEntity.Milestones.OPN:=String:C10(Current date:C33; Internal date short special:K1:4)
Else 
	Form:C1466.editEntity.Milestones.OPN:="00-00-00"
End if 