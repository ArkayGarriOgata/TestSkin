//%attributes = {}
//Method:  Vndr_OM_Field(pField)
//Description:  This method handles the Field

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pField)
	C_TEXT:C284($tFieldName)
	
	$pField:=$1
	
	$tFieldName:=Field name:C257($pField)
	
End if   //Done Initialize

Case of   //Field
		
	: ($tFieldName="VendorID")  //[Purchase_Orders]VendorID
		
		Vndr_Clairvoyance_VendorId($pField)
		
End case   //Done Field

