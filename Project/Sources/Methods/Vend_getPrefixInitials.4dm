//%attributes = {"publishedWeb":true}
//PM: Vend_getPrefixInitials() -> 
//@author mlb - 7/10/02  11:57

C_TEXT:C284($1; $po; $poitem; $vendID)
$vendID:=Vend_getVendorRecord($1)
C_TEXT:C284($0)
$0:=""

If (Records in selection:C76([Vendors:7])=1)
	$0:="{"+Substring:C12([Vendors:7]Name:2; 1; 8)+"}"  // Modified by: Mel Bohince (2/13/17) [Vendors]Prefix
End if 
