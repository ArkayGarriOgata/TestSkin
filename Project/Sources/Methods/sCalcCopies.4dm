//%attributes = {"publishedWeb":true}
//(p) sCalcCopies
//This calculates the number of copies needed to label an entire order +10 spares

If ([WMS_Label_Tracking:75]QtyPerCase:8>0) & (lToShip>0)
	lCopies:=Int:C8(lToShip/[WMS_Label_Tracking:75]QtyPerCase:8)+(1*Num:C11(lToShip%[WMS_Label_Tracking:75]QtyPerCase:8>0))+10
Else 
	lCopies:=0
End if 