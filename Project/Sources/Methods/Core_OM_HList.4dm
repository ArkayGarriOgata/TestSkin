//%attributes = {}
//Method:  Core_OM_HList (pHList;tFormName)
//Description:  This method runs the code for the HLists in the Core module

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $pHList)
	C_TEXT:C284($2; $tFormName)
	
	C_TEXT:C284($tHListName)
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nFormEvent)
	
	$pHList:=$1
	$tFormName:=$2
	
	RESOLVE POINTER:C394($pHList; $tHListName; $nTable; $nField)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done Initialize

Case of   //What form and HList
		
	: (($tFormName="Core_VdVl") & ($tHListName="CorenHList1"))
		
		Core_VdVl_HList
		
End case   //Done what form and HList