//%attributes = {"publishedWeb":true}
//PM: Vend_getEmailAddress($po|$poitem|$vendid) -> 
//@author mlb - 7/10/02  11:57

C_TEXT:C284($1; $po; $poitem; $vendID)
C_TEXT:C284($0)
$0:=""

$vendID:=Vend_getVendorRecord($1)

If (Records in selection:C76([Vendors:7])=1)
	$0:=[Vendors:7]EmailAddress:34
End if 