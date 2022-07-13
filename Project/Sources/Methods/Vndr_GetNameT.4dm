//%attributes = {}
//Method:  Vndr_GetNameT(tVendorID)=>tVendorName
//Description:  This method will return the vendor name

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tVendorID)
	C_TEXT:C284($0; $tVendorName)
	
	C_OBJECT:C1216($esVendor)
	C_OBJECT:C1216($eVendor)
	
	$tVendorID:=$1
	
	$tVendorName:=CorektBlank
	
	$esVendor:=New object:C1471()
	$eVendor:=New object:C1471()
	
End if   //Done initialize

If ($tVendorID#CorektBlank)  //VendorID
	
	$esVendor:=ds:C1482.Vendors.query("ID = :1"; $tVendorID)
	
	Case of   //Unique
			
		: ($esVendor=Null:C1517)
		: ($esVendor.length#1)
			
		Else   //Valid
			
			$eVendor:=$esVendor.first()
			
			$tVendorName:=$eVendor.Name
			
	End case   //Done unique
	
End if   //Done vendorID

$0:=$tVendorName