//%attributes = {}
//Method:  Adrs_FormatT(tStyle;tAddressID)=>tFormattedAddress
//Description:  This method will format an address
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tStyle)
	C_TEXT:C284($2; $tAddressID)
	C_TEXT:C284($0; $tFormattedAddress)
	
	C_OBJECT:C1216($oAddress)
	
	$tStyle:=$1
	$tAddressID:=$2
	
	$tFormattedAddress:=CorektBlank
	
	$oAddress:=New object:C1471()
	
End if   //Done initialize

$oAddress:=Adrs_GetAddressO($tAddressID)

Case of   //Style
	: (Not:C34(OB Is defined:C1231($oAddress; "Name")))
	: (Not:C34(OB Is defined:C1231($oAddress; "Address1")))
	: (Not:C34(OB Is defined:C1231($oAddress; "City")))
	: (Not:C34(OB Is defined:C1231($oAddress; "Zip")))
		
	: ($tStyle=AdrsktGetName)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Name#CorektBlank); \
			$oAddress.Name; CorektBlank)
		
	: ($tStyle=AdrsktStyleFlat)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Address1#CorektBlank); \
			$oAddress.Address1; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Address2#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.Address2; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Address3#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.Address3; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.City#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.City; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.State#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.State; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Zip#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.Zip; CorektBlank)
		
		$tFormattedAddress:=$tFormattedAddress+\
			Choose:C955(($oAddress.Country#CorektBlank); \
			CorektComma+CorektSpace+$oAddress.Country; CorektBlank)
		
End case   //Done Style

$0:=$tFormattedAddress
