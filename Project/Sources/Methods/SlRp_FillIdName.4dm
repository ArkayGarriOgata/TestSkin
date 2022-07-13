//%attributes = {}
//Method:  SlRp_FillIdName(patSalesRep;patID)
//Description:  This method will fill the arrays with the active
//  SalesReps and ID

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patSalesRep; $2; $patID)
	
	C_COLLECTION:C1488($cSalesReps)
	C_COLLECTION:C1488($cAttribute)
	C_OBJECT:C1216($oSalesRep)
	
	$patSalesRep:=$1
	$patID:=$2
	
	$tTableName:=Table name:C256(->[Salesmen:32])
	
	$tQuery:="Active = True"
	
	$cSalesReps:=New collection:C1472()
	$cAttribute:=New collection:C1472()
	
	$oSalesRep:=New object:C1471()
	
	$cAttribute.push("FirstName")
	$cAttribute.push("LastName")
	$cAttribute.push("ID")
	
End if   //Done initialize

$cSalesReps:=ds:C1482[$tTableName].query($tQuery).toCollection($cAttribute)

For each ($oSalesRep; $cSalesReps)  //SalesReps
	
	$tFirstName:=$oSalesRep.FirstName
	$tLastName:=$oSalesRep.LastName
	
	APPEND TO ARRAY:C911($patSalesRep->; Core_ConcatenateT(CoreknFormatSpace; ->$tFirstName; ->$tLastName))
	APPEND TO ARRAY:C911($patID->; $oSalesRep.ID)
	
End for each   //Done salesreps
