//%attributes = {}
//Method:  Arky_Prcs_Process(tBusinessUnitProcess)
//Description:  This method will bring up information about a business unit's processes

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tBusinessUnitProcess)
	
	C_COLLECTION:C1488($cBusinessUnitProcess)
	C_COLLECTION:C1488($cArkyProcess)
	
	ARRAY TEXT:C222($atCategory; 0)
	ARRAY TEXT:C222($atProcess; 0)
	ARRAY TEXT:C222($atPathname; 0)
	ARRAY TEXT:C222($atArkyProcessKey; 0)
	
	C_OBJECT:C1216($esArkyProcess)
	
	C_TEXT:C284($tBusinessUnit; $tProcess)
	C_TEXT:C284($tTableName; $tQuery)
	C_TEXT:C284($tIconBusinessUnit)
	
	$tBusinessUnitProcess:=$1  //BusinessUnit|Process
	
	$cBusinessUnitProcess:=Split string:C1554($tBusinessUnitProcess; CorektPipe; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	$tBusinessUnit:=CorektBlank
	$tProcess:=CorektBlank
	
	If ($cBusinessUnitProcess.length=2)  //Valid BU
		
		$tBusinessUnit:=$cBusinessUnitProcess[0]
		$tProcess:=$cBusinessUnitProcess[1]
		
	End if   //Done valid BU
	
	$tTableName:=Table name:C256(->[Arky_Process:68])
	
	$tQuery:="BusinessUnit="+CorektSingleQuote+$tBusinessUnit+CorektSingleQuote+" And "+\
		"Process="+CorektSingleQuote+$tProcess+CorektSingleQuote
	
	$esArkyProcess:=New object:C1471()
	
End if   //Done initialize

$esArkyProcess:=ds:C1482[$tTableName].query($tQuery)  //Find the BusinessUnit Process

$cArkyProcess:=$esArkyProcess.toCollection()

Arky_Prcs_LoadHList2($cArkyProcess)  //Load the HList

Arky_Prcs_LoadTable($tBusinessUnit)  //Load the structure

$tIconBusinessUnit:=Choose:C955(\
($tBusinessUnit=Form:C1466.ktCustomerService); \
"CustomerService"; \
$tBusinessUnit)  //Change from Customer Service to CustomerService for Icon name

Form:C1466.gBusinessUnit:=Core_Picture_LoadG($tIconBusinessUnit)  //Set the return icon

Form:C1466.tBusinessUnit:=$tBusinessUnit

OBJECT SET TITLE:C194(*; "DocumentTitle"; CorektBlank)

FORM GOTO PAGE:C247(Form:C1466.cPage.indexOf(Form:C1466.ktProcess))
