//%attributes = {}


//Method:  Vndr_Verify_UsingIdB(tVendorName;pnNumberOfVendors)=>bDoQuery
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bDoQuery)
	C_POINTER:C301($2; $pnNumberOfVendors)
	C_TEXT:C284($1; $tVendorName)
	
	$tVendorName:=$1
	$pnNumberOfVendors:=$2
	
	$tVerifyVendorName:=String:C10(Num:C11($tVendorName))
	
	$bDoQuery:=False:C215
	
End if   //Done Initialize

Case of   //Verify
	: ($tverifyVendorName=$tVendorName)  //Using a Vendor ID
	: (Length:C16($tVerifyVendorName)<4)  //Make them type in 5 numbers
		
	Else   //Using Vendor ID and typed in 3 numbers
		
		$bDoQuery:=True:C214
		
End case   //Done verify

$0:=$bDoQuery
