//%attributes = {}
//Method:  Vndr_Query_NameN (tVendorName)=>nNumberOfVendors
//Description:  This method will query and return number of vendors found

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tVendorName)
	C_LONGINT:C283($0; $nNumberOfVendors)
	
	$tVendorName:=$1
	$nNumberOfVendors:=0
	
End if   //Done initialize

If (Not:C34(Vndr_Verify_UsingIdB($tVendorName; ->$nNumberOfVendors)))  //Verify VendorID
	
	QUERY:C277([Vendors:7]; [Vendors:7]Name:2=$tVendorName+"@"; *)
	QUERY:C277([Vendors:7];  | ; [Vendors:7]ID:1=$tVendorName+"@")
	
	$nNumberOfVendors:=Records in selection:C76([Vendors:7])
	
End if   //Verify VendorID

$0:=$nNumberOfVendors
