$i:=Find in array:C230(aSelected; "X")
If ((asDiff2>0) & ($i>0))
	ACCEPT:C269
Else 
	ALERT:C41("You must highlight a Source Differential and 'X' "+"at least New PSpec Group.")
End if 
