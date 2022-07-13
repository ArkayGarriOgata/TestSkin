//%attributes = {}
//Method:  Arcv_View_Table
//Description: This method will display the [Archive]RecordRow data
//. v18 use OB Entries or OB Values possibly

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nColumn; $nRow)
	C_TEXT:C284($tQuery)
	C_TEXT:C284($tProperty)
	
	C_OBJECT:C1216($esRecordRow)
	C_OBJECT:C1216($eRecordRow)
	
	$nColumn:=0
	$nRow:=0
	$tQueryf:=CorektBlank
	$tProperty:=CorektBlank
	
	$esRecordRow:=New object:C1471()
	$eRecordRow:=New object:C1471()
	
End if   //Done initialize

LISTBOX GET CELL POSITION:C971(Arcv_abView_Table; $nColumn; $nRow)

If ($nRow>0)  //Row
	
	$tQuery:="Archive_Key="+CorektSingleQuote+Arcv_atView_Column01{$nRow}+CorektSingleQuote
	
	$esRecordRow:=ds:C1482.Archive.query($tQuery)
	
	If ($esRecordRow.length=1)  //Selection
		
		Compiler_Arcv_Array(Current method name:C684; 0)
		
		For each ($eRecordRow; $esRecordRow.RecordRow)  //Record
			
			ARRAY TEXT:C222($atProperty; 0)
			
			OB GET PROPERTY NAMES:C1232($eRecordRow; $atProperty)
			
			For ($nProperty; 1; Size of array:C274($atProperty))
				
				$tProperty:=$atProperty{$nProperty}
				
				APPEND TO ARRAY:C911(Arcv_atView_Field; $tProperty)
				APPEND TO ARRAY:C911(Arcv_atView_Value; OB Get:C1224($eRecordRow; $tProperty; Is text:K8:3))
				
			End for 
			
		End for each   //Done record
		
	End if   //Done selection
	
End if   //Done row





