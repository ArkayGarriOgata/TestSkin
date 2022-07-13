//Script: puLines
//040596

If (Self:C308->>1)
	If (srb1=1)
		srb1:=0
		srb3:=1
	End if 
	OBJECT SET ENABLED:C1123(srb1; False:C215)
Else 
	OBJECT SET ENABLED:C1123(srb1; True:C214)
	srb1:=1
	srb2:=0
	srb3:=0
End if 