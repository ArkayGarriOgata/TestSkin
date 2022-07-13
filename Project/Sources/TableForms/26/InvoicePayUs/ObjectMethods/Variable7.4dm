//Script: bAdd()  092895  MLB
If (asBin#0)
	iTotal:=iTotal-aRel{asBin}
	aQty{asBin}:=aQty{asBin}+aRel{asBin}
	iTotal:=iTotal+iQty
	aRel{asBin}:=iQty
	aQty{asBin}:=aQty{asBin}-aRel{asBin}
	iQty:=0
	asBin:=0
	aQty:=0
	aRel:=0
Else 
	BEEP:C151
	ALERT:C41("Click on a F/G location before entering the quantity.")
End if 
//