//(S) [CONTROL]SelectFile'bup
If (aCustName-1>=1)
	aCustName:=aCustName-1
	aCustID:=aCustID-1
	aBullet:=aBullet-1
	sGetCustInfo(aCustName; "*")
End if 