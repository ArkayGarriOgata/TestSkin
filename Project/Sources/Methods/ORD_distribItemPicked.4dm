//%attributes = {"publishedWeb":true}
//ORD_distribItemPicked 9/13/01 mlb

If (aBullet{aBullet}="•")
	aBullet{aBullet}:=""
	rDistributed:=rDistributed+aCost{aBullet}
Else 
	aBullet{aBullet}:="•"
	rDistributed:=rDistributed-aCost{aBullet}
End if 