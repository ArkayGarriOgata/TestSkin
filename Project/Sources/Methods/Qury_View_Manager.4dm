//%attributes = {}
//Method: Qury_View_Manager(tPhase{;tRow})
//Description:  This method will manage objects in the form
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_TEXT:C284($2; $tRow)
	
	C_BOOLEAN:C305($bStatic; $bEnterable)
	C_COLLECTION:C1488($cObject)
	C_COLLECTION:C1488($cObjectNotUsed)
	
	C_TEXT:C284($tObject)
	C_LONGINT:C283($nRow; $nLastRow)
	
	$tPhase:=$1
	
	If (Count parameters:C259>=2)
		$tRow:=$2
	End if 
	
	$nRow:=0
	$nLastRow:=0
	
	$bStatic:=OB Is defined:C1231(Form:C1466; "cQuery")
	$bEnterable:=($tPhase="Core_Qury_Add")
	
	If ($bStatic)  //Static
		
		$nLastRow:=Form:C1466.cQuery.length
		
		$cObject:=New collection:C1472(\
			"tFieldStatic"; \
			"tCriteria"; \
			"tCriterion"; \
			"tConjunction")
		
		$cObjectNotUsed:=New collection:C1472(\
			"tField"; \
			"Core_atQury_Criterion"; \
			"Qury_View_atConjunction")
		
	Else   //Modify
		
		$cObject:=New collection:C1472(\
			"tField"; \
			"tCriteria"; \
			"Core_atQury_Criterion"; \
			"Qury_View_atConjunction")
		
		$cObjectNotUsed:=New collection:C1472(\
			"tFieldStatic"; \
			"tCriterion"; \
			"tConjunction")
		
	End if   //Done static
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		For each ($tObject; $cObjectNotUsed)  //Not used
			
			For ($nRow; 0; CoreknQuryRowMax)  //Row
				
				OBJECT SET VISIBLE:C603(*; ($tObject+String:C10($nRow)); False:C215)
				
				OBJECT SET ENTERABLE:C238(*; ($tObject+String:C10($nRow)); False:C215)
				
			End for   //Done row
			
			OBJECT SET VISIBLE:C603(*; "Core_nQury_Remove"; False:C215)
			
		End for each   //Done not used
		
		If ($bStatic)  //Assign
			
			$nRow:=0
			
			For each ($oQuryDefined; Form:C1466.cQuery)  //Row
				
				For each ($tQuryProperty; $oQuryDefined)  //Property
					
					$tObjectName:=$tQuryProperty+String:C10($nRow)
					
					$pObject:=OBJECT Get pointer:C1124(Object named:K67:5; $tObjectName)
					
					$pObject->:=OB Get:C1224($oQuryDefined; $tQuryProperty)
					
					OBJECT SET VISIBLE:C603(*; $tObjectName; True:C214)
					
				End for each   //Done property
				
				$nRow:=$nRow+1
				
			End for each   //Done row
			
			For ($nRow; $nLastRow; CoreknQuryRowMax)  //Hide
				
				OBJECT SET VISIBLE:C603(*; ("tFieldStatic"+String:C10($nRow)); False:C215)
				OBJECT SET ENTERABLE:C238(*; ("tFieldStatic"+String:C10($nRow)); False:C215)
				
				OBJECT SET VISIBLE:C603(*; ("tCriterion"+String:C10($nRow)); False:C215)
				OBJECT SET ENTERABLE:C238(*; ("tCriterion"+String:C10($nRow)); False:C215)
				
				OBJECT SET VISIBLE:C603(*; ("tCriteria"+String:C10($nRow)); False:C215)
				OBJECT SET ENTERABLE:C238(*; ("tCriteria"+String:C10($nRow)); False:C215)
				
				OBJECT SET VISIBLE:C603(*; ("tConjunction"+String:C10($nRow)); False:C215)
				OBJECT SET ENTERABLE:C238(*; ("tConjunction"+String:C10($nRow)); False:C215)
				
			End for   //Done hide
			
			FORM SET SIZE:C891("tConjunction"+String:C10($nLastRow-1); 13; 13)  //The only way to resize the form and see the Criterias assigned to objects
			
		End if   //Done assign
		
	: (($tPhase="Qury_View_Add") | ($tPhase="Qury_View_Remove"))
		
		For each ($tObject; $cObject)  //Object
			
			OBJECT SET VISIBLE:C603(*; ($tObject+$tRow); $bEnterable)
			
		End for each   //Done object
		
End case   //Done phase
