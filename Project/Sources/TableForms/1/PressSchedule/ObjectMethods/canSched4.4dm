
If (rReal1>0) & (rReal1<201)
	//in range
Else 
	uConfirm("Efficiency needs to be between 1 and 200."; "OK"; "Help")
	rReal1:=100
	GOTO OBJECT:C206(rReal1)
End if 
