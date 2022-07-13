//%attributes = {}
//Method:  Adrs_GetAddressO(tAddressID)=>oAddress
//Description:  This method will return to oAddress the address parts

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tAddressID)
	C_OBJECT:C1216($0; $oAddress)
	
	C_TEXT:C284($tAddresses)
	
	C_TEXT:C284($tQuery)
	
	C_OBJECT:C1216($esAddress)
	
	$tAddressID:=$1
	
	$tAddresses:=Table name:C256(->[Addresses:30])
	
	$oAddress:=New object:C1471()
	$esAddress:=New object:C1471()
	
	$tQuery:="ID="+CorektSingleQuote+$tAddressID+CorektSingleQuote
	
End if   //Done Initialize

$esAddress:=ds:C1482[$tAddresses].query($tQuery)

If (Not:C34(OB Is empty:C1297($esAddress)))  //Address
	
	$oAddress:=$esAddress.first()
	
End if   //Done address

$0:=$oAddress