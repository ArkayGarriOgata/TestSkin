//%attributes = {}
//Method:  Core_Query_UniqueRecordB(pField;pValue{;poUnique})=>True if unique
//Descripiton:  This will return true if it finds a unique record

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pField; $2; $pValue)
	C_POINTER:C301($3; $poUnique)
	C_BOOLEAN:C305($0; $bUnique)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_OBJECT:C1216($esUnique)
	C_POINTER:C301($pTable)
	
	$pField:=$1
	$pValue:=$2
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=3)
		
		$poUnique:=$3
		
	End if 
	
	$pTable:=Table:C252(Table:C252($pField))
	
	$bUnique:=False:C215
	
	$esUnique:=New object:C1471()
	
	$tTableName:=Table name:C256($pTable)
	
	$tQuery:=Field name:C257($pField)+"="+Core_Convert_ToTextT($pValue->)
	
End if   //Done Initialize

Case of   //Classic or ORDA
		
	: ($nNumberOfParameters=2)  //Classic
		
		QUERY:C277($pTable->; $pField->=$pValue->)
		
		$bUnique:=(Records in selection:C76($pTable->)=1)
		
	: ($nNumberOfParameters=3)  //ORDA
		
		$esUnique:=ds:C1482[$tTableName].query($tQuery)
		
		Case of   //Unique
				
			: (OB Is empty:C1297($esUnique))
			: ($esUnique.length#1)
				
			Else 
				
				$bUnique:=True:C214
				$eUnique:=$esUnique.first()
				
				$poUnique->:=$eUnique.toObject()
				
		End case   //Done unique
		
End case   //Done classic or ORDA

$0:=$bUnique