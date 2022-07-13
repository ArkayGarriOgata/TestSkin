//%attributes = {}
//Core_Field_GetFieldNumberN(nTableNumber;tFieldName)=>nFieldNumber
//Description:

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTableNumber)
	C_TEXT:C284($2; $tFieldName)
	C_LONGINT:C283($0; $nFieldNumber)
	
	$nTableNumber:=$1
	$tFieldName:=$2
	
	$nFieldNumber:=0
	
End if   //Done initialize

$nNumberOfFields:=Get last field number:C255($nTableNumber)

For ($nField; 1; $nNumberOfFields)  //Field
	
	Case of   //Match
			
		: (Not:C34(Is field number valid:C1000($nTableNumber; $nField)))  //Not valid
		: (Not:C34($tFieldName=Field name:C257($nTableNumber; $nField)))  //Not match
			
		Else   //Equal
			
			$nFieldNumber:=$nField
			$nField:=$nNumberOfFields+1
			
	End case   //Done match
	
End for   //Done field

$0:=$nFieldNumber