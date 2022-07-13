//%attributes = {}
//Method: Core_Math_Sum(oSum)
//Description:  This method will Sum what is passed in

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oSum)
	
	$oSum:=$1
	
	C_BOOLEAN:C305($bSumArray)
	C_BOOLEAN:C305($bSumCollection)
	C_BOOLEAN:C305($bSumEntitySelection)
	C_BOOLEAN:C305($bSumSelection)
	
	C_POINTER:C301($pTable)
	
	$bSumArray:=False:C215
	$bSumCollection:=False:C215
	$bSumEntitySelection:=False:C215
	$bSumSelection:=False:C215
	
	Case of   //Sum what
			
		: (OB Is defined:C1231($oSum; "tSet"))
			
			$bSumSelection:=True:C214
			
	End case   //Done sum what
	
End if   //Done initialize

Case of   //Sum
		
	: ($bSumSelection)
		
		$pTable:=Table:C252(Table:C252($oSum.pValue))
		
		GET HIGHLIGHTED RECORDS:C902($pTable->; $oSum.tSet)
		
		CUT NAMED SELECTION:C334($pTable->; "CurrentSelection")
		
		USE SET:C118($oSum.tSet)
		
		($oSum.pTotal)->:=Sum:C1(($oSum.pValue)->)
		
		USE NAMED SELECTION:C332("CurrentSelection")
		
		HIGHLIGHT RECORDS:C656($pTable->; $oSum.tSet)
		
	: ($bSumEntitySelection)
		
	: ($bSumCollection)
		
	: ($bSumArray)
		
End case   //Done sum
