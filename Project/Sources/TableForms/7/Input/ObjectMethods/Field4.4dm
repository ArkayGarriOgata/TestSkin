//(S) [VENDOR]Name
[Vendors:7]ModFlag:21:=True:C214
//•062295  MLB  UPR 1663 due to de-normalization
//•071095  MLB  UPR 1668
C_TEXT:C284(<>VendId)
C_TEXT:C284(<>VendName)
<>VendId:=[Vendors:7]ID:1
<>VendName:=[Vendors:7]Name:2
uSpawnProcess("uChgVendName"; <>lMinMemPart; "ChgVendorName")
If (False:C215)
	uChgVendName
End if 
//EOS