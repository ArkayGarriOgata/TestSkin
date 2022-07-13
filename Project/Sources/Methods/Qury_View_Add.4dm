//%attributes = {}
//Method: Qury_View_Add(cQuery)
//Description:  This method will load the arrays
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cQuery)
	
	C_LONGINT:C283($nFieldType; $nLine)
	
	C_OBJECT:C1216($oLine)
	
	C_POINTER:C301($pConjunction; $pCriterion)
	C_POINTER:C301($pField)
	C_POINTER:C301($pCriteria1; $pCriteria2)
	
	C_TEXT:C284($tConjunction; $tCriterion)
	C_TEXT:C284($tFieldName; $tLastLine)
	C_TEXT:C284($tCriteria1; $tCriteria2)
	
	$cQuery:=New collection:C1472()
	$oLine:=New object:C1471()
	
	$cQuery:=$1
	
	$nLine:=0
	
End if   //Done initialize

For each ($oQuery; $cQuery)  //Line
	
	$nFieldType:=0  //Clear
	
	$tFieldName:=CorektBlank
	$tCriterion:=CorektBlank
	$tCriteria1:=CorektBlank
	$tCriteria2:=CorektBlank
	$tConjunction:=CorektBlank
	
	$pField:=OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tField"+String:C10($nLine))
	$pCriterion:=OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tCriterion"+String:C10($nLine))
	$pCriteria1:=OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tCriteria1"+String:C10($nLine))
	$pCriteria2:=OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tCriteria2"+String:C10($nLine))
	$pConjunction:=OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tConjunction"+String:C10($nLine))
	
	$tFieldName:=Field name:C257($oQuery.nTableNumber; $oQuery.nFieldNumber)
	
	$nFieldType:=Type:C295($pField->)
	
	Case of   //Criterion
			
		: ($oQuery.nCriterion=1)
			
			Case of   //Field type
					
				: (($nFieldType=Is text:K8:3) | ($nFieldType=Is alpha field:K8:1) | ($nFieldType=Is date:K8:7) | ($nFieldType=Is boolean:K8:9))
					
					$tCriterion:="="
					
			End case   //Done field type
			
		: ($oQuery.nCriterion=3)
			
			Case of   //Field type
					
				: (($nFieldType=Is text:K8:3) | ($nFieldType=Is alpha field:K8:1) | ($nFieldType=Is date:K8:7) | ($nFieldType=Is boolean:K8:9))
					
					$tCriterion:=">="
					
			End case   //Done field type
			
	End case   //Done criterion
	
	Case of   //Criteria
			
		: (($nFieldType=Is alpha field:K8:1) | ($nFieldType=Is text:K8:3))
			
			$tCriteria1:=$oQuery.tCriteria1
			
			If (OB Is defined:C1231($oQuery; "tCriteria2"))
				$tCriteria2:=$oQuery.tCriteria2
			End if 
			
		: ($nFieldType=Is date:K8:7)
			
			$tCriteria1:=String:C10(Date:C102($oQuery.tCriteria1); System date short:K1:1)
			
			If (OB Is defined:C1231($oQuery; "tCriteria2"))
				$tCriteria2:=String:C10(Date:C102($oQuery.tCriteria2); System date short:K1:1)
			End if 
			
	End case   //Done Criteria
	
	$tConjunction:=Choose:C955(($oQuery.nConjunction=1); "&"; "|")
	
	$pField->:=$tFieldName
	$pCriterion->:=$tCriterion
	$pCriteria1->:=$tCriteria1
	$pCriteria2->:=$tCriteria2
	$pConjunction->:=$tConjunction
	
	$pCriterion->:=$tCriterion
	
	$nLine:=$nLine+1
	
End for each   //Done line

$tLastLine:=String:C10($nLine-1)

OBJECT Get pointer:C1124(Object named:K67:5; "Qury_View_tConjunction"+$tLastLine)->:=CorektBlank

FORM SET SIZE:C891("Qury_View_tConjunction"+$tLastLine; 13; 13)