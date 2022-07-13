//%attributes = {}
//Method:  Ship_Invc_ForeignB(tConsigneeAddressID)=>bPrinted
//Description:  This method will print a foreign invoice if needed

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tConsigneeAddressID)
	C_BOOLEAN:C305($0; $bPrinted)
	
	C_OBJECT:C1216($oAddress)
	
	ARRAY TEXT:C222($atMethodName; 0)
	
	$tConsigneeAddressID:=$1
	
	$oAddress:=New object:C1471()
	
	$oAddress:=Adrs_GetAddressO($tConsigneeAddressID)
	
	METHOD GET NAMES:C1166($atMethodName)
	
	$bPrinted:=False:C215
	
End if   //Done initialize

Case of   //Execute
		
	: (OB Is empty:C1297($oAddress))
	: (Find in array:C230($atMethodName; "Ship_Invc_"+$oAddress.Country)=CoreknNoMatchFound)
		
	Else   //Run it
		
		EXECUTE METHOD:C1007("Ship_Invc_"+$oAddress.Country+"Print")
		
		$bPrinted:=True:C214
		
End case   //Done execute

$0:=$bPrinted