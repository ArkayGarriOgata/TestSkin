//%attributes = {"publishedWeb":true}
//(p) fLimitRecAccess
C_POINTER:C301($1)
C_TEXT:C284($sFile)
C_LONGINT:C283($0; $fileNum)
$filePtr:=$1

If (<>fisCoord | <>fisSalesRep)
	
	$sFile:=Table name:C256($filePtr)
	$fileNum:=Table:C252($filePtr)
	CREATE SET:C116($filePtr->; "JustSelected"+String:C10($fileNum))
	Case of 
		: ($sFile="CUSTOMER")
			INTERSECTION:C121("◊MyCustomers"; "JustSelected"+String:C10($fileNum); "JustSelected"+String:C10($fileNum))
		: ($sFile="ESTIMATE")
			INTERSECTION:C121("◊MyEstimates"; "JustSelected"+String:C10($fileNum); "JustSelected"+String:C10($fileNum))
		: ($sFile="CustomerOrders")
			INTERSECTION:C121("◊MyOrders"; "JustSelected"+String:C10($fileNum); "JustSelected"+String:C10($fileNum))
		: ($sFile="SALESMAN")
			INTERSECTION:C121("◊MySales"; "JustSelected"+String:C10($fileNum); "JustSelected"+String:C10($fileNum))
	End case 
	USE SET:C118("JustSelected"+String:C10($fileNum))
	CLEAR SET:C117("JustSelected"+String:C10($fileNum))
End if 

$0:=Records in selection:C76($filePtr->)
//