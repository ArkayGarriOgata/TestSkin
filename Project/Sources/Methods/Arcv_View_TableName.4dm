//%attributes = {}
//Method:  Arcv_View_TableName(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_TEXT:C284($tQuery)
	
	C_LONGINT:C283($nTableNumber)
	
	C_COLLECTION:C1488($cTableNumber)
	
	C_OBJECT:C1216($esRecords)
	
	$tPhase:=$1
	
	$tQuery:=CorektBlank
	$nTableNumber:=0
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		Form:C1466.tTableName:=Arcv_atView_TableName{Arcv_atView_TableName}
		
		$nTableNumber:=Core_Table_GetTableNumberN(Form:C1466.tTableName)
		
		If (Is table number valid:C999($nTableNumber))
			
			Compiler_Arcv_Array(Current method name:C684+$tPhase; 0)
			
			$esRecords:=New object:C1471()
			
			$tQuery:="TableNumber=="+String:C10($nTableNumber)
			
			$esRecords:=ds:C1482.Archive.query($tQuery)  //Get rows
			
			Arcv_View_TableFill($nTableNumber; $esRecords)
			
		End if 
		
	: ($tPhase=CorektPhaseInitialize)
		
		Arcv_View_TableName(CorektPhaseClear)
		
		$cTableNumber:=New collection:C1472()
		$cTableNumber:=ds:C1482.Archive.all().distinct("TableNumber")
		
		For each ($nTableNumber; $cTableNumber)
			
			APPEND TO ARRAY:C911(Arcv_atView_TableName; Table name:C256($nTableNumber))
			
		End for each 
		
		SORT ARRAY:C229(Arcv_atView_TableName; >)
		
		Arcv_atView_TableName:=0
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Arcv_Process(Current method name:C684)
		
		Compiler_Arcv_Array(Current method name:C684+$tPhase; 0)
		
		Form:C1466.tTableName:=CorektBlank
		
End case   //Done phase
