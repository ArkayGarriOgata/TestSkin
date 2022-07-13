//(S) State
If (Length:C16([Vendors:7]State:8)=2)
	[Vendors:7]State:8:=Uppercase:C13([Vendors:7]State:8)
End if 
[Vendors:7]ModFlag:21:=True:C214
//EOS